# Sound, Settings and saved progress checkpoint

Approved scope: sound, Settings and on-device saved scores/earned bonuses. Ratings and purchase preparation are still unstarted. No commits were made.

## What changed

- Home and Pause open Settings: mute, volume/preview, haptics, reduced motion, system/en/fr/rw language, system/light/dark theme, How to Play, confirmed progress reset.
- Original short rotation, success and game-over tones, about 38 KB of PCM data total; regenerate using `python3 tool/generate_sounds.py`. They are project-created placeholders, with no cultural instrument claim.
- SharedPreferencesAsync stores one versioned Settings JSON value. Drift stores puzzle scores and first-win completion/grants in a native SQLite file. Database schema starts at v1; keep generated `progress_database.g.dart` with the source.
- Stars, best move counts and next-level +4 rewards survive restart. Replays do not stack the reward. Level 50 has no successor/reward. Progress is local to this installation; uninstalling may remove it. No account/cloud backup or paid-move wallet exists.
- A solved puzzle waits for its transaction before displaying results. Disk errors expose Retry while retaining the solved board. Reset removes score/completion/bonus rows while keeping Settings and tutorial completion. Active attempts/undo history do not resume after process termination.

## Plain-language walkthrough

The puzzle controller still asks the Dart engine to rotate and validate the board. When it wins, the controller first saves the score and the one-time reward together; only then does it show the result and play the success cue. At startup the app reads those saved records into the existing in-memory views, keeping ordinary tile taps independent of database reads.

Settings lives outside the game session, so changing language or volume does not restart your puzzle. Reduce motion combines the system preference with the app switch: either one can turn animations off. Effects read the current settings whenever a move happens; a device audio failure cannot undo a win.

## Run

```sh
cd /Users/a/Documents/imigongo_pattern_puzzle
flutter pub get
flutter run -d 407020D1-FCAA-4F4A-8D99-C79B980A41CB -t lib/main_dev.dart
```

Use `flutter devices` for a different emulator/device ID. Xcode's iPhone 17 Pro simulator is already available. The iOS identifier remains the existing `com.yourname.imigongo` development placeholder; release identity and native iOS flavors remain separate work.

```sh
flutter analyze
flutter test
# After editing Drift tables:
dart run build_runner build
# Native plugin smoke checks (isolated database and preference key):
flutter run -d 407020D1-FCAA-4F4A-8D99-C79B980A41CB -t tool/smoke_local_services.dart
```

The native harness opens Settings after SQLite save/reopen, preferences save/reopen, and audio play/stop complete. It does not touch player progress. Rerun `lib/main_dev.dart` afterwards to restore the normal app entry point.

## Review checklist

1. Open Settings from Home; preview sound, change volume, mute and try a puzzle. Test device silent mode separately on a real iPhone.
2. Turn on reduced motion; check rotations/results. Change language/theme, terminate and relaunch; verify choices remain. rw remains unverified and labeled for native review.
3. Solve a challenge. Relaunch, check its stars/best moves and the next level's +4 allowance. Replay the completed challenge; ensure +4 never becomes +8.
4. Pause a level, open Settings and return; verify the paused attempt resumes normally. Confirm Reset progress, return, and verify cleared scores/bonuses and retained Settings. Canceling reset must keep everything.
5. Try larger text and the Settings controls on a physical low-end Android phone. Android build, physical haptics, perceived audio quality, store/release behavior and performance targets are not verified by simulator tests.

## Automated evidence

`test/storage/progress_database_test.dart` covers file reopen, concurrent/repeated wins, max-stars/min-moves merging, reset/stale writes, and free-play exclusion from rewards. `test/ui/settings_progress_test.dart` covers restoration into providers, ordered preference writes/failure/retry, mute/volume/haptic gating, save failure/retry before granting results, and confirmed/canceled reset with Settings retained. Existing engine, widget and localization tests remain enabled.

See `docs/verification/settings-analyze.txt`, `settings-test.txt`, `settings-simulator.txt` and `settings-native-smoke.txt`. iPhone screenshots cover startup and the Settings native harness. Native smoke proves API calls succeed, not that a person heard the tones or felt haptics. Hosted CI, Android build and real-device performance were not run.

## One exercise

In the effects test, change volume to zero but keep haptics on. Predict the sound-call and haptic-call counts before running the test. Explain why muting sound should not automatically disable the haptic tick.

## Package/API references checked for this checkpoint

- Flutter 3.47.7/Dart 3.13.5 installed toolchain; [HapticFeedback](https://api.flutter.dev/flutter/services/HapticFeedback-class.html).
- [audioplayers 6.8.1](https://pub.dev/packages/audioplayers/versions/6.8.1): small local audio cues; AudioPlayer/AssetSource and ambient iOS context verified against installed package source.
- [Drift setup](https://drift.simonbinder.eu/setup/): drift 2.35.4, drift_flutter 0.3.1, drift_dev 2.35.3; [transactions](https://drift.simonbinder.eu/dart_api/transactions/) and [testing](https://drift.simonbinder.eu/testing/). build_runner 2.17.1 generates type-safe bindings.
- [SharedPreferencesAsync 2.5.6](https://pub.dev/documentation/shared_preferences/2.5.6/shared_preferences/SharedPreferencesAsync-class.html): noncritical preferences only; progress uses SQLite transactions.

Next checkpoint, subject to approval: ratings and purchase preparation. No store account creation or real payment is required for this delivered checkpoint.
