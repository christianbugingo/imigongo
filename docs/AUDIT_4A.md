# Step 4a audit and correction evidence

Date: 2026-11-25. Scope: the user's explicit Step 4a approval only. The earlier UI is a prototype. This report distinguishes code evidence from completed, accepted, or remotely verified behavior.

## Earlier correction checklist

| Requested correction | Audit finding | Current evidence / limitation |
| --- | --- | --- |
| Honest status table | Earlier README claimed more than implemented; no comprehensive status table. | README.md now has an explicit status table. Step 1 is partial; Steps 2–3 accepted; only Step 4a is delivered; later Phase 1 and Phase 2 deferred. |
| Deviations in DECISIONS.md | Present, but approval wording and some completion claims were misleading. | DECISIONS.md records actual statuses, the layered-layout deviation, Par vs minimum, notifications change, and the ADR 004 violation. Recorded decisions do not establish approval by themselves. |
| Palette identifiers renamed | Done in `5a37f3d`. | lib/core/theme/imigongo_palette.dart uses charcoal/chalk/terracotta/ochre; tests use those names. Values differ from original placeholder palette; contrast is tested rather than locking hex values. |
| Remove unsupported cultural names/claims | NOT fully done before this audit: motif constants and painter claim remained. | Removed the unused legacy motif keys from lib/core/constants/engine_constants.dart and the unsupported painter wording from lib/ui/painters/tile_painter.dart. Deferred settings source removed; README no longer asserts unreviewed history. Unverified terms/pigment claims retained in docs/CULTURAL_REVIEW.md. No matches for those legacy names, pigment-origin terms or the painter claim remain in lib/ or test/. Kinyarwanda localization remains explicitly unverified; every ARB entry now has review metadata/checklist. |
| Contrast tests replace hex-lock test | Done in `5a37f3d`. | test/foundation/palette_theme_test.dart checks five foreground/background pairs at >=4.5 and theme behavior. This does not certify every UI element or WCAG compliance of the whole app. |
| App ID set | Only partially done. | `5a37f3d` configured com.yourname.imigongo in android/app/build.gradle.kts, Android MainActivity package and ios/Runner.xcodeproj/project.pbxproj. Android dev appends .dev. This remains a placeholder, NOT a final owned release identity; iOS native flavor identities/schemes are absent. No new identifier was invented in this audit. |
| Strict analysis | Configured in `5a37f3d`; local verification rerun for 4a. | analysis_options.yaml enables strict casts, inference and raw types. See docs/verification/step4a-analyze.txt for actual current output. |
| CI workflow | Exists, incomplete against full brief. | .github/workflows/ci.yml runs analyze --fatal-infos and tests. It has NO debug-build step; no hosted run was inspected. Do not call CI green or complete. |
| Web removed | Web source target removed in `5a37f3d`. | git ls-files web returns no files and web/ is absent. Historical .metadata still lists original platform creation; the Flutter SDK can detect Chrome independently of repo targets. |
| 6x6 added | Done in `5a37f3d`. | lib/models/puzzle_enums.dart includes sixBySix; foundation enum tests and 1,000-seed 6x6 property test cover it. Step 4a navigation test selects and renders 6x6. |

## Process violation

`0f2fd3b` introduced Game UI & Custom Painters before the requested engine checkpoint review. This violated ADR 004. Existing prototype code is not accepted finished work. The user subsequently accepted Steps 2–3 and authorized only this small audit/Step 4a. The explicit future rule is no implementation beyond the approved step; report out-of-scope gaps rather than silently expanding scope.

## Engine evidence

- docs/verification/engine-imports.txt lists all import/export directives under lib/engine and lib/models. There are no Flutter or dart:ui imports. The strengthened source guard covers both directories; its regex is checked against representative import syntax.
- Tile bit order appears at the top of lib/engine/models/tile.dart and in docs/ENGINE.md: N/E/S/W = bits 0/1/2/3 = values 1/2/4/8.
- `dart run tool/generate_puzzles.dart` invokes the tool-only solver. `dart run tool/benchmark_solver.dart` samples 200 seeds per size; JSON records and the documented summary are saved. Timing is machine-specific.
- ENGINE.md maps named tests for disconnected networks, open boundaries, symmetric costs, undo/reset and PRNG vectors. It also explains the deferred valid-completion-based hint design and its unresolved catalog-coverage limitation.

## UI audit: data flow and scope

Before: widgets/painter received domain Tile/Board objects and called domain getters; the controller held duplicated solved flags, stars and won flags. Undo was absent. The prototype displayed a victory panel, next-puzzle action and settings flow before approval.

After:

```text
PuzzleScreen → Riverpod PuzzleNotifier → GameSession / Board / validator
             ← immutable PuzzleState / TileView snapshots
Painter and widgets ← direction booleans, masks, counts, callbacks
```

Only lib/ui/providers/puzzle_provider.dart imports gameplay engine modules in lib/ui. Controller commands delegate rotation, undo and reset to GameSession, then publish the board's rule-based solved state. No widget rotates masks, validates topology, compares to target rotations, or calculates stars. Painter builds paths only from display direction flags. Tests guard this source boundary and exercise real provider/widget interactions.

Delivered: board rendering, clockwise taps, move counter, plain solved/in-progress status, undo/reset. Solved tiles stop accepting taps; Undo can reopen the puzzle. No victory route or reward summary exists. At least 48 dp tiles are retained on narrow boards using scrolling. Auto-disposed provider families isolate sessions by size/seed; reopening creates a new session because persistence is deferred.

Deferred: hints, haptics, audio, rotation/success animations, win screen, 30-level catalog, Drift, settings, all cloud work. Settings code is retained in git history rather than active source. Existing theme and locale foundation providers remain, but there is no settings navigation.

## Verification and limits

See step4a-analyze.txt, step4a-test.txt and step4a-simulator.txt in docs/verification for actual output. Android SDK is missing on this machine; no Android emulator/build verification is claimed. Native iOS flavor schemes are absent, so the simulator command uses Runner with main_dev.dart (Dart dev branding only). This does not establish separate iOS dev/prod app identities. Physical-device performance, full localization/accessibility review and hosted CI remain open.

The iOS simulator smoke test completed successfully: Xcode debug build took 24.2 seconds and the app launched/synced on the available iPad simulator. This is launch verification, not a manual certification of every gesture or accessibility behavior. CocoaPods integrated the already-installed Flutter plugins and created ios/Podfile.lock during this build; the resulting native workspace/project integration is included for reproducible simulator builds. No new plugin or cloud service was added.
