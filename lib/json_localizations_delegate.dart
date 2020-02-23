import 'package:flutter/material.dart';

import 'json_localizations.dart';
import 'locales.dart';

class JsonLocalizationDelegate extends LocalizationsDelegate<JsonLocalizations> {
  const JsonLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => getSupportedLocales().any((e) => e.languageCode == locale.languageCode);

  @override
  Future<JsonLocalizations> load(Locale locale) => JsonLocalizations.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<JsonLocalizations> old) => false;
}