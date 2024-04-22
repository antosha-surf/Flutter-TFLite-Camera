import 'dart:ui';

import 'package:tflite/l10n/l10n.dart';

extension AppLocales on Locale {
  String toLangTag(AppLocalizations loc) {
    return switch (languageCode) {
      'en' => 'English',
      'ru' => 'Русский',
      _ => '',
    };
  }
}
