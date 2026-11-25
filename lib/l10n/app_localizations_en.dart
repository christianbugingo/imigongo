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

  @override
  String get welcomeTitle => 'Welcome to Imigongo';

  @override
  String get welcomeBody =>
      'A quiet puzzle of connected lines. Learn with three short practice boards.';

  @override
  String get learnToPlay => 'Learn to play';

  @override
  String get skipTutorial => 'Skip tutorial';

  @override
  String get howToPlay => 'How to Play';

  @override
  String get back => 'Back';

  @override
  String get resume => 'Resume';

  @override
  String get restart => 'Restart';

  @override
  String get pause => 'Pause';

  @override
  String get paused => 'Paused';

  @override
  String get home => 'Home';

  @override
  String get replay => 'Replay';

  @override
  String get nextPuzzle => 'Next puzzle';

  @override
  String get nextLesson => 'Next lesson';

  @override
  String get finishTutorial => 'Finish tutorial';

  @override
  String get newBest => 'New best';

  @override
  String get levelComplete => 'Level complete';

  @override
  String get lessonComplete => 'Lesson complete';

  @override
  String completionAnnouncement(int stars) {
    String _temp0 = intl.Intl.pluralLogic(
      stars,
      locale: localeName,
      other: '$stars stars',
      one: '1 star',
    );
    return 'Level complete, $_temp0';
  }

  @override
  String freePlayTitle(int size) {
    return 'Free Play · $size×$size';
  }

  @override
  String gridSize(int size) {
    return '$size×$size';
  }

  @override
  String tutorialTitle(int number) {
    return 'Tutorial $number of 3';
  }

  @override
  String movesValue(int count) {
    return 'Moves: $count';
  }

  @override
  String targetValue(int count) {
    return 'Target moves: $count';
  }

  @override
  String tileLabel(int row, int col, String connections) {
    return 'Tile at row $row, column $col. Connections: $connections.';
  }

  @override
  String get north => 'north';

  @override
  String get east => 'east';

  @override
  String get south => 'south';

  @override
  String get west => 'west';

  @override
  String get noConnections => 'none';

  @override
  String get ruleOne => 'Tap a tile to turn it a quarter turn clockwise.';

  @override
  String get ruleTwo =>
      'Join the lines so no line ends in the open or points off the board.';

  @override
  String get ruleThree => 'Everything must connect into one single pattern.';

  @override
  String get ruleFour =>
      'Use as few turns as you can. Reach the target moves for three stars.';

  @override
  String get ruleFive => 'Undo and Restart are always free.';

  @override
  String get lessonOne =>
      'One tile needs a turn. Tap it to complete the pattern.';

  @override
  String get lessonTwo =>
      'Match every open end. All lines must belong to one connected pattern; separate loops do not count.';

  @override
  String get lessonThree =>
      'Try Undo or Restart, then solve the board. Meet the target moves to earn three stars.';

  @override
  String get tutorialNotice =>
      'Practice only: these results do not affect your Free Play bests.';

  @override
  String get chooseSize => 'Choose a Free Play grid';

  @override
  String get loading => 'Loading';

  @override
  String get loadFailed => 'Could not load tutorial preferences.';

  @override
  String get retry => 'Retry';

  @override
  String get saveFailed =>
      'Could not remember tutorial completion. Please try again.';

  @override
  String get practiceTutorial => 'Practice the tutorial';

  @override
  String get sessionBestNote => 'Free Play bests last until the app closes.';

  @override
  String get developmentBadge => 'DEV';
}
