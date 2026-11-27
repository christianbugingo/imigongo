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
  String get sessionBestNote => 'Free Play bests are saved on this device.';

  @override
  String get developmentBadge => 'DEV';

  @override
  String get chooseDifficulty => 'Choose a challenge difficulty';

  @override
  String get easy => 'Easy';

  @override
  String get medium => 'Medium';

  @override
  String get hard => 'Hard';

  @override
  String get freePlay => 'Free Play';

  @override
  String get challengeSessionNote =>
      'Progress and earned bonus moves are saved on this device. Free Play has no move limit.';

  @override
  String get choosePattern => 'Choose the pattern you want to complete.';

  @override
  String patternNumber(int number) {
    return 'Pattern $number';
  }

  @override
  String allowanceValue(int count) {
    return 'Move allowance: $count';
  }

  @override
  String bonusIncluded(int count) {
    return 'Includes $count earned bonus moves.';
  }

  @override
  String get patternUnavailable => 'This pattern is not available.';

  @override
  String get patternPreview => 'Study the completed pattern before you start.';

  @override
  String get previewRule =>
      'Use this as your reference. Any single connected pattern with no loose ends is a valid solution.';

  @override
  String get referencePattern => 'Completed reference pattern';

  @override
  String get referenceHint => 'Your reference stays here. Tap it to enlarge.';

  @override
  String get startPuzzle => 'Start puzzle';

  @override
  String remainingMoves(int count) {
    return 'Moves left: $count';
  }

  @override
  String bonusReward(int count) {
    return '+$count moves earned for the next pattern';
  }

  @override
  String get gameOver => 'Game over';

  @override
  String get outOfMoves =>
      'No moves left. Replay this pattern with a fresh allowance.';

  @override
  String get challengeHelp =>
      'Challenges have a move limit. Solving a pattern earns four extra moves for its next pattern, once per level. Undo returns a move while the attempt is active.';

  @override
  String get colorHelp =>
      'Colors are decorative. Match the connections, not the colors.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get soundEnabled => 'Sound effects';

  @override
  String get volumeLabel => 'Volume';

  @override
  String get previewSound => 'Preview sound';

  @override
  String get hapticsEnabled => 'Haptics';

  @override
  String get reduceMotionSetting => 'Reduce motion';

  @override
  String get languageSetting => 'Language';

  @override
  String get themeSetting => 'Appearance';

  @override
  String get systemSetting => 'System default';

  @override
  String get lightSetting => 'Light';

  @override
  String get darkSetting => 'Dark';

  @override
  String get resetProgress => 'Reset progress';

  @override
  String get resetProgressQuestion =>
      'Erase completed levels, stars, best moves and earned bonuses? Settings will be kept.';

  @override
  String get cancelSetting => 'Cancel';

  @override
  String get progressResetDone => 'Progress erased.';

  @override
  String get settingsSaveError => 'Could not save. Please retry.';

  @override
  String get retrySave => 'Retry';

  @override
  String get savingProgress => 'Saving progress…';

  @override
  String get progressSaveError =>
      'Your puzzle is solved, but progress could not be saved. Retry to keep your result.';

  @override
  String get localStorageError =>
      'Could not open local storage. Retry without erasing your data.';

  @override
  String get savedProgressLabel => 'Progress saved on this device';

  @override
  String get rwReviewLabel => 'Kinyarwanda — needs native review';

  @override
  String get rateGame => 'Rate this game';

  @override
  String get rateGameDescription =>
      'Leave a rating or review in the app store.';

  @override
  String get ratingNotReleased =>
      'Available after the game is released in the app store.';

  @override
  String get ratingOpenFailed =>
      'Could not open the app store. Please try again.';

  @override
  String get ratingOpening => 'Opening the app store…';
}
