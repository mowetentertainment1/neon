import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/l10n/localizations.dart';
import 'package:neon_framework/src/models/app_implementation.dart';
import 'package:neon_framework/src/settings/widgets/option_settings_tile.dart';
import 'package:neon_framework/src/settings/widgets/settings_category.dart';
import 'package:neon_framework/src/settings/widgets/settings_list.dart';
import 'package:neon_framework/src/theme/dialog.dart';
import 'package:neon_framework/src/utils/confirmation_dialog.dart';

@internal
class AppImplementationSettingsPage extends StatelessWidget {
  const AppImplementationSettingsPage({
    required this.appImplementation,
    super.key,
  });

  final AppImplementation appImplementation;

  @override
  Widget build(final BuildContext context) {
    final appBar = AppBar(
      title: Text(appImplementation.name(context)),
      actions: [
        IconButton(
          onPressed: () async {
            if (await showConfirmationDialog(
              context,
              NeonLocalizations.of(context).settingsResetForConfirmation(appImplementation.name(context)),
            )) {
              appImplementation.options.reset();
            }
          },
          tooltip: NeonLocalizations.of(context).settingsResetFor(appImplementation.name(context)),
          icon: const Icon(MdiIcons.cogRefresh),
        ),
      ],
    );

    final body = SettingsList(
      categories: [
        for (final category in [...appImplementation.options.categories, null]) ...[
          if (appImplementation.options.options.where((final option) => option.category == category).isNotEmpty) ...[
            SettingsCategory(
              title: Text(
                category != null ? category.name(context) : NeonLocalizations.of(context).optionsCategoryOther,
              ),
              tiles: [
                for (final option
                    in appImplementation.options.options.where((final option) => option.category == category)) ...[
                  OptionSettingsTile(option: option),
                ],
              ],
            ),
          ],
        ],
      ],
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: NeonDialogTheme.of(context).constraints,
            child: body,
          ),
        ),
      ),
    );
  }
}