import 'package:imigongo_pattern_puzzle/core/localization/app_localization_delegates.dart';
// Run on a simulator/device. Uses isolated keys/database, never player progress.
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:imigongo_pattern_puzzle/core/services/game_effects.dart';
import 'package:imigongo_pattern_puzzle/core/services/game_settings.dart';
import 'package:imigongo_pattern_puzzle/core/storage/progress_database.dart';
import 'package:imigongo_pattern_puzzle/core/theme/imigongo_theme.dart';
import 'package:imigongo_pattern_puzzle/l10n/app_localizations.dart';
import 'package:imigongo_pattern_puzzle/ui/providers/settings_provider.dart';
import 'package:imigongo_pattern_puzzle/ui/providers/effects_provider.dart';
import 'package:imigongo_pattern_puzzle/ui/screens/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var db = ProgressDatabase(driftDatabase(name: 'imigongo_smoke'));
  await db.resetProgress();
  await db.saveWin(
    generation: db.generation,
    size: 3,
    seed: 7,
    version: 3,
    stars: 3,
    moves: 9,
    levelId: 'smoke',
    nextId: 'smoke-next',
    reward: 4,
  );
  await db.close();
  db = ProgressDatabase(driftDatabase(name: 'imigongo_smoke'));
  final restored = await db.load();
  if (restored.scores.single.moves != 9 || restored.wins.single.reward != 4) {
    throw StateError('Native SQLite reopen failed');
  }
  await db.resetProgress();
  await db.close();
  final store = LocalSettingsStore(key: 'imigongo_smoke_settings');
  await store.save(const GameSettings(volume: .2, language: 'fr'));
  final loaded = await LocalSettingsStore(key: 'imigongo_smoke_settings')
      .load();
  if (loaded.language != 'fr' || loaded.volume != .2) {
    throw StateError('Native preferences reopen failed');
  }
  await SharedPreferencesAsync().remove('imigongo_smoke_settings');
  final output = PlayerSoundOutput();
  await output.play(GameCue.rotate, .1);
  await Future<void>.delayed(const Duration(milliseconds: 100));
  await output.stop();
  debugPrint(
    'NATIVE_SMOKE_PASS: SQLite reopen, preferences reopen, audio play/stop',
  );
  runApp(
    ProviderScope(
      overrides: [
        gameEffectsProvider.overrideWith(
          (ref) => GameEffects(output, () => ref.read(settingsProvider)),
        ),
      ],
      child: MaterialApp(
        theme: ImigongoTheme.lightTheme,
        localizationsDelegates: appLocalizationDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SettingsScreen(),
      ),
    ),
  );
}
