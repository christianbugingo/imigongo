// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Imigongo Puzzle';

  @override
  String get geometricReliefPuzzle => 'Geometric Relief Puzzle';

  @override
  String get play => 'Play';

  @override
  String get settings => 'Settings';

  @override
  String get dailyChallenge => 'Daily Challenge';

  @override
  String get moves => 'Moves';

  @override
  String get par => 'Par';

  @override
  String get targetMoves => 'Target Moves';

  @override
  String get solved => 'Solved';

  @override
  String starsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Stars',
      one: '1 Star',
    );
    return '$_temp0';
  }

  @override
  String get rotateInstruction => 'Tap a tile to rotate clockwise';

  @override
  String get colorCharcoal => 'Charcoal';

  @override
  String get colorChalk => 'Chalk';

  @override
  String get colorTerracotta => 'Terracotta';

  @override
  String get colorOchre => 'Ochre';

  @override
  String get undo => 'Undo';

  @override
  String get reset => 'Reset';

  @override
  String get inProgress => 'In progress';
}
