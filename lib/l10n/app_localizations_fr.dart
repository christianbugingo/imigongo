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

  @override
  String get welcomeTitle => 'Bienvenue dans Imigongo';

  @override
  String get welcomeBody =>
      'Un puzzle paisible de lignes à relier. Découvrez-le avec trois petites grilles d’entraînement.';

  @override
  String get learnToPlay => 'Apprendre à jouer';

  @override
  String get skipTutorial => 'Passer le tutoriel';

  @override
  String get howToPlay => 'Comment jouer';

  @override
  String get back => 'Retour';

  @override
  String get resume => 'Reprendre';

  @override
  String get restart => 'Recommencer';

  @override
  String get pause => 'Pause';

  @override
  String get paused => 'En pause';

  @override
  String get home => 'Accueil';

  @override
  String get replay => 'Rejouer';

  @override
  String get nextPuzzle => 'Puzzle suivant';

  @override
  String get nextLesson => 'Leçon suivante';

  @override
  String get finishTutorial => 'Terminer le tutoriel';

  @override
  String get newBest => 'Nouveau record';

  @override
  String get levelComplete => 'Niveau terminé';

  @override
  String get lessonComplete => 'Leçon terminée';

  @override
  String completionAnnouncement(int stars) {
    String _temp0 = intl.Intl.pluralLogic(
      stars,
      locale: localeName,
      other: '$stars étoiles',
      one: '1 étoile',
    );
    return 'Niveau terminé, $_temp0';
  }

  @override
  String freePlayTitle(int size) {
    return 'Jeu libre · $size×$size';
  }

  @override
  String gridSize(int size) {
    return '$size×$size';
  }

  @override
  String tutorialTitle(int number) {
    return 'Tutoriel $number sur 3';
  }

  @override
  String movesValue(int count) {
    return 'Coups : $count';
  }

  @override
  String targetValue(int count) {
    return 'Objectif : $count coups';
  }

  @override
  String tileLabel(int row, int col, String connections) {
    return 'Case à la ligne $row, colonne $col. Connexions : $connections.';
  }

  @override
  String get north => 'nord';

  @override
  String get east => 'est';

  @override
  String get south => 'sud';

  @override
  String get west => 'ouest';

  @override
  String get noConnections => 'aucune';

  @override
  String get ruleOne =>
      'Touchez une case pour la tourner d’un quart de tour dans le sens des aiguilles d’une montre.';

  @override
  String get ruleTwo =>
      'Reliez les lignes pour qu’aucune extrémité ne reste libre ni ne pointe hors de la grille.';

  @override
  String get ruleThree =>
      'Toutes les lignes doivent former un seul motif connecté.';

  @override
  String get ruleFour =>
      'Faites le moins de rotations possible. Atteignez l’objectif de coups pour obtenir trois étoiles.';

  @override
  String get ruleFive => 'Annuler et Recommencer sont toujours gratuits.';

  @override
  String get lessonOne =>
      'Il suffit de tourner une case. Touchez-la pour terminer le motif.';

  @override
  String get lessonTwo =>
      'Reliez chaque extrémité libre. Toutes les lignes doivent appartenir au même motif connecté ; des boucles séparées ne suffisent pas.';

  @override
  String get lessonThree =>
      'Essayez Annuler ou Recommencer, puis résolvez la grille. Atteignez l’objectif de coups pour gagner trois étoiles.';

  @override
  String get tutorialNotice =>
      'Entraînement : ces résultats ne modifient pas vos records en jeu libre.';

  @override
  String get chooseSize => 'Choisissez une grille de jeu libre';

  @override
  String get loading => 'Chargement';

  @override
  String get loadFailed => 'Impossible de charger les préférences du tutoriel.';

  @override
  String get retry => 'Réessayer';

  @override
  String get saveFailed =>
      'Impossible d’enregistrer la fin du tutoriel. Veuillez réessayer.';

  @override
  String get practiceTutorial => 'Refaire le tutoriel';

  @override
  String get sessionBestNote =>
      'Les records en jeu libre sont conservés jusqu’à la fermeture de l’application.';

  @override
  String get developmentBadge => 'DEV';
}
