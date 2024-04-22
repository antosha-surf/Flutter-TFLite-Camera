import 'dart:io';
import 'dart:ui';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:tflite/l10n/l10n.dart';

/// A Bloc to track app localization choice of a user.
final class LocalesBloc extends HydratedBloc<LocalesEvent, Locale?> {
  LocalesBloc() : super(null) {
    on<ChangeLocale>(_changeLocale);
    on<EnsureLocale>(_ensureLocale);
    add(const EnsureLocale());
  }

  @override
  Locale? fromJson(Map<String, dynamic> json) {
    final lang = json['languageCode'] as String?;
    final country = json['countryCode'] as String?;
    if (lang == null) return null;
    return Locale(lang, country);
  }

  @override
  Map<String, dynamic>? toJson(Locale? state) {
    if (state == null) return null;

    return {
      'languageCode': state.languageCode,
      'countryCode': state.countryCode,
    };
  }

  void _changeLocale(ChangeLocale event, Emitter<Locale?> emit) {
    emit(event.locale);
  }

  void _ensureLocale(EnsureLocale event, Emitter<Locale?> emit) {
    if (state != null) return;

    final localeFromPlatform = Platform.localeName;
    final locale = localeFromPlatform.split('_').first;
    final isSupported = AppLocalizations.supportedLocales.contains(locale);
    if (isSupported) {
      emit(Locale(locale));
    } else {
      emit(const Locale('en'));
    }
  }
}

sealed class LocalesEvent {
  const LocalesEvent();
}

final class ChangeLocale extends LocalesEvent {
  final Locale locale;

  const ChangeLocale(this.locale);
}

final class EnsureLocale extends LocalesEvent {
  const EnsureLocale();
}
