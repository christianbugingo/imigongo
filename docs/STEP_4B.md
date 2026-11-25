# Step 4b checkpoint

## Delivered scope

- First launch: Welcome → three interactive authored tutorial boards → temporary Home. Skip is available; completion/skip is remembered with SharedPreferencesAsync (existing shared_preferences 2.5.6 dependency).
- How to Play includes the five requested English sentences verbatim, French translations and flagged Kinyarwanda placeholders. It is reachable from Home and Pause; its practice action reopens the tutorial.
- Game HUD shows Free Play size/tutorial lesson, moves and target moves. Undo, Restart and Pause are in the bottom thumb zone. Pause offers Resume, Restart, How to Play and Home; no dead Settings action.
- One completion per attempt: input locks, localized screen-reader announcement is sent once, a one-second hold occurs, then a result sheet shows sequential stars, moves/target, memory-only New best, Next puzzle/lesson, Replay and Home.
- Reduced motion: no completion hold or star/diagram transitions; route transition visuals are disabled. The full persistent preference arrives with Step 5 Settings. Diagram timers stop when hidden/disposed or system motion reduction is enabled.
- 48 dp control minimums, scrolling for long content, and localized tile coordinates/connection directions. Current light/dark action and sheet text color pairs have AA tests.
- The photo-derived launcher experiment is retired outside the repo; default icons are restored pending original art in 4c. See ASSETS.md.

No Step 4c work is implemented: the old painter, tile gaps, size-selector Home and font choices remain deliberately unchanged apart from accessibility/How to Play wiring. The completion hold/fade is a transition placeholder, not the network glow or region-fill reveal. Hints, sound/haptics, Journey/30 levels, Drift, Settings and Collection remain deferred to their approved steps.

## Important decisions

Game rules stay behind PuzzleNotifier in lib/ui/providers/puzzle_provider.dart. It delegates rotations and undo/reset to GameSession, solved detection to Board's validator and stars to the existing pure-Dart StarRating policy. Widgets receive immutable display values. The exact solver stays in tool/.

Controller phases: playing → completing → results, with playing ↔ paused. Each Replay/Restart increments the attempt identifier. Results and delayed UI callbacks check that identifier, and disposing the screen cancels its timer. Rebuilds/phase changes retain the same event ID and do not emit another completion.

Undo decreases the move count by restoring the previous engine snapshot. Restart resets moves and history. After completion, Undo is locked with the rest of the attempt; Replay begins again. This intentionally supersedes 4a's post-solve undo behavior and is recorded in DECISIONS.md.

Memory bests are keyed by size, seed and generatorVersion, survive navigation/replay during the app session and disappear on process restart. Tutorials do not affect them. Next puzzle advances the unsigned 32-bit seed at the same size, wrapping at 2^32; generated puzzle identity is not a Journey level.

Tutorial masks/rotations are hand-authored in lib/engine/content/tutorial_boards.dart. Generator version 0 distinguishes authored records from generated v2 boards. There are no tutorial-only validation shortcuts. Internal negative provider keys select these lessons; they are never ranked/synced.

Preference read failure offers Retry. Write failure leaves the tutorial/Welcome available and shows a localized retry message; it does not pretend to save. Tests reconstruct the controller against a fake persistent store; simulator launch verifies the real native plugin can load preferences. Physical-device preference durability is not claimed by the fake-store test.

## Run

```sh
cd /Users/a/Documents/imigongo_pattern_puzzle
flutter pub get
flutter analyze
flutter test
flutter run -d 407020D1-FCAA-4F4A-8D99-C79B980A41CB -t lib/main_dev.dart
```

Use `flutter devices` if the simulator ID changes. Native iOS dev/prod schemes are still absent, so do not add --flavor dev on iOS. Android SDK is still absent here; see RUN_4A.md for Android Studio/emulator setup. No Android build or device-performance claim is made.

The iPhone 17 Pro debug simulator build/launch is recorded in docs/verification/step4b-simulator.txt. The welcome screenshot was visually inspected for clipped content. This is not full manual VoiceOver certification. Source licenses and SDK/API references are documented separately.

## Review checklist

1. On first launch, inspect Welcome. Choose Learn to play; lesson 1 has one turn to solve.
2. Complete all three lessons. Check Next lesson, the third lesson's stars and the return Home. Alternatively Skip; relaunch should remember the choice.
3. Open How to Play using Home's help button. Read/scroll all five rules; practice can reopen the tutorial.
4. Start Free Play. Rotate, Undo and Restart; check that Undo reduces the counter.
5. Pause, visit How to Play, return to Pause and Resume. Verify no board input changes the puzzle while paused.
6. Solve a board: one result sheet, stars, moves/target, and New best. Replay the same score: no new record badge. Next puzzle should retain grid size.
7. Enable Reduce Motion in iOS Accessibility settings. Repeat completion: no one-second wait or star reveal animation. Try large text and VoiceOver; tile labels include coordinates and connections, and completion announces the earned stars.

Best scores are memory-only and Free Play has no saved progress. Do not expect Journey, settings, sound or haptics in this checkpoint.

## Tests

- Authored tutorial solutions use ordinary engine moves and validator.
- Completion event once, stale-event rejection, pause locking, Undo accounting, replay reset, best-score improvements and family isolation.
- Onboarding saved/failed/retry states and reconstructed-controller persistence.
- Full tutorial navigation, skip/re-entry, tutorial/best isolation and next-seed routing.
- Result delay, sequential stars, exactly one accessibility announcement, reduced motion, French strings, translated tile semantics, large text/narrow viewport and minimum targets.
- Matching ARB keys/review metadata plus existing 5,000-seed engine and contrast tests.

Actual analyzer and full-test output are saved in docs/verification/step4b-analyze.txt and step4b-test.txt.

## Learning exercise

Temporarily change the one-second completion hold in PuzzleScreen to two seconds. Predict which assertion in `result appears once after hold; announces once; replay starts fresh` fails, and why the reduced-motion test should still pass. Run `flutter test test/ui/puzzle_screen_test.dart`, then restore the original duration. This separates presentation timing from engine rules and accessibility behavior.

## Sources checked, no dependency upgrades

- shared_preferences 2.5.6 API: https://pub.dev/packages/shared_preferences
- go_router 18.1.4: https://pub.dev/packages/go_router
- Flutter 3.47.7 installed source for semantics service and TickerMode; public API: https://api.flutter.dev/flutter/semantics/SemanticsService-class.html
- System motion preference: https://api.flutter.dev/flutter/widgets/MediaQuery/disableAnimationsOf.html
- Riverpod migration/lifecycle guidance: https://riverpod.dev/docs/3.0_migration

No commits were made. Stop here and wait for explicit approval before Step 4c.


## Verified checkpoint result

`flutter analyze`: No issues found (2.6s). `flutter test --reporter expanded`: 91 tests passed (3s), including the existing 5,000-seed engine suite. iPhone 17 Pro simulator debug build completed in 9.5s and launched successfully. These are development-host checks, not ADR 003 real-device performance measurements. Git HEAD remains `54808bb`; no commits were created.
