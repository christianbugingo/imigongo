import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../l10n/app_localizations.dart';

/// App text stays rw. Until native framework translations are reviewed, built-in
/// controls use real English resources with English formatting/plural rules.
const appLocalizationDelegates = <LocalizationsDelegate<dynamic>>[
  _KinyarwandaFrameworkFallback<MaterialLocalizations>(
    GlobalMaterialLocalizations.delegate,
  ),
  _KinyarwandaFrameworkFallback<CupertinoLocalizations>(
    GlobalCupertinoLocalizations.delegate,
  ),
  _KinyarwandaFrameworkFallback<WidgetsLocalizations>(
    GlobalWidgetsLocalizations.delegate,
  ),
  ...AppLocalizations.localizationsDelegates,
];

class _KinyarwandaFrameworkFallback<T> extends LocalizationsDelegate<T> {
  final LocalizationsDelegate<T> englishDelegate;
  const _KinyarwandaFrameworkFallback(this.englishDelegate);

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'rw';

  @override
  Future<T> load(Locale locale) => englishDelegate.load(const Locale('en'));

  @override
  bool shouldReload(_KinyarwandaFrameworkFallback<T> old) => false;
}
