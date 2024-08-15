// OpenAPI client generated by Dynamite. Do not manually edit this file.

// ignore_for_file: camel_case_extensions, camel_case_types, cascade_invocations
// ignore_for_file: discarded_futures
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: non_constant_identifier_names, public_member_api_docs
// ignore_for_file: unreachable_switch_case, unused_element

/// Test type resolving Version: 0.0.1.
library; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:typed_data';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart' as _i4;
import 'package:dynamite_runtime/built_value.dart' as _i3;
import 'package:dynamite_runtime/models.dart';
import 'package:dynamite_runtime/utils.dart' as _i1;
import 'package:meta/meta.dart' as _i2;

part 'types.openapi.g.dart';

typedef $Object = dynamic;
typedef ObjectNullable = dynamic;
typedef $String = dynamic;
typedef $Uri = dynamic;
typedef $Uint8List = dynamic;
typedef $List = dynamic;
typedef $Map = dynamic;
typedef $RegExp = dynamic;

@BuiltValue(instantiable: false)
sealed class $BaseInterface {
  @BuiltValueField(wireName: 'bool')
  bool? get $bool;
  int? get integer;
  @BuiltValueField(wireName: 'double')
  double? get $double;
  @BuiltValueField(wireName: 'num')
  num? get $num;
  String? get string;
  @BuiltValueField(wireName: 'content-string')
  ContentString<int>? get contentString;
  @BuiltValueField(wireName: 'string-binary')
  Uint8List? get stringBinary;
  BuiltList<JsonObject>? get list;
  @BuiltValueField(wireName: 'list-never')
  BuiltList<Never>? get listNever;
  @BuiltValueField(wireName: 'list-string')
  BuiltList<String>? get listString;

  /// Rebuilds the instance.
  ///
  /// The result is the same as this instance but with [updates] applied.
  /// [updates] is a function that takes a builder [$BaseInterfaceBuilder].
  $BaseInterface rebuild(void Function($BaseInterfaceBuilder) updates);

  /// Converts the instance to a builder [$BaseInterfaceBuilder].
  $BaseInterfaceBuilder toBuilder();
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($BaseInterfaceBuilder b) {}
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($BaseInterfaceBuilder b) {
    _i1.checkIterable(
      b.listNever,
      'listNever',
      maxItems: 0,
    );
  }
}

abstract class Base implements $BaseInterface, Built<Base, BaseBuilder> {
  /// Creates a new Base object using the builder pattern.
  factory Base([void Function(BaseBuilder)? b]) = _$Base;

  const Base._();

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  factory Base.fromJson(Map<String, dynamic> json) => _$jsonSerializers.deserializeWith(serializer, json)!;

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;

  /// Serializer for Base.
  static Serializer<Base> get serializer => _$baseSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BaseBuilder b) {
    $BaseInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(BaseBuilder b) {
    $BaseInterface._validate(b);
  }
}

@BuiltValue(instantiable: false)
sealed class $DefaultsInterface {
  static final _$$bool = _$jsonSerializers.deserialize(
    true,
    specifiedType: const FullType(bool),
  )! as bool;

  static final _$integer = _$jsonSerializers.deserialize(
    1,
    specifiedType: const FullType(int),
  )! as int;

  static final _$$double = _$jsonSerializers.deserialize(
    1.0,
    specifiedType: const FullType(double),
  )! as double;

  static final _$$num = _$jsonSerializers.deserialize(
    0,
    specifiedType: const FullType(num),
  )! as num;

  static final _$string = _$jsonSerializers.deserialize(
    'default',
    specifiedType: const FullType(String),
  )! as String;

  static final _$contentString = _$jsonSerializers.deserialize(
    '1',
    specifiedType: const FullType(ContentString, [FullType(int)]),
  )! as ContentString<int>;

  static final _$stringBinary = _$jsonSerializers.deserialize(
    '',
    specifiedType: const FullType(Uint8List),
  )! as Uint8List;

  static final _$list = _$jsonSerializers.deserialize(
    const ['default-item', true, 1.0],
    specifiedType: const FullType(BuiltList, [FullType(JsonObject)]),
  )! as BuiltList<JsonObject>;

  static final _$listNever = _$jsonSerializers.deserialize(
    const [],
    specifiedType: const FullType(BuiltList, [FullType(Never)]),
  )! as BuiltList<Never>;

  static final _$listString = _$jsonSerializers.deserialize(
    const ['default-item', 'item'],
    specifiedType: const FullType(BuiltList, [FullType(String)]),
  )! as BuiltList<String>;

  static final _$objectMap = _$jsonSerializers.deserialize(
    const {
      'list': ['list'],
      'string': 'default-item',
      'bool': true,
      'num': 1.0,
    },
    specifiedType: const FullType(JsonObject),
  )! as JsonObject;

  static final _$objectArray = _$jsonSerializers.deserialize(
    const ['default-item', true, 1.0],
    specifiedType: const FullType(JsonObject),
  )! as JsonObject;

  static final _$objectBool = _$jsonSerializers.deserialize(
    true,
    specifiedType: const FullType(JsonObject),
  )! as JsonObject;

