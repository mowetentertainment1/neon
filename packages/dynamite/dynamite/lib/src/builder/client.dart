import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:dynamite/src/builder/resolve_mime_type.dart';
import 'package:dynamite/src/builder/resolve_object.dart';
import 'package:dynamite/src/builder/resolve_type.dart';
import 'package:dynamite/src/builder/state.dart';
import 'package:dynamite/src/helpers/dart_helpers.dart';
import 'package:dynamite/src/helpers/dynamite.dart';
import 'package:dynamite/src/helpers/pattern_check.dart';
import 'package:dynamite/src/models/openapi.dart' as openapi;
import 'package:dynamite/src/models/type_result.dart';
import 'package:source_helper/source_helper.dart';
import 'package:uri/uri.dart';

Iterable<Class> generateClients(
  openapi.OpenAPI spec,
  State state,
) sync* {
  if (spec.paths == null || spec.paths!.isEmpty) {
    return;
  }

  final tags = generateTags(spec);
  yield buildRootClient(spec, state, tags);

  for (final tag in tags) {
    yield buildClient(spec, state, tag);
  }
}

Class buildRootClient(
  openapi.OpenAPI spec,
  State state,
  Set<openapi.Tag> tags,
) =>
    Class(
      (b) {
        final rootTag = spec.tags?.firstWhereOrNull((tag) => tag.name.isEmpty);
        if (rootTag != null) {
          b.docs.addAll(rootTag.formattedDescription);
        }

        b
          ..extend = refer('DynamiteClient', 'package:dynamite_runtime/http_client.dart')
          ..name = r'$Client'
          ..constructors.addAll([
            Constructor(
              (b) => b
                ..docs.add('/// Creates a new `DynamiteClient` for untagged requests.')
                ..requiredParameters.add(
                  Parameter(
                    (b) => b
                      ..name = 'baseURL'
                      ..toSuper = true,
                  ),
                )
                ..optionalParameters.addAll([
                  Parameter(
                    (b) => b
                      ..name = 'baseHeaders'
                      ..toSuper = true
                      ..named = true,
                  ),
                  Parameter(
                    (b) => b
                      ..name = 'httpClient'
                      ..toSuper = true
                      ..named = true,
                  ),
                  Parameter(
                    (b) => b
                      ..name = 'cookieJar'
                      ..toSuper = true
                      ..named = true,
                  ),
                  if (spec.hasAnySecurity) ...[
                    Parameter(
                      (b) => b
                        ..name = 'authentications'
                        ..toSuper = true
                        ..named = true,
                    ),
                  ],
                ]),
            ),
            Constructor(
              (b) => b
                ..docs.add(r'/// Creates a new [$Client] from another [client].')
                ..name = 'fromClient'
                ..requiredParameters.add(
                  Parameter(
                    (b) => b
                      ..name = 'client'
                      ..type = refer('DynamiteClient', 'package:dynamite_runtime/http_client.dart'),
                  ),
                )
                ..initializers.add(
                  const Code('''
super(
  client.baseURL,
  baseHeaders: client.baseHeaders,
  httpClient: client.httpClient,
  cookieJar: client.cookieJar,
  authentications: client.authentications,
)
'''),
                ),
            ),
          ]);

        for (final tag in tags) {
          final client = clientName(tag.name);

          b.fields.add(
            Field(
              (b) => b
                ..docs.addAll(tag.formattedDescription)
                ..name = toDartName(tag.name)
                ..late = true
                ..modifier = FieldModifier.final$
                ..type = refer(client)
                ..assignment = Code('$client(this)'),
            ),
          );
        }

        b.methods.addAll(buildTags(spec, state, null));
      },
    );

