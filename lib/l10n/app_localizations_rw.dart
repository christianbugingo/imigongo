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

  @override
  String get undo => 'Undo [needs native review]';

  @override
  String get reset => 'Reset [needs native review]';

  @override
  String get inProgress => 'In progress [needs native review]';

  @override
  String get welcomeTitle => 'Welcome to Imigongo [needs native review]';

  @override
  String get welcomeBody =>
      'A quiet puzzle of connected lines. Learn with three short practice boards. [needs native review]';

  @override
  String get learnToPlay => 'Learn to play [needs native review]';

  @override
  String get skipTutorial => 'Skip tutorial [needs native review]';

  @override
  String get howToPlay => 'How to Play [needs native review]';

  @override
  String get back => 'Back [needs native review]';

  @override
  String get resume => 'Resume [needs native review]';

  @override
  String get restart => 'Restart [needs native review]';

  @override
  String get pause => 'Pause [needs native review]';

  @override
  String get paused => 'Paused [needs native review]';

  @override
  String get home => 'Home [needs native review]';

  @override
  String get replay => 'Replay [needs native review]';

  @override
  String get nextPuzzle => 'Next puzzle [needs native review]';

  @override
  String get nextLesson => 'Next lesson [needs native review]';

  @override
  String get finishTutorial => 'Finish tutorial [needs native review]';

  @override
  String get newBest => 'New best [needs native review]';

  @override
  String get levelComplete => 'Level complete [needs native review]';

  @override
  String get lessonComplete => 'Lesson complete [needs native review]';

  @override
  String completionAnnouncement(int stars) {
    String _temp0 = intl.Intl.pluralLogic(
      stars,
      locale: localeName,
      other: '$stars stars',
      one: '1 star',
    );
    return 'Level complete, $_temp0 [needs native review]';
  }

  @override
  String freePlayTitle(int size) {
    return 'Free Play · $size×$size [needs native review]';
  }

  @override
  String gridSize(int size) {
    return '$size×$size [needs native review]';
  }

  @override
  String tutorialTitle(int number) {
    return 'Tutorial $number of 3 [needs native review]';
  }

  @override
  String movesValue(int count) {
    return 'Moves: $count [needs native review]';
  }

  @override
  String targetValue(int count) {
    return 'Target moves: $count [needs native review]';
  }

  @override
  String tileLabel(int row, int col, String connections) {
    return 'Tile at row $row, column $col. Connections: $connections. [needs native review]';
  }

  @override
  String get north => 'north [needs native review]';

  @override
  String get east => 'east [needs native review]';

  @override
  String get south => 'south [needs native review]';

  @override
  String get west => 'west [needs native review]';

  @override
  String get noConnections => 'none [needs native review]';

  @override
  String get ruleOne =>
      'Tap a tile to turn it a quarter turn clockwise. [needs native review]';

  @override
  String get ruleTwo =>
      'Join the lines so no line ends in the open or points off the board. [needs native review]';

  @override
  String get ruleThree =>
      'Everything must connect into one single pattern. [needs native review]';

  @override
  String get ruleFour =>
      'Use as few turns as you can. Reach the target moves for three stars. [needs native review]';

  @override
  String get ruleFive =>
      'Undo and Restart are always free. [needs native review]';

  @override
  String get lessonOne =>
      'One tile needs a turn. Tap it to complete the pattern. [needs native review]';

  @override
  String get lessonTwo =>
      'Match every open end. All lines must belong to one connected pattern; separate loops do not count. [needs native review]';

  @override
  String get lessonThree =>
      'Try Undo or Restart, then solve the board. Meet the target moves to earn three stars. [needs native review]';

  @override
  String get tutorialNotice =>
      'Practice only: these results do not affect your Free Play bests. [needs native review]';

  @override
  String get chooseSize => 'Choose a Free Play grid [needs native review]';

  @override
  String get loading => 'Loading [needs native review]';

  @override
  String get loadFailed =>
      'Could not load tutorial preferences. [needs native review]';

  @override
  String get retry => 'Retry [needs native review]';

  @override
  String get saveFailed =>
      'Could not remember tutorial completion. Please try again. [needs native review]';

  @override
  String get practiceTutorial => 'Practice the tutorial [needs native review]';

  @override
  String get sessionBestNote =>
      'Free Play bests last until the app closes. [needs native review]';

  @override
  String get developmentBadge => 'DEV [needs native review]';
}
