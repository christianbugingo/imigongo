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
      'Vos meilleurs résultats en jeu libre sont enregistrés sur cet appareil.';

  @override
  String get developmentBadge => 'DEV';

  @override
  String get chooseDifficulty => 'Choisissez la difficulté du défi';

  @override
  String get easy => 'Facile';

  @override
  String get medium => 'Moyen';

  @override
  String get hard => 'Difficile';

  @override
  String get freePlay => 'Jeu libre';

  @override
  String get challengeSessionNote =>
      'La progression et les bonus gagnés sont enregistrés sur cet appareil. Le jeu libre n’a pas de limite de coups.';

  @override
  String get choosePattern =>
      'Choisissez le motif que vous souhaitez compléter.';

  @override
  String patternNumber(int number) {
    return 'Motif $number';
  }

  @override
  String allowanceValue(int count) {
    return 'Coups disponibles : $count';
  }

  @override
  String bonusIncluded(int count) {
    return 'Comprend $count coups bonus gagnés.';
  }

  @override
  String get patternUnavailable => 'Ce motif n’est pas disponible.';

  @override
  String get patternPreview => 'Observez le motif terminé avant de commencer.';

  @override
  String get previewRule =>
      'Utilisez ce motif comme référence. Tout motif unique et connecté sans extrémité libre est une solution valide.';

  @override
  String get referencePattern => 'Motif de référence terminé';

  @override
  String get referenceHint =>
      'Votre référence reste ici. Touchez-la pour l’agrandir.';

  @override
  String get startPuzzle => 'Commencer le puzzle';

  @override
  String remainingMoves(int count) {
    return 'Coups restants : $count';
  }

  @override
  String bonusReward(int count) {
    return '+$count coups gagnés pour le motif suivant';
  }

  @override
  String get gameOver => 'Partie terminée';

  @override
  String get outOfMoves =>
      'Il ne reste plus de coups. Rejouez ce motif avec tous vos coups disponibles.';

  @override
  String get challengeHelp =>
      'Les défis ont une limite de coups. Résoudre un motif rapporte quatre coups supplémentaires pour le suivant, une seule fois par niveau. Annuler rend un coup tant que la partie est en cours.';

  @override
  String get colorHelp =>
      'Les couleurs sont décoratives. Reliez les connexions, pas les couleurs.';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get soundEnabled => 'Effets sonores';

  @override
  String get volumeLabel => 'Volume';

  @override
  String get previewSound => 'Écouter un aperçu';

  @override
  String get hapticsEnabled => 'Vibrations';

  @override
  String get reduceMotionSetting => 'Réduire les animations';

  @override
  String get languageSetting => 'Langue';

  @override
  String get themeSetting => 'Apparence';

  @override
  String get systemSetting => 'Réglage du système';

  @override
  String get lightSetting => 'Clair';

  @override
  String get darkSetting => 'Sombre';

  @override
  String get resetProgress => 'Effacer la progression';

  @override
  String get resetProgressQuestion =>
      'Effacer les niveaux terminés, les étoiles, les meilleurs scores et les bonus gagnés ? Les paramètres seront conservés.';

  @override
  String get cancelSetting => 'Annuler';

  @override
  String get progressResetDone => 'Progression effacée.';

  @override
  String get settingsSaveError =>
      'Enregistrement impossible. Veuillez réessayer.';

  @override
  String get retrySave => 'Réessayer';

  @override
  String get savingProgress => 'Enregistrement de la progression…';

  @override
  String get progressSaveError =>
      'Le puzzle est résolu, mais la progression n’a pas été enregistrée. Réessayez pour conserver votre résultat.';

  @override
  String get localStorageError =>
      'Impossible d’ouvrir les données locales. Réessayez sans les effacer.';

  @override
  String get savedProgressLabel => 'Progression enregistrée sur cet appareil';

  @override
  String get rwReviewLabel => 'Kinyarwanda — relecture native nécessaire';

  @override
  String get rateGame => 'Évaluer ce jeu';

  @override
  String get rateGameDescription =>
      'Laisser une note ou un avis dans la boutique d’applications.';

  @override
  String get ratingNotReleased =>
      'Disponible après la sortie du jeu dans la boutique d’applications.';

  @override
  String get ratingOpenFailed =>
      'Impossible d’ouvrir la boutique d’applications. Veuillez réessayer.';

  @override
  String get ratingOpening => 'Ouverture de la boutique d’applications…';
}
