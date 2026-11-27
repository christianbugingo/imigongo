import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../core/services/game_settings.dart';
import '../../core/storage/progress_database.dart';

final settingsStoreProvider = Provider<SettingsStore?>((ref) => null);
final initialSettingsProvider = Provider((ref) => const GameSettings());
final progressDatabaseProvider = Provider<ProgressDatabase?>((ref) => null);
final progressSnapshotProvider = StateProvider(
  (ref) => const ProgressSnapshot(),
);
final settingsSaveErrorProvider = StateProvider<bool>((ref) => false);
final settingsProvider =
    StateNotifierProvider<SettingsController, GameSettings>(
      (ref) => SettingsController(
        ref.watch(initialSettingsProvider),
        ref.watch(settingsStoreProvider),
        (error) => ref.read(settingsSaveErrorProvider.notifier).state = error,
      ),
    );

class SettingsController extends StateNotifier<GameSettings> {
  final SettingsStore? _store;
  final void Function(bool) _onError;
  Future<void> _pending = Future.value();
  SettingsController(super.state, this._store, this._onError);
  Future<void> update(GameSettings value) {
    state = value;
    _pending = _pending.then((_) async {
      try {
        await _store?.save(value);
        _onError(false);
      } catch (_) {
        _onError(true);
      }
    });
    return _pending;
  }

  Future<void> retry() => update(state);
}