  @BuiltValueField(wireName: 'bool')
  bool get $bool;
  int get integer;
  @BuiltValueField(wireName: 'double')
  double get $double;
  @BuiltValueField(wireName: 'num')
  num get $num;
  String get string;
  @BuiltValueField(wireName: 'content-string')
  ContentString<int>? get contentString;
  @BuiltValueField(wireName: 'string-binary')
  Uint8List get stringBinary;
  BuiltList<JsonObject> get list;
  @BuiltValueField(wireName: 'list-never')
  BuiltList<Never> get listNever;
  @BuiltValueField(wireName: 'list-string')
  BuiltList<String> get listString;
  @BuiltValueField(wireName: 'object-map')
  JsonObject get objectMap;
  @BuiltValueField(wireName: 'object-array')
  JsonObject get objectArray;
  @BuiltValueField(wireName: 'object-bool')
  JsonObject get objectBool;

  /// Rebuilds the instance.
  ///
  /// The result is the same as this instance but with [updates] applied.
  /// [updates] is a function that takes a builder [$DefaultsInterfaceBuilder].
  $DefaultsInterface rebuild(void Function($DefaultsInterfaceBuilder) updates);

  /// Converts the instance to a builder [$DefaultsInterfaceBuilder].
  $DefaultsInterfaceBuilder toBuilder();
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($DefaultsInterfaceBuilder b) {
    b.$bool = _$$bool;
    b.integer = _$integer;
    b.$double = _$$double;
    b.$num = _$$num;
    b.string = _$string;
    b.contentString.replace(_$contentString);
    b.stringBinary = _$stringBinary;
    b.list.replace(_$list);
    b.listNever.replace(_$listNever);
    b.listString.replace(_$listString);
    b.objectMap = _$objectMap;
    b.objectArray = _$objectArray;
    b.objectBool = _$objectBool;
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($DefaultsInterfaceBuilder b) {
    _i1.checkIterable(
      b.listNever,
      'listNever',
      maxItems: 0,
    );
  }
}

abstract class Defaults implements $DefaultsInterface, Built<Defaults, DefaultsBuilder> {
  /// Creates a new Defaults object using the builder pattern.
  factory Defaults([void Function(DefaultsBuilder)? b]) = _$Defaults;

  const Defaults._();

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  factory Defaults.fromJson(Map<String, dynamic> json) => _$jsonSerializers.deserializeWith(serializer, json)!;

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;

  /// Serializer for Defaults.
  static Serializer<Defaults> get serializer => _$defaultsSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DefaultsBuilder b) {
    $DefaultsInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(DefaultsBuilder b) {
    $DefaultsInterface._validate(b);
  }
}

@BuiltValue(instantiable: false)
sealed class $AdditionalPropertiesInterface {
  @BuiltValueField(wireName: 'empty_schema_bool')
  BuiltMap<String, JsonObject>? get emptySchemaBool;
  @BuiltValueField(wireName: 'empty_schema')
  BuiltMap<String, JsonObject>? get emptySchema;
  BuiltMap<String, BuiltMap<String, JsonObject>>? get nested;
  @BuiltValueField(wireName: 'Object')
  BuiltMap<String, JsonObject>? get object;
  @BuiltValueField(wireName: 'ObjectNullable')
  BuiltMap<String, JsonObject?>? get objectNullable;
  @BuiltValueField(wireName: 'bool')
  BuiltMap<String, bool>? get $bool;
  BuiltMap<String, int>? get integer;
  @BuiltValueField(wireName: 'double')
  BuiltMap<String, double>? get $double;
  @BuiltValueField(wireName: 'num')
  BuiltMap<String, num>? get $num;
  BuiltMap<String, String>? get string;
  @BuiltValueField(wireName: 'content-string')
  BuiltMap<String, ContentString<int>?>? get contentString;
  @BuiltValueField(wireName: 'string-binary')
  BuiltMap<String, Uint8List>? get stringBinary;
  BuiltMap<String, BuiltList<JsonObject>>? get list;
  @BuiltValueField(wireName: 'list-never')
  BuiltMap<String, BuiltList<Never>>? get listNever;
  @BuiltValueField(wireName: 'list-string')
  BuiltMap<String, BuiltList<String>>? get listString;

  /// Rebuilds the instance.
  ///
  /// The result is the same as this instance but with [updates] applied.
  /// [updates] is a function that takes a builder [$AdditionalPropertiesInterfaceBuilder].
  $AdditionalPropertiesInterface rebuild(void Function($AdditionalPropertiesInterfaceBuilder) updates);

