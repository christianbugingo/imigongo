// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kinyarwanda (`rw`).
class AppLocalizationsRw extends AppLocalizations {
  AppLocalizationsRw([String locale = 'rw']) : super(locale);

  @override
  String get appTitle => 'Imigongo';

  @override
  String get geometricReliefPuzzle => 'Umukino w\'Ubugeni bw\'Imigongo';

  @override
  String get play => 'Gukina';

  @override
  String get settings => 'Ibyigenewe';

  @override
  String get dailyChallenge => 'Umukoro w\'Umunsi';

  @override
  String get moves => 'Intambwe';

  @override
  String get par => 'Intego';

  @override
  String get targetMoves => 'Intambwe Ziteganyijwe';

  @override
  String get solved => 'Birarangiye';

  @override
  String starsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Inyenyeri $count',
      one: 'Inyenyeri 1',
    );
    return '$_temp0';
  }

  @override
  String get rotateInstruction => 'Kanda ku gasanduku kugira ngo gahindukire';

  @override
  String get colorCharcoal => 'Umukara';

  @override
  String get colorChalk => 'Umweru';

  @override
  String get colorTerracotta => 'Umutuku w\'ibumba';

  @override
  String get colorOchre => 'Umuhondo w\'ibumba';
}
