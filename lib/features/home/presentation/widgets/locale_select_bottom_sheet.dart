import 'package:flutter/material.dart';
import 'package:tflite/common/app_locales/app_locales.dart';
import 'package:tflite/l10n/l10n.dart';

class LocaleSelectBottomSheet extends StatelessWidget {
  const LocaleSelectBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 24.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppLocalizations.supportedLocales
              .map(
                (e) => Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop(e);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(e.toLangTag(context.l10n)),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
