import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  final Locale locale;
  Map<String, String> _localizedStrings;
  NumberFormat _currencyFormatter;
  NumberFormat _amountTextFieldFormatter;

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  AppLocalizations(this.locale) {
    _currencyFormatter = NumberFormat.simpleCurrency(locale: locale.toString());
    _amountTextFieldFormatter = NumberFormat();
    _amountTextFieldFormatter.maximumFractionDigits = 2;
    _amountTextFieldFormatter.minimumFractionDigits = 2;
    _amountTextFieldFormatter.maximumIntegerDigits = 12;
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString('lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
    return true;
  }

  String translate(String key) {
    if (_localizedStrings.containsKey(key)) {
      return _localizedStrings[key];
    } else {
      print('Missing key --> ' + key);
      return key;
    }
  }

  NumberFormat get currencyFormatter => _currencyFormatter;

  NumberFormat get amountTextFieldFormatter => _amountTextFieldFormatter;

  static String dateFormatOf(BuildContext context, DateTime date) => 
    MaterialLocalizations.of(context).formatMediumDate(date) + ' ' + MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(date));
}


class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'it'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = new AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}