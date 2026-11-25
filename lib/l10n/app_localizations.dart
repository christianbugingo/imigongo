import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_rw.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('rw'),
  ];

  /// Main title of the application
  ///
  /// In en, this message translates to:
  /// **'Imigongo Puzzle'**
  String get appTitle;

  /// Subtitle describing the puzzle genre
  ///
  /// In en, this message translates to:
  /// **'Geometric Relief Puzzle'**
  String get geometricReliefPuzzle;

  /// Label for play action
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// Label for settings action
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label for daily puzzle challenge
  ///
  /// In en, this message translates to:
  /// **'Daily Challenge'**
  String get dailyChallenge;

  /// Counter label for moves taken
  ///
  /// In en, this message translates to:
  /// **'Moves'**
  String get moves;

  /// Target benchmark moves label
  ///
  /// In en, this message translates to:
  /// **'Par'**
  String get par;

  /// Full label for target move benchmark
  ///
  /// In en, this message translates to:
  /// **'Target Moves'**
  String get targetMoves;

  /// Indicator when puzzle is completed
  ///
  /// In en, this message translates to:
  /// **'Solved'**
  String get solved;

  /// Number of stars earned
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Star} other{{count} Stars}}'**
  String starsEarned(int count);

  /// Gameplay instruction for rotating a tile
  ///
  /// In en, this message translates to:
  /// **'Tap a tile to rotate clockwise'**
  String get rotateInstruction;

  /// Palette color label for charcoal
  ///
  /// In en, this message translates to:
  /// **'Charcoal'**
  String get colorCharcoal;

  /// Palette color label for chalk
  ///
  /// In en, this message translates to:
  /// **'Chalk'**
  String get colorChalk;

  /// Palette color label for terracotta
  ///
  /// In en, this message translates to:
  /// **'Terracotta'**
  String get colorTerracotta;

  /// Palette color label for ochre
  ///
  /// In en, this message translates to:
  /// **'Ochre'**
  String get colorOchre;

  /// Step 4a control/status: undo
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// Step 4a control/status: reset
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Step 4a control/status: inProgress
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get inProgress;

  /// Step 4b: welcomeTitle
  ///
  /// In en, this message translates to:
  /// **'Welcome to Imigongo'**
  String get welcomeTitle;

  /// Step 4b: welcomeBody
  ///
  /// In en, this message translates to:
  /// **'A quiet puzzle of connected lines. Learn with three short practice boards.'**
  String get welcomeBody;

  /// Step 4b: learnToPlay
  ///
  /// In en, this message translates to:
  /// **'Learn to play'**
  String get learnToPlay;

  /// Step 4b: skipTutorial
  ///
  /// In en, this message translates to:
  /// **'Skip tutorial'**
  String get skipTutorial;

  /// Step 4b: howToPlay
  ///
  /// In en, this message translates to:
  /// **'How to Play'**
  String get howToPlay;

  /// Step 4b: back
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Step 4b: resume
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// Step 4b: restart
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// Step 4b: pause
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// Step 4b: paused
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// Step 4b: home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Step 4b: replay
  ///
  /// In en, this message translates to:
  /// **'Replay'**
  String get replay;

  /// Step 4b: nextPuzzle
  ///
  /// In en, this message translates to:
  /// **'Next puzzle'**
  String get nextPuzzle;

  /// Step 4b: nextLesson
  ///
  /// In en, this message translates to:
  /// **'Next lesson'**
  String get nextLesson;

  /// Step 4b: finishTutorial
  ///
  /// In en, this message translates to:
  /// **'Finish tutorial'**
  String get finishTutorial;

  /// Step 4b: newBest
  ///
  /// In en, this message translates to:
  /// **'New best'**
  String get newBest;

  /// Step 4b: levelComplete
  ///
  /// In en, this message translates to:
  /// **'Level complete'**
  String get levelComplete;

  /// Step 4b: lessonComplete
  ///
  /// In en, this message translates to:
  /// **'Lesson complete'**
  String get lessonComplete;

  /// Step 4b: completionAnnouncement
  ///
  /// In en, this message translates to:
  /// **'Level complete, {stars, plural, =1{1 star} other{{stars} stars}}'**
  String completionAnnouncement(int stars);

  /// Step 4b: freePlayTitle
  ///
  /// In en, this message translates to:
  /// **'Free Play · {size}×{size}'**
  String freePlayTitle(int size);

  /// Step 4b: gridSize
  ///
  /// In en, this message translates to:
  /// **'{size}×{size}'**
  String gridSize(int size);

  /// Step 4b: tutorialTitle
  ///
  /// In en, this message translates to:
  /// **'Tutorial {number} of 3'**
  String tutorialTitle(int number);

  /// Step 4b: movesValue
  ///
  /// In en, this message translates to:
  /// **'Moves: {count}'**
  String movesValue(int count);

  /// Step 4b: targetValue
  ///
  /// In en, this message translates to:
  /// **'Target moves: {count}'**
  String targetValue(int count);

  /// Step 4b: tileLabel
  ///
  /// In en, this message translates to:
  /// **'Tile at row {row}, column {col}. Connections: {connections}.'**
  String tileLabel(int row, int col, String connections);

  /// Step 4b: north
  ///
  /// In en, this message translates to:
  /// **'north'**
  String get north;

  /// Step 4b: east
  ///
  /// In en, this message translates to:
  /// **'east'**
  String get east;

  /// Step 4b: south
  ///
  /// In en, this message translates to:
  /// **'south'**
  String get south;

  /// Step 4b: west
  ///
  /// In en, this message translates to:
  /// **'west'**
  String get west;

  /// Step 4b: noConnections
  ///
  /// In en, this message translates to:
  /// **'none'**
  String get noConnections;

  /// Step 4b: ruleOne
  ///
  /// In en, this message translates to:
  /// **'Tap a tile to turn it a quarter turn clockwise.'**
  String get ruleOne;

  /// Step 4b: ruleTwo
  ///
  /// In en, this message translates to:
  /// **'Join the lines so no line ends in the open or points off the board.'**
  String get ruleTwo;

  /// Step 4b: ruleThree
  ///
  /// In en, this message translates to:
  /// **'Everything must connect into one single pattern.'**
  String get ruleThree;

  /// Step 4b: ruleFour
  ///
  /// In en, this message translates to:
  /// **'Use as few turns as you can. Reach the target moves for three stars.'**
  String get ruleFour;

  /// Step 4b: ruleFive
  ///
  /// In en, this message translates to:
  /// **'Undo and Restart are always free.'**
  String get ruleFive;

  /// Step 4b: lessonOne
  ///
  /// In en, this message translates to:
  /// **'One tile needs a turn. Tap it to complete the pattern.'**
  String get lessonOne;

  /// Step 4b: lessonTwo
  ///
  /// In en, this message translates to:
  /// **'Match every open end. All lines must belong to one connected pattern; separate loops do not count.'**
  String get lessonTwo;

  /// Step 4b: lessonThree
  ///
  /// In en, this message translates to:
  /// **'Try Undo or Restart, then solve the board. Meet the target moves to earn three stars.'**
  String get lessonThree;

  /// Step 4b: tutorialNotice
  ///
  /// In en, this message translates to:
  /// **'Practice only: these results do not affect your Free Play bests.'**
  String get tutorialNotice;

  /// Step 4b: chooseSize
  ///
  /// In en, this message translates to:
  /// **'Choose a Free Play grid'**
  String get chooseSize;

  /// Step 4b: loading
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// Step 4b: loadFailed
  ///
  /// In en, this message translates to:
  /// **'Could not load tutorial preferences.'**
  String get loadFailed;

  /// Step 4b: retry
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Step 4b: saveFailed
  ///
  /// In en, this message translates to:
  /// **'Could not remember tutorial completion. Please try again.'**
  String get saveFailed;

  /// Step 4b: practiceTutorial
  ///
  /// In en, this message translates to:
  /// **'Practice the tutorial'**
  String get practiceTutorial;

  /// Step 4b: sessionBestNote
  ///
  /// In en, this message translates to:
  /// **'Free Play bests last until the app closes.'**
  String get sessionBestNote;

  /// Step 4b: developmentBadge
  ///
  /// In en, this message translates to:
  /// **'DEV'**
  String get developmentBadge;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr', 'rw'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'rw':
      return AppLocalizationsRw();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
