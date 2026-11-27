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
  String get geometricReliefPuzzle => 'Umukino wo guhuza imirongo';

  @override
  String get play => 'Gukina';

  @override
  String get settings => 'Igenamiterere';

  @override
  String get dailyChallenge => 'Umukino w’umunsi';

  @override
  String get moves => 'Intambwe';

  @override
  String get par => 'Intego';

  @override
  String get targetMoves => 'Intambwe z’intego';

  @override
  String get solved => 'Byakemutse';

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
  String get rotateInstruction =>
      'Kanda ku gice kugira ngo ukizengurutse mu cyerekezo cy’inshinge z’isaha';

  @override
  String get colorCharcoal => 'Umukara';

  @override
  String get colorChalk => 'Umweru';

  @override
  String get colorTerracotta => 'Umutuku wijimye';

  @override
  String get colorOchre => 'Umuhondo wijimye';

  @override
  String get undo => 'Subiza inyuma';

  @override
  String get reset => 'Tangira bushya';

  @override
  String get inProgress => 'Biracyakorwa';

  @override
  String get welcomeTitle => 'Murakaza neza muri Imigongo';

  @override
  String get welcomeBody =>
      'Umukino utuje wo guhuza imirongo. Wige uko ukinwa ukoresheje imyitozo itatu migufi.';

  @override
  String get learnToPlay => 'Iga gukina';

  @override
  String get skipTutorial => 'Simbuka inyigisho';

  @override
  String get howToPlay => 'Uko bakina';

  @override
  String get back => 'Subira inyuma';

  @override
  String get resume => 'Komeza';

  @override
  String get restart => 'Ongera utangire';

  @override
  String get pause => 'Hagarika gato';

  @override
  String get paused => 'Byahagaze gato';

  @override
  String get home => 'Ahabanza';

  @override
  String get replay => 'Ongera ukine';

  @override
  String get nextPuzzle => 'Umukino ukurikira';

  @override
  String get nextLesson => 'Isomo rikurikira';

  @override
  String get finishTutorial => 'Soza inyigisho';

  @override
  String get newBest => 'Wageze ku ntsinzi nshya';

  @override
  String get levelComplete => 'Urwego rwarangiye';

  @override
  String get lessonComplete => 'Isomo ryarangiye';

  @override
  String completionAnnouncement(int stars) {
    String _temp0 = intl.Intl.pluralLogic(
      stars,
      locale: localeName,
      other: 'inyenyeri $stars',
      one: 'inyenyeri 1',
    );
    return 'Urwego rwarangiye, $_temp0';
  }

  @override
  String freePlayTitle(int size) {
    return 'Gukina wisanzuye · $size×$size';
  }

  @override
  String gridSize(int size) {
    return '$size×$size';
  }

  @override
  String tutorialTitle(int number) {
    return 'Isomo rya $number muri 3';
  }

  @override
  String movesValue(int count) {
    return 'Intambwe: $count';
  }

  @override
  String targetValue(int count) {
    return 'Intambwe z’intego: $count';
  }

  @override
  String tileLabel(int row, int col, String connections) {
    return 'Igice kiri ku murongo wa $row, mu nkingi ya $col. Aho gihurira n’ibindi: $connections.';
  }

  @override
  String get north => 'amajyaruguru';

  @override
  String get east => 'iburasirazuba';

  @override
  String get south => 'amajyepfo';

  @override
  String get west => 'iburengerazuba';

  @override
  String get noConnections => 'nta na hamwe';

  @override
  String get ruleOne =>
      'Kanda ku gice kugira ngo ukizengurutse kimwe cya kane cy’uruziga mu cyerekezo cy’inshinge z’isaha.';

  @override
  String get ruleTwo =>
      'Huza imirongo ku buryo nta mutwe wayo usigara udahujwe cyangwa werekeza hanze y’ikibaho.';

  @override
  String get ruleThree => 'Byose bigomba guhuzwa bikavamo ishusho imwe.';

  @override
  String get ruleFour =>
      'Koresha intambwe nke zishoboka. Nugera ku ntambwe z’intego uzabona inyenyeri eshatu.';

  @override
  String get ruleFive =>
      'Gusubiza inyuma no kongera gutangira ni ubuntu buri gihe.';

  @override
  String get lessonOne =>
      'Igice kimwe gikeneye kuzengurutswa. Gikande kugira ngo urangize ishusho.';

  @override
  String get lessonTwo =>
      'Huza imitwe yose y’imirongo. Imirongo yose igomba kuba mu ishusho imwe ihujwe; inziga zitandukanye ntizemerwa.';

  @override
  String get lessonThree =>
      'Gerageza gusubiza inyuma cyangwa kongera gutangira, hanyuma ukemure umukino. Gerageza gukoresha intambwe z’intego kugira ngo ubone inyenyeri eshatu.';

  @override
  String get tutorialNotice =>
      'Uyu ni umwitozo gusa: ibisubizo byawo ntibihindura amanota yawe meza mu gukina wisanzuye.';

  @override
  String get chooseSize => 'Hitamo ingano y’ikibaho cyo gukina wisanzuye';

  @override
  String get loading => 'Birimo gufunguka';

  @override
  String get loadFailed =>
      'Ntibyashobotse gufungura igenamiterere ry’inyigisho.';

  @override
  String get retry => 'Ongera ugerageze';

  @override
  String get saveFailed =>
      'Ntibyashobotse kubika ko warangije inyigisho. Ongera ugerageze.';

  @override
  String get practiceTutorial => 'Kora imyitozo y’inyigisho';

  @override
  String get sessionBestNote =>
      'Ibisubizo byawe byiza byo gukina wisanzuye bibikwa kuri iki gikoresho.';

  @override
  String get developmentBadge => 'DEV';

  @override
  String get chooseDifficulty => 'Hitamo ubukana bw’umukino';

  @override
  String get easy => 'Byoroshye';

  @override
  String get medium => 'Biringaniye';

  @override
  String get hard => 'Bikomeye';

  @override
  String get freePlay => 'Gukina wisanzuye';

  @override
  String get challengeSessionNote =>
      'Aho ugeze n’intambwe z’inyongera watsindiye bibikwa kuri iki gikoresho. Gukina wisanzuye ntibigira umubare ntarengwa w’intambwe.';

  @override
  String get choosePattern => 'Hitamo ishusho ushaka kurangiza.';

  @override
  String patternNumber(int number) {
    return 'Ishusho ya $number';
  }

  @override
  String allowanceValue(int count) {
    return 'Intambwe wemerewe: $count';
  }

  @override
  String bonusIncluded(int count) {
    return 'Harimo intambwe $count z’inyongera watsindiye.';
  }

  @override
  String get patternUnavailable => 'Iyi shusho ntiboneka.';

  @override
  String get patternPreview =>
      'Banza witegereze ishusho yuzuye mbere yo gutangira.';

  @override
  String get previewRule =>
      'Iyi shusho ni urugero rwo kukuyobora. Ishusho iyo ari yo yose ihujwe yose kandi idafite imitwe y’imirongo idahujwe ni igisubizo cyemewe.';

  @override
  String get referencePattern => 'Ishusho yuzuye yo kureberaho';

  @override
  String get referenceHint =>
      'Ishusho yo kureberaho iguma hano. Yikande kugira ngo uyagure.';

  @override
  String get startPuzzle => 'Tangira umukino';

  @override
  String remainingMoves(int count) {
    return 'Intambwe zisigaye: $count';
  }

  @override
  String bonusReward(int count) {
    return 'Watsindiye intambwe +$count zo gukoresha ku ishusho ikurikira';
  }

  @override
  String get gameOver => 'Umukino urarangiye';

  @override
  String get outOfMoves =>
      'Nta ntambwe zisigaye. Ongera ukine iyi shusho uhabwe intambwe nshya.';

  @override
  String get challengeHelp =>
      'Imikino y’inzego igira umubare ntarengwa w’intambwe. Iyo urangije ishusho, utsindira intambwe enye z’inyongera ku ishusho ikurikira, rimwe gusa kuri buri rwego. Gusubiza inyuma bigusubiza intambwe imwe igihe umukino ugikomeje.';

  @override
  String get colorHelp =>
      'Amabara ni ayo kurimbisha. Huza imirongo, si amabara.';

  @override
  String get settingsTitle => 'Igenamiterere';

  @override
  String get soundEnabled => 'Amajwi y’umukino';

  @override
  String get volumeLabel => 'Uburemere bw’ijwi';

  @override
  String get previewSound => 'Umva ijwi ry’igerageza';

  @override
  String get hapticsEnabled => 'Kunyeganyega kw’igikoresho';

  @override
  String get reduceMotionSetting => 'Gabanya ibinyeganyega kuri ecran';

  @override
  String get languageSetting => 'Ururimi';

  @override
  String get themeSetting => 'Isura';

  @override
  String get systemSetting => 'Kurikiza igenamiterere ry’igikoresho';

  @override
  String get lightSetting => 'Urumuri';

  @override
  String get darkSetting => 'Umwijima';

  @override
  String get resetProgress => 'Siba aho ugeze';

  @override
  String get resetProgressQuestion =>
      'Urasiba inzego warangije, inyenyeri, intambwe nke wakoresheje n’inyongera watsindiye? Igenamiterere rizagumaho.';

  @override
  String get cancelSetting => 'Reka';

  @override
  String get progressResetDone => 'Aho wari ugeze hasibwe.';

  @override
  String get settingsSaveError => 'Ntibyashobotse kubika. Ongera ugerageze.';

  @override
  String get retrySave => 'Ongera ugerageze';

  @override
  String get savingProgress => 'Birimo kubika aho ugeze…';

  @override
  String get progressSaveError =>
      'Wakemuye umukino, ariko ntibyashobotse kubika aho ugeze. Ongera ugerageze kugira ngo ubike igisubizo cyawe.';

  @override
  String get localStorageError =>
      'Ntibyashobotse gufungura amakuru abitswe kuri iki gikoresho. Ongera ugerageze utayasibye.';

  @override
  String get savedProgressLabel => 'Aho ugeze habitswe kuri iki gikoresho';

  @override
  String get rwReviewLabel =>
      'Kinyarwanda — gikeneye gusuzumwa n’ukivuga kavukire';

  @override
  String get rateGame => 'Tanga amanota ku mukino';

  @override
  String get rateGameDescription =>
      'Tanga amanota cyangwa igitekerezo mu bubiko bwa porogaramu.';

  @override
  String get ratingNotReleased =>
      'Bizashoboka umukino umaze gushyirwa mu bubiko bwa porogaramu.';

  @override
  String get ratingOpenFailed =>
      'Ntibyashobotse gufungura ububiko bwa porogaramu. Ongera ugerageze.';

  @override
  String get ratingOpening => 'Birimo gufungura ububiko bwa porogaramu…';
}
