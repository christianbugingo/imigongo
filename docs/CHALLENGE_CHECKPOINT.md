# Challenge preview and move-budget checkpoint

> Historical nine-pattern checkpoint. The current 50-level catalog, palettes and cross-difficulty reward links are documented in LEVELS_50.md.

Approved scope: Home difficulty choices, selecting a completed pattern before play, a persistent reference thumbnail, finite challenge moves, Game Over/Replay, and a +4 reward for the next pattern. No commits were made for this task. Baseline HEAD was 5072adf.

## Playable scope

Nine distinct procedural review patterns are available: three Easy, three Medium, three Hard. They are a small set for checking the new rules and flow, **not the full requested 50 levels**. The later catalog expansion/color variations, sound/volume/mute Settings, store ratings and in-app purchase preparation are deferred. No fake Settings, store or purchase buttons are shown.

Home → difficulty → pattern card → full preview → Start → game. The completed reference remains visible as a thumbnail throughout challenge play and can be enlarged. The game accepts any single connected pattern without loose ends, not only an exact copy of the reference. This preserves rule-based validation; the UI explains it. The first-run tutorial remains practice before Home; Free Play retains grid-size selection under its own Home action and has no move cap.

## Rules and defaults

- The reference is drawn from the selected original procedural board's solved masks. No third-party photo or raster art is used.
- Each challenge has a base allowance of generator Par plus a review margin: Easy +6, Medium +3, Hard +1. Par is a verified restoration path, not an asserted minimum. Every review board can be solved within its base allowance without rewards or purchases.
- A clockwise tap spends one move, including a tap on an empty/symmetric tile, consistent with existing move accounting. Undo refunds one move while playing. Invalid coordinates change nothing.
- A valid solution on the last allowed turn wins. An unsolved board at zero moves locks the attempt and shows Game Over; no extra turn is accepted. Undo is locked after failure. Replay is free and restores the same starting allowance.
- Clearing a pattern first time grants four extra moves to its next pattern in the same difficulty. The next pattern gets **its own base allowance +4**, with no carryover of unused moves. Replaying cannot stack the grant. The last review pattern has no Next action or reward for nonexistent content.
- Progress, one-time grants and bests are session-only. Navigating Home does not remove the bonus; restarting the app process does. Persistent progress and paid move wallets remain future work.

## Implementation boundary

- lib/engine/content/challenge_catalog.dart: stable IDs, seeds, generatorVersion, tiers and next IDs for the nine review records.
- lib/engine/models/game_session.dart: optional move limit, remaining moves, win/loss precedence and terminal input locking. Unlimited sessions keep prior engine-history behavior.
- lib/engine/models/challenge_progress.dart: base allowance and one-time reward rules.
- lib/ui/providers/puzzle_provider.dart: the only gameplay-engine adapter in the UI. Publishes pattern snapshots and challenge state; invokes the domain reward only for a won session. Reward updates invalidate preview views without replacing an active game session.
- Home, pattern selection and preview screens use display models. Gameplay reuses the tested controller/painter and completion flow. The old size selector is isolated in Free Play.
- All new strings are in en/fr/rw ARBs. French is complete; rw uses explicitly flagged English placeholders, tracked in CULTURAL_REVIEW.md.

## Verification

Run:

```sh
cd /Users/a/Documents/imigongo_pattern_puzzle
flutter analyze
flutter test
flutter test test/engine/challenge_rules_test.dart test/ui/challenge_flow_test.dart
flutter run -d 407020D1-FCAA-4F4A-8D99-C79B980A41CB -t lib/main_dev.dart
```

Actual output is stored in docs/verification/challenge-analyze.txt, challenge-test.txt and challenge-simulator.txt. No dependency was added or upgraded. Installed Riverpod 3.5.0 and go_router 18.1.4 publisher docs and Flutter RepaintBoundary docs were checked. Android SDK remains unavailable; no Android build or physical-device performance claim is made.

Tests cover final-turn success versus failure, zero-move input lock, Undo refund, invalid input, unlimited Free Play, reset allowance, one-time next-pattern reward, reward isolation across difficulties, no reward for the last review pattern, valid/distinct reference layouts, stable generator identity, controller snapshots, and full Home → selection → preview → game → rewarded next preview navigation. The existing localization, contrast, tutorial, accessibility and 5,000-seed suites remain included.

## Review checklist

1. Finish/skip onboarding if shown; Home should offer Easy, Medium, Hard and Free Play.
2. Pick Easy, tap a pattern image, inspect its completed preview, then Start.
3. Check Moves left and the reference thumbnail. Open/close the large reference; the board is paused during inspection.
4. Rotate and Undo: the remaining count should decrease and then return.
5. Exhaust moves without solving: Game Over appears. Replay restores the allowance and clears the attempt.
6. Solve the first pattern: the sheet shows +4. Next opens the following pattern's preview with its base allowance plus four.
7. Replay the first win: a second +4 grant must not stack. Free Play should have no remaining-move counter.

## Learning exercise

In GameSession.outcome, predict the failure if the zero-moves check is placed before the solved check. Run `flutter test test/engine/challenge_rules_test.dart`: a player solving on the final allowed turn would incorrectly lose. Restore success-first ordering.

Stop after this checkpoint. Expanding to 50 patterns, adding sound/Settings, and store integration each require the next approved plan. No changes were committed.

## Actual checkpoint result

Static analysis: no issues (2.2s). Full test suite: 98 passed (4s). iPhone 17 Pro debug simulator build/launch: successful (9.6s build). Home screenshot captured and visually checked in docs/verification/challenge-home.png. No Android build or real-device performance result is claimed. Git HEAD remains 5072adf; no commits were made.
