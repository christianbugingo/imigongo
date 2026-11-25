// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Puzzle Imigongo';

  @override
  String get geometricReliefPuzzle => 'Puzzle de Relief Géométrique';

  @override
  String get play => 'Jouer';

  @override
  String get settings => 'Paramètres';

  @override
  String get dailyChallenge => 'Défi Quotidien';

  @override
  String get moves => 'Mouvements';

  @override
  String get par => 'Par';

  @override
  String get targetMoves => 'Mouvements Cibles';

  @override
  String get solved => 'Résolu';

  @override
  String starsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Étoiles',
      one: '1 Étoile',
    );
    return '$_temp0';
  }

  @override
  String get rotateInstruction =>
      'Touchez une tuile pour tourner dans le sens horaire';

  @override
  String get colorCharcoal => 'Fusain';

  @override
  String get colorChalk => 'Craie';

  @override
  String get colorTerracotta => 'Terre cuite';

  @override
  String get colorOchre => 'Ocre';

  @override
  String get undo => 'Annuler';

  @override
  String get reset => 'Recommencer';

  @override
  String get inProgress => 'En cours';
}
