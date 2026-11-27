import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class GameSettings {
  final bool sound, haptics, reduceMotion;
  final double volume;
  final String theme;
  final String? language;
  const GameSettings({
    this.sound = true,
    this.haptics = true,
    this.reduceMotion = false,
    this.volume = .35,
    this.theme = 'system',
    this.language,
  });
  GameSettings copyWith({
    bool? sound,
    bool? haptics,
    bool? reduceMotion,
    double? volume,
    String? theme,
    String? language,
    bool systemLanguage = false,
  }) => GameSettings(
    sound: sound ?? this.sound,
    haptics: haptics ?? this.haptics,
    reduceMotion: reduceMotion ?? this.reduceMotion,
    volume: (volume ?? this.volume).clamp(0, 1),
    theme: theme ?? this.theme,
    language: systemLanguage ? null : language ?? this.language,
  );
  Map<String, Object?> toJson() => {
    'sound': sound,
    'haptics': haptics,
    'reduceMotion': reduceMotion,
    'volume': volume,
    'theme': theme,
    'language': language,
  };
  factory GameSettings.fromJson(Map<String, dynamic> json) => GameSettings(
    sound: json['sound'] as bool? ?? true,
    haptics: json['haptics'] as bool? ?? true,
    reduceMotion: json['reduceMotion'] as bool? ?? false,
    volume: ((json['volume'] as num?)?.toDouble() ?? .35).clamp(0, 1),
    theme: const ['system', 'light', 'dark'].contains(json['theme'])
        ? json['theme'] as String
        : 'system',
    language: const ['en', 'fr', 'rw'].contains(json['language'])
        ? json['language'] as String
        : null,
  );
}

abstract class SettingsStore {
  Future<GameSettings> load();
  Future<void> save(GameSettings settings);
}

class LocalSettingsStore implements SettingsStore {
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  final String key;
  LocalSettingsStore({this.key = 'game_settings_v1'});
  @override
  Future<GameSettings> load() async {
    final raw = await _prefs.getString(key);
    return raw == null
        ? const GameSettings()
        : GameSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> save(GameSettings settings) =>
      _prefs.setString(key, jsonEncode(settings.toJson()));
}