Class buildClient(
  openapi.OpenAPI spec,
  State state,
  openapi.Tag tag,
) =>
    Class(
      (b) {
        final name = clientName(tag.name);
        b
          ..docs.addAll(tag.formattedDescription)
          ..name = name
          ..constructors.add(
            Constructor(
              (b) => b
                ..docs.add('/// Creates a new `DynamiteClient` for ${tag.name} requests.')
                ..requiredParameters.add(
                  Parameter(
                    (b) => b
                      ..name = '_rootClient'
                      ..toThis = true,
                  ),
                ),
            ),
          )
          ..fields.add(
            Field(
              (b) => b
                ..name = '_rootClient'
                ..type = refer(r'$Client')
                ..modifier = FieldModifier.final$,
            ),
          );

        b.methods.addAll(buildTags(spec, state, tag.name));
      },
    );

Iterable<Method> buildTags(
  openapi.OpenAPI spec,
  State state,
  String? tag,
) sync* {
  final client = tag == null ? 'this' : '_rootClient';
  final paths = generatePaths(spec, tag);

  for (final pathEntry in paths.entries) {
    for (final operationEntry in pathEntry.value.operations.entries) {
      final httpMethod = operationEntry.key.name;
      final operation = operationEntry.value;
      final operationName = operation.operationId ?? toDartName('$httpMethod-${pathEntry.key}');
      final parameters = [
        ...?pathEntry.value.parameters,
        ...?operation.parameters,
      ]..sort(sortRequiredParameters);
      final name = toMethodName(operationName, tag);

      var responses = <openapi.Response, Set<dynamic>>{};
      if (operation.responses != null) {
        for (final responseEntry in operation.responses!.entries) {
          final statusCode = responseEntry.key;
          final response = responseEntry.value;

          responses[response] ??= {};
          responses[response]!.add(int.tryParse(statusCode) ?? statusCode);
        }

        if (responses.length > 1) {
          print('$operationName uses more than one response schema but we only generate the first one');
          responses = Map.fromEntries([responses.entries.first]);
        }
      }
      final responseEntry = responses.entries.single;
      final operationParameters = <Parameter>[];

      final pathParameters = <openapi.Parameter, TypeResult>{};
      final headerParameters = <openapi.Parameter, TypeResult>{};
      for (final parameter in parameters) {
        final parameterRequired = isRequired(
          parameter.required,
          parameter.schema,
        );

        final result = resolveType(
          spec,
          state,
          toDartName(
            '$operationName-${parameter.name}',
            className: true,
          ),
          parameter.schema!,
          nullable: !parameterRequired,
        );

        if (parameter.$in == openapi.ParameterType.header) {
          headerParameters[parameter] = result;
        } else {
          pathParameters[parameter] = result;
        }

        operationParameters.add(
          Parameter(
            (b) {
              b
                ..named = true
                ..name = toDartName(parameter.name)
                ..required = parameterRequired
                ..type = refer(result.nullableName);
            },
          ),
        );
      }

      ({String mimeType, TypeResult result})? bodyParameter;
      final requestBody = operation.requestBody;
      if (requestBody != null) {
        for (final content in requestBody.content!.entries) {
          if (bodyParameter != null) {
            print('Can not work with multiple mime types right now. Using the first supported.');
            break;
          }

          final mimeType = content.key;
          final mediaType = content.value;

          final dartParameterNullable = isDartParameterNullable(
            requestBody.required,
            mediaType.schema,
          );
          final dartParameterRequired = isRequired(
            requestBody.required,
            mediaType.schema,
          );

          final result = resolveType(
            spec,
            state,
            toDartName('$operationName-request-$mimeType', className: true),
            mediaType.schema!,
            nullable: dartParameterNullable,
          );

          bodyParameter = (mimeType: mimeType, result: result);

          final parameterName = toDartName(result.name);
          operationParameters.add(
            Parameter(
              (b) => b
                ..name = parameterName
                ..type = refer(result.nullableName)
                ..named = true
                ..required = dartParameterRequired,
            ),
          );
        }
      }

      final bodyType = buildBodyType(
        state,
        responseEntry.key,
        spec,
        operationName,
        tag,
      );
      final headersType = buildHeaderType(
        state,
        responseEntry.key,
        spec,
        operationName,
        tag,
      );

      yield Method((b) {
        b
          ..name = '\$${name}_Serializer'
          ..docs.add('/// Builds a serializer to parse the response of [\$${name}_Request].')
          ..annotations.add(refer('experimental', 'package:meta/meta.dart'));

        if (operation.deprecated) {
          b.annotations.add(refer('Deprecated').call([refer("''")]));
        }

        final returnType = TypeReference(
          (b) => b
            ..symbol = 'DynamiteSerializer'
            ..url = 'package:dynamite_runtime/http_client.dart'
            ..types.addAll([
              refer(bodyType.name),
              refer(headersType.name),
            ]),
        );

        b
          ..returns = returnType
          ..lambda = true
          ..body = Code.scope((allocate) {
            final code = StringBuffer('''
${allocate(returnType)}(
  bodyType: ${bodyType.fullType ?? 'null'},
  headersType: ${headersType.fullType ?? 'null'},
  serializers: _\$jsonSerializers,
''');

            final statusCodes = responseEntry.value;
            if (responses.values.isNotEmpty && !statusCodes.contains('default')) {
              code.writeln("validStatuses: const {${statusCodes.join(',')}},");
            }

            code.writeln(')');

            return code.toString();
          });
      });

      yield Method((b) {
        b
          ..name = '\$${name}_Request'
          ..docs.addAll(operation.formattedDescription(name, isRequest: true))
          ..annotations.add(refer('experimental', 'package:meta/meta.dart'));

        if (operation.deprecated) {
          b.annotations.add(refer('Deprecated').call([refer("''")]));
        }

        final requestType = refer('Request', 'package:http/http.dart');

        b
          ..optionalParameters.addAll(operationParameters)
          ..returns = requestType
          ..body = Code.scope((allocate) {
            final code = StringBuffer();

            if (pathParameters.isNotEmpty) {
              code.writeln('final _parameters = <String, Object?>{};');
            }

            for (final parameter in pathParameters.entries) {
              code.writeln(buildParameterSerialization(parameter.value, parameter.key, state, allocate));
            }

            buildUrlPath(pathEntry.key, parameters, code, allocate);

            code
              ..writeln("final _uri = Uri.parse('\${$client.baseURL}\$_path');")
              ..writeln("final _request = ${allocate(requestType)}('$httpMethod', _uri);");

            final acceptHeader = responses.keys
                .map((response) => response.content?.keys)
                .whereNotNull()
                .expand((element) => element)
                .toSet()
                .join(',');

            if (acceptHeader.isNotEmpty) {
              code.writeln("_request.headers['Accept'] = '$acceptHeader';");
            }

            buildAuthCheck(
              state,
              operation,
              spec,
              client,
              code,
            );

            for (final parameter in headerParameters.entries) {
              code.writeln(buildParameterSerialization(parameter.value, parameter.key, state, allocate));
            }

            if (bodyParameter != null) {
              resolveMimeTypeEncode(bodyParameter.mimeType, bodyParameter.result, code);
            }

            code.writeln('return _request;');
            return code.toString();
          });
      });

      yield Method((b) {
        b
          ..name = name
          ..modifier = MethodModifier.async
          ..docs.addAll(operation.formattedDescription(name));

        if (operation.deprecated) {
          b.annotations.add(refer('Deprecated').call([refer("''")]));
        }

        final rawParameters = operationParameters.map((p) => '${p.name}: ${p.name},').join('\n');
        final responseType = TypeReference(
          (b) => b
            ..symbol = 'DynamiteResponse'
            ..types.addAll([
              refer(bodyType.name),
              refer(headersType.name),
            ])
            ..url = 'package:dynamite_runtime/http_client.dart',
        );

        final responseConverterType = refer(
          'ResponseConverter<${bodyType.name}, ${headersType.name}>',
          'package:dynamite_runtime/http_client.dart',
        );

        b
          ..optionalParameters.addAll(operationParameters)
          ..returns = TypeReference(
            (b) => b
              ..symbol = 'Future'
              ..types.add(responseType),
          )
          ..body = Code.scope(
            (allocate) => '''
final _request = \$${name}_Request($rawParameters);
final _response = await $client.send(_request);

final _serializer = \$${name}_Serializer();
final _rawResponse = await ${allocate(responseConverterType)}(_serializer).convert(_response);
return ${allocate(responseType)}.fromRawResponse(_rawResponse);
''',
          );
      });
    }
  }
}

