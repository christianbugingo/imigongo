# Imigongo: Pattern Puzzle

Flutter iOS/Android procedural puzzle prototype. Cultural notes and all Kinyarwanda translations are **unverified, needs native review**; see [CULTURAL_REVIEW.md](docs/CULTURAL_REVIEW.md).

## Honest implementation status

| Area | Status |
| --- | --- |
| Foundation | Partial: native Android flavors, themes, localization skeleton, strict analysis and analyze/test CI exist. CI debug build, final release identity and native iOS flavors remain incomplete. |
| Steps 2–3 | Accepted engine and tests; generator v2, rule validation, documented PRNG and tool-only solver. |
| Step 4a | Board, tap, moves, solved status, undo/reset through a tested Riverpod controller. Prototype audit only; full Step 4 is not complete. |
| Later Phase 1 | Hints, haptics, audio, animations/win screen, 30 levels, Drift persistence and settings deferred. |
| Phase 2 | Not implemented; no accounts, backend, daily play, leaderboards or cloud sync. |
| Release/performance | Not verified; no real-device performance or hosted CI green claim. |

The early UI commit violated the checkpoint. Its history is recorded in [DECISIONS.md](DECISIONS.md); it is not accepted finished UI. [AUDIT_4A.md](docs/AUDIT_4A.md) maps the correction evidence and limitations.

## Run and test

```sh
flutter pub get
flutter analyze
flutter test
# Pure Dart content tooling:
dart run tool/generate_puzzles.dart
```

See [RUN_4A.md](docs/RUN_4A.md) for simulator/emulator setup and the UI review exercise. Flutter 3.47.7 / Dart 3.13.5 and existing lockfiles were used for this audit; no dependency upgrade was made.

See [ENGINE.md](docs/ENGINE.md) for bit order, architecture, fixed vectors, 200-seed-per-size solver statistics, test names and the deferred hint design. The exact solver is under tool/solver, never imported by lib.