  /// Converts the instance to a builder [$AdditionalPropertiesInterfaceBuilder].
  $AdditionalPropertiesInterfaceBuilder toBuilder();
  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($AdditionalPropertiesInterfaceBuilder b) {}
  @BuiltValueHook(finalizeBuilder: true)
  static void _validate($AdditionalPropertiesInterfaceBuilder b) {}
}

abstract class AdditionalProperties
    implements $AdditionalPropertiesInterface, Built<AdditionalProperties, AdditionalPropertiesBuilder> {
  /// Creates a new AdditionalProperties object using the builder pattern.
  factory AdditionalProperties([void Function(AdditionalPropertiesBuilder)? b]) = _$AdditionalProperties;

  const AdditionalProperties._();

  /// Creates a new object from the given [json] data.
  ///
  /// Use [toJson] to serialize it back into json.
  factory AdditionalProperties.fromJson(Map<String, dynamic> json) =>
      _$jsonSerializers.deserializeWith(serializer, json)!;

  /// Parses this object into a json like map.
  ///
  /// Use the fromJson factory to revive it again.
  Map<String, dynamic> toJson() => _$jsonSerializers.serializeWith(serializer, this)! as Map<String, dynamic>;

  /// Serializer for AdditionalProperties.
  static Serializer<AdditionalProperties> get serializer => _$additionalPropertiesSerializer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdditionalPropertiesBuilder b) {
    $AdditionalPropertiesInterface._defaults(b);
  }

  @BuiltValueHook(finalizeBuilder: true)
  static void _validate(AdditionalPropertiesBuilder b) {
    $AdditionalPropertiesInterface._validate(b);
  }
}

// coverage:ignore-start
/// Serializer for all values in this library.
///
/// Serializes values into the `built_value` wire format.
/// See: [$jsonSerializers] for serializing into json.
@_i2.visibleForTesting
final Serializers $serializers = _$serializers;
final Serializers _$serializers = (Serializers().toBuilder()
      ..addBuilderFactory(const FullType(Base), BaseBuilder.new)
      ..add(Base.serializer)
      ..addBuilderFactory(const FullType(ContentString, [FullType(int)]), ContentStringBuilder<int>.new)
      ..add(ContentString.serializer)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(JsonObject)]), ListBuilder<JsonObject>.new)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(Never)]), ListBuilder<Never>.new)
      ..addBuilderFactory(const FullType(BuiltList, [FullType(String)]), ListBuilder<String>.new)
      ..addBuilderFactory(const FullType(Defaults), DefaultsBuilder.new)
      ..add(Defaults.serializer)
      ..addBuilderFactory(const FullType(AdditionalProperties), AdditionalPropertiesBuilder.new)
      ..add(AdditionalProperties.serializer)
      ..addBuilderFactory(
        const FullType(BuiltMap, [FullType(String), FullType(JsonObject)]),
        MapBuilder<String, JsonObject>.new,
      )
      ..addBuilderFactory(
        const FullType(BuiltMap, [
          FullType(String),
          FullType(BuiltMap, [FullType(String), FullType(JsonObject)]),
        ]),
        MapBuilder<String, BuiltMap<String, JsonObject>>.new,
      )
      ..addBuilderFactory(
        const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
        MapBuilder<String, JsonObject?>.new,
      )
      ..addBuilderFactory(const FullType(BuiltMap, [FullType(String), FullType(bool)]), MapBuilder<String, bool>.new)
      ..addBuilderFactory(const FullType(BuiltMap, [FullType(String), FullType(int)]), MapBuilder<String, int>.new)
      ..addBuilderFactory(
        const FullType(BuiltMap, [FullType(String), FullType(double)]),
        MapBuilder<String, double>.new,
      )
      ..addBuilderFactory(const FullType(BuiltMap, [FullType(String), FullType(num)]), MapBuilder<String, num>.new)
      ..addBuilderFactory(
        const FullType(BuiltMap, [FullType(String), FullType(String)]),
        MapBuilder<String, String>.new,
      )
      ..addBuilderFactory(
        const FullType(BuiltMap, [
          FullType(String),
          FullType.nullable(ContentString, [FullType(int)]),
        ]),
        MapBuilder<String, ContentString<int>?>.new,
      )
      ..addBuilderFactory(
        const FullType(BuiltMap, [FullType(String), FullType(Uint8List)]),
        MapBuilder<String, Uint8List>.new,
      )
      ..addBuilderFactory(
        const FullType(BuiltMap, [
          FullType(String),
          FullType(BuiltList, [FullType(JsonObject)]),
        ]),
        MapBuilder<String, BuiltList<JsonObject>>.new,
      )
      ..addBuilderFactory(
        const FullType(BuiltMap, [
          FullType(String),
          FullType(BuiltList, [FullType(Never)]),
        ]),
        MapBuilder<String, BuiltList<Never>>.new,
      )
      ..addBuilderFactory(
        const FullType(BuiltMap, [
          FullType(String),
          FullType(BuiltList, [FullType(String)]),
        ]),
        MapBuilder<String, BuiltList<String>>.new,
      ))
    .build();

/// Serializer for all values in this library.
///
/// Serializes values into the json. Json serialization is more expensive than the built_value wire format.
/// See: [$serializers] for serializing into the `built_value` wire format.
@_i2.visibleForTesting
final Serializers $jsonSerializers = _$jsonSerializers;
final Serializers _$jsonSerializers = (_$serializers.toBuilder()
      ..add(_i3.DynamiteDoubleSerializer())
      ..addPlugin(_i4.StandardJsonPlugin())
      ..addPlugin(const _i3.HeaderPlugin())
      ..addPlugin(const _i3.ContentStringPlugin()))
    .build();
// coverage:ignore-end