({String name, String? fullType}) buildBodyType(
  State state,
  openapi.Response response,
  openapi.OpenAPI spec,
  String operationName,
  String? tag,
) {
  final identifierBuilder = StringBuffer()
    ..write(operationName)
    ..write('-response');

  final dataType = resolveMimeTypeDecode(
    response,
    spec,
    state,
    toDartName(identifierBuilder.toString(), className: true),
  );

  if (dataType != null) {
    return (name: dataType.name, fullType: dataType.fullType);
  }

  return (name: 'void', fullType: null);
}

({String name, String? fullType}) buildHeaderType(
  State state,
  openapi.Response response,
  openapi.OpenAPI spec,
  String operationName,
  String? tag,
) {
  TypeResult? headersType;
  if (response.headers != null) {
    final identifierBuilder = StringBuffer();
    if (tag != null) {
      identifierBuilder.write(toDartName(tag, className: true));
    }
    identifierBuilder
      ..write(toDartName(operationName, className: true))
      ..write('Headers');
    headersType = resolveObject(
      spec,
      state,
      identifierBuilder.toString(),
      openapi.Schema(
        (b) => b
          ..properties.replace(
            response.headers!.map(
              (headerName, value) => MapEntry(
                headerName.toLowerCase(),
                value.schema!,
              ),
            ),
          ),
      ),
      isHeader: true,
    );
  }

  if (headersType != null) {
    return (name: headersType.name, fullType: headersType.fullType);
  }

  return (name: 'void', fullType: null);
}

