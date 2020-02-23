import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show  rootBundle;

class JsonLocalizations {
  final Locale _locale;

  JsonLocalizations(this._locale);

  get languageCode => this._locale.languageCode;

  String text(String key) {
    return _localizedValues[this._locale.languageCode][key];
  }

  static JsonLocalizations of(BuildContext context) {
    return Localizations.of<JsonLocalizations>(context, JsonLocalizations);
  }

  static Map<String, dynamic> _localizedValues = Map<String, dynamic>();

  static Future<JsonLocalizations> load(Locale locale) async {
    JsonLocalizations loc = new JsonLocalizations(locale);

    if (!_localizedValues.containsKey(loc.languageCode)) {
      String jsonContent = await rootBundle.loadString("locale/i18n_${loc.languageCode}.json");
      _localizedValues[loc.languageCode] = json.decode(jsonContent);
    }

    return loc;
  }
}