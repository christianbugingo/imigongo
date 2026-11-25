import 'package:shared_preferences/shared_preferences.dart';

abstract interface class TutorialPreferences {
  Future<bool> readFinished();
  Future<void> markFinished();
}

class LocalTutorialPreferences implements TutorialPreferences {
  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();
  static const key = 'tutorial_finished_v1';
  @override
  Future<bool> readFinished() async => await _preferences.getBool(key) ?? false;
  @override
  Future<void> markFinished() => _preferences.setBool(key, true);
}