void buildUrlPath(
  String path,
  List<openapi.Parameter> parameters,
  StringSink code,
  String Function(Reference) allocate,
) {
  final hasUriParameters = parameters.firstWhereOrNull(
        (parameter) => parameter.$in == openapi.ParameterType.path || parameter.$in == openapi.ParameterType.query,
      ) !=
      null;

  if (!hasUriParameters) {
    code.writeln("const _path = '$path';");
  } else {
    final queryParams = <String>[];
    for (final parameter in parameters) {
      if (parameter.$in != openapi.ParameterType.query) {
        continue;
      }

      // Default to a plain parameter without exploding.
      queryParams.add(parameter.uriTemplate(withPrefix: false) ?? parameter.pctEncodedName);
    }

    final pathBuilder = StringBuffer()..write(path);

    if (queryParams.isNotEmpty) {
      pathBuilder
        ..write('{?')
        ..writeAll(queryParams, ',')
        ..write('}');
    }

    final pattern = pathBuilder.toString();
    // Sanity check the uri at build time.
    try {
      UriTemplate(pattern);
    } on ParseException catch (e) {
      throw Exception('The resulting uri $pattern is not a valid uri template according to RFC 6570. $e');
    }

    code.writeln(
      "final _path = ${allocate(refer('UriTemplate', 'package:uri/uri.dart'))}('$pattern').expand(_parameters);",
    );
  }
}

String buildParameterSerialization(
  TypeResult result,
  openapi.Parameter parameter,
  State state,
  String Function(Reference) allocate,
) {
  final $default = parameter.schema?.$default;
  var defaultValueCode = $default?.value;
  if ($default != null && $default.isString) {
    defaultValueCode = escapeDartString($default.asString);
  }
  final dartName = toDartName(parameter.name);
  final serializedName = '\$$dartName';
  final buffer = StringBuffer();

  if ($default != null) {
    buffer
      ..write('var $serializedName = ${result.serialize(dartName)};')
      ..writeln('$serializedName ??= $defaultValueCode;');
  } else {
    buffer.write('final $serializedName = ${result.serialize(dartName)};');
  }

  if (parameter.schema != null) {
    // TODO: migrate the entire client generation to code_builder
    buildPatternCheck(parameter.schema!, serializedName, dartName).forEach(
      (l) => buffer.writeln(
        l.statement.accept(state.emitter),
      ),
    );
  }

  if (parameter.$in == openapi.ParameterType.header) {
    final encoderRef = refer('HeaderEncoder', 'package:dynamite_runtime/utils.dart');
    final assignment =
        "_request.headers['${parameter.pctEncodedName}'] = ${allocate(encoderRef)}(explode: ${parameter.explode}).convert($serializedName);";

    if ($default == null) {
      buffer
        ..writeln('if ($serializedName != null) {')
        ..writeln(assignment)
        ..writeln('}');
    } else {
      buffer.writeln(assignment);
    }
  } else {
    buffer.writeln("_parameters['${parameter.pctEncodedName}'] = $serializedName;");
  }

  return buffer.toString();
}

