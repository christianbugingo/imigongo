import 'dart:async';

import 'package:imigongo_pattern_puzzle/engine/content/challenge_catalog.dart';

import 'package:drift/native.dart';
import 'package:imigongo_pattern_puzzle/core/storage/progress_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/core/services/game_settings.dart';
import 'package:imigongo_pattern_puzzle/core/services/game_effects.dart';
import 'package:imigongo_pattern_puzzle/l10n/app_localizations.dart';
import 'package:imigongo_pattern_puzzle/ui/providers/settings_provider.dart';
import 'package:imigongo_pattern_puzzle/ui/providers/puzzle_provider.dart';
import 'package:imigongo_pattern_puzzle/ui/models/puzzle_view.dart';
import 'package:imigongo_pattern_puzzle/ui/screens/settings_screen.dart';

import 'puzzle_provider_test.dart' show oneTapBoard;

class FakeSettings implements SettingsStore {
  GameSettings value = const GameSettings();
  bool fail = false;
  @override
  Future<GameSettings> load() async => value;
  @override
  Future<void> save(GameSettings settings) async {
    await Future<void>.delayed(Duration.zero);
    if (fail) throw StateError('disk');
    value = settings;
  }
}

class FakeSound implements SoundOutput {
  final List<double> volumes = [];
  @override
  Future<void> play(GameCue cue, double volume) async {
    volumes.add(volume);
  }

  @override
  Future<void> stop() async {}
  @override
  Future<void> dispose() async {}
}

void main() {
  test('settings saves ordered updates, exposes failures and retries latest choice', () async {
    final store = FakeSettings();
    final container = ProviderContainer(
      overrides: [settingsStoreProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);
    final notifier = container.read(settingsProvider.notifier);
    await Future.wait([
      notifier.update(const GameSettings(volume: .2)),
      notifier.update(const GameSettings(volume: .8, language: 'fr')),
    ]);
    expect((await store.load()).volume, .8);
    expect((await store.load()).language, 'fr');
    store.fail = true;
    await notifier.update(const GameSettings(sound: false));
    expect(container.read(settingsSaveErrorProvider), isTrue);
    store.fail = false;
    await notifier.retry();
    expect(store.value.sound, isFalse);
    expect(container.read(settingsSaveErrorProvider), isFalse);
    expect(GameSettings.fromJson(store.value.toJson()).sound, isFalse);
  });
  test(
    'restored progress hydrates stars, best moves and once-only bonus',
    () async {
      final db = ProgressDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await db.saveWin(
        generation: db.generation,
        size: 3,
        seed: 1,
        version: 2,
        moves: 1,
        stars: 3,
        levelId: 'easy-1',
        nextId: 'easy-2',
        reward: 4,
      );
      final snapshot = await db.load();
      final container = ProviderContainer(
        overrides: [progressSnapshotProvider.overrideWith((ref) => snapshot)],
      );
      addTearDown(container.dispose);
      expect(container.read(memoryBestsProvider).movesFor(3, 1, 2), 1);
      expect(container.read(memoryBestsProvider).starsFor(oneTapBoard()), 3);
      expect(
        container.read(challengeProgressProvider).isCompleted('easy-1'),
        isTrue,
      );
      expect(container.read(challengeProgressProvider).bonusFor('easy-2'), 4);
    },
  );

  test('mute, zero volume and haptics switches are independent', () async {
    var settings = const GameSettings(volume: .6);
    final sound = FakeSound();
    var ticks = 0;
    final effects = GameEffects(
      sound,
      () => settings,
      haptic: (_) async {
        ticks++;
      },
    );
    await effects.play(GameCue.rotate);
    settings = settings.copyWith(sound: false);
    await effects.play(GameCue.success);
    settings = settings.copyWith(sound: true, volume: 0, haptics: false);
    await effects.play(GameCue.gameOver);
    expect(sound.volumes, [.6]);
    expect(ticks, 2);
  });
  test(
    'failed save preserves solved board and grants result only after retry',
    () async {
      var calls = 0;
      var rewards = 0;
      final gate = Completer<void>();
      final notifier = PuzzleNotifier(
        oneTapBoard(),
        persist: (_) async {
          calls++;
          if (calls == 1) {
            await gate.future;
            throw StateError('disk');
          }
        },
        onWin: () {
          rewards++;
          return 4;
        },
      );
      addTearDown(notifier.dispose);
      notifier.rotateTile(0, 0);
      expect(notifier.state.phase, PlayPhase.saving);
      notifier.reset();
      expect(notifier.state.movesTaken, 1);
      expect(rewards, 0);
      gate.complete();
      await Future<void>.delayed(Duration.zero);
      expect(notifier.state.phase, PlayPhase.saveError);
      expect(notifier.state.isSolved, isTrue);
      await notifier.retrySave();
      expect(notifier.state.phase, PlayPhase.completing);
      expect(rewards, 1);
      await notifier.retrySave();
      expect(calls, 2);
    },
  );
  testWidgets('Settings updates mute and reset requires confirmation', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(memoryBestsProvider).record(oneTapBoard().rotateTile(0, 0));
    container
        .read(challengeProgressProvider)
        .recordWin(ChallengeCatalog.find('easy-1')!);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sound effects'));
    await tester.pumpAndSettle();
    expect(container.read(settingsProvider).sound, isFalse);
    expect(find.text('Kinyarwanda — needs native review'), findsNothing);
    await tester.scrollUntilVisible(find.text('Reset progress'), 250);
    await tester.tap(find.text('Reset progress'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Erase completed levels'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Erase completed levels'), findsNothing);
    expect(container.read(memoryBestsProvider).movesFor(3, 1, 2), 1);
    await tester.tap(find.text('Reset progress'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Reset progress'));
    await tester.pumpAndSettle();
    expect(container.read(memoryBestsProvider).movesFor(3, 1, 2), isNull);
    expect(container.read(challengeProgressProvider).bonusFor('easy-2'), 0);
    expect(container.read(settingsProvider).sound, isFalse);
  });
}