void buildAuthCheck(
  State state,
  openapi.Operation operation,
  openapi.OpenAPI spec,
  String client,
  StringSink output,
) {
  final security = operation.security ?? spec.security ?? BuiltList();
  final securityRequirements = security.where((requirement) => requirement.isNotEmpty);
  final isOptionalSecurity = securityRequirements.length != security.length;

  if (securityRequirements.isEmpty) {
    return;
  }

  output
    ..writeln(
      '''
// coverage:ignore-start
final authentication = $client.authentications?.firstWhereOrNull(
    (auth) => switch (auth) {
''',
    )
    ..writeAll(
      securityRequirements.map((requirement) {
        final securityScheme = spec.components!.securitySchemes![requirement.keys.single]!;
        final dynamiteAuth = toDartName(
          'Dynamite-${securityScheme.fullName.join('-')}-Authentication',
          className: true,
        );
        return refer(dynamiteAuth, 'package:dynamite_runtime/http_client.dart')
            .newInstance(const [])
            .accept(state.emitter)
            .toString();
      }),
      ' || \n',
    )
    ..writeln('''
        => true,
      _ => false,
    },
  );

if(authentication != null) {
  _request.headers.addAll(
    authentication.headers,
  );
}
''');

  if (!isOptionalSecurity) {
    output.writeln('''
else {
  throw Exception('Missing authentication for ${securityRequirements.map((r) => r.keys.single).join(' or ')}');
}
''');
  }
  output.writeln('// coverage:ignore-end');
}

Map<String, openapi.PathItem> generatePaths(openapi.OpenAPI spec, String? tag) {
  final paths = <String, openapi.PathItem>{};

  if (spec.paths != null) {
    for (final path in spec.paths!.entries) {
      for (final operationEntry in path.value.operations.entries) {
        final operation = operationEntry.value;
        if ((operation.tags != null && operation.tags!.contains(tag)) ||
            (tag == null && (operation.tags == null || operation.tags!.isEmpty))) {
          paths[path.key] ??= path.value;
          paths[path.key]!.rebuild((b) {
            switch (operationEntry.key) {
              case openapi.PathItemOperation.get:
                b.get.replace(operation);
              case openapi.PathItemOperation.put:
                b.put.replace(operation);
              case openapi.PathItemOperation.post:
                b.post.replace(operation);
              case openapi.PathItemOperation.delete:
                b.delete.replace(operation);
              case openapi.PathItemOperation.options:
                b.options.replace(operation);
              case openapi.PathItemOperation.head:
                b.head.replace(operation);
              case openapi.PathItemOperation.patch:
                b.patch.replace(operation);
              case openapi.PathItemOperation.trace:
                b.trace.replace(operation);
            }
          });
        }
      }
    }
  }

  return paths;
}

Set<openapi.Tag> generateTags(openapi.OpenAPI spec) {
  final tags = <openapi.Tag>[];

  if (spec.paths != null) {
    for (final pathItem in spec.paths!.values) {
      for (final operation in pathItem.operations.values) {
        if (operation.tags != null) {
          tags.addAll(
            operation.tags!.map((name) {
              final tag = spec.tags?.firstWhereOrNull((tag) => tag.name == name);
              return tag ?? openapi.Tag((b) => b..name = name);
            }),
          );
        }
      }
    }
  }

  tags.sort((a, b) => a.name.compareTo(b.name));
  return tags.toSet();
}
