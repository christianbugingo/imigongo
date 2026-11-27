# Imigongo: Pattern Puzzle

Flutter iOS/Android procedural puzzle prototype. Cultural notes and all Kinyarwanda translations are **unverified, needs native review**; see [CULTURAL_REVIEW.md](docs/CULTURAL_REVIEW.md).

## Honest implementation status

| Area | Status |
| --- | --- |
| Foundation | Partial: native Android flavors, themes, localization skeleton, strict analysis and analyze/test CI exist. CI debug build, final release identity and native iOS flavors remain incomplete. |
| Steps 2–3 | Accepted engine and tests; generator v2, rule validation, documented PRNG and tool-only solver. |
| Step 4a | Accepted audit and engine/controller boundary. |
| Step 4b | Welcome/three authored tutorial lessons, remembered completion/skip, How to Play, game/Pause layout and single-event result sheet. Local verification in docs/STEP_4B.md. No 4c work delivered. |
| 50-level checkpoint | Easy 1–15, Medium 16–35, Hard 36–50; 50 distinct versioned patterns, five palettes, previews, move limits and +4 next-level bonuses. See docs/LEVELS_50.md. |
| Sound / Settings / saved progress | Implemented locally: mute/volume, haptics, accessibility/language/theme Settings, Drift scores and once-only bonuses. See docs/SETTINGS_PROGRESS.md. |
| Translation / ratings checkpoint | Draft rw translations for review; Settings rating flow implemented but disabled until real store listings exist. See docs/RATINGS.md. |
| Later work | Purchase preparation unstarted. Visual identity, Journey, Collection and remaining design work still need separate approval. |
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

See [RATINGS.md](docs/RATINGS.md) for the current review, configuration and exercise; [translation worksheet](docs/translations/KINYARWANDA_TRANSLATIONS.csv) for native corrections. See [SETTINGS_PROGRESS.md](docs/SETTINGS_PROGRESS.md) for the prior local-storage review. See [LEVELS_50.md](docs/LEVELS_50.md) for the current review checklist and exercise; [CHALLENGE_CHECKPOINT.md](docs/CHALLENGE_CHECKPOINT.md) records the earlier nine-pattern review; [STEP_4B.md](docs/STEP_4B.md) records the previous checkpoint; [RUN_4A.md](docs/RUN_4A.md) retains the platform setup steps. Flutter 3.47.7 / Dart 3.13.5 and existing lockfiles were used for this audit; this checkpoint added pinned audio/Drift/code-generation dependencies (see docs/SETTINGS_PROGRESS.md).

See [ENGINE.md](docs/ENGINE.md) for bit order, architecture, fixed vectors, 200-seed-per-size solver statistics, test names and the deferred hint design. The exact solver is under tool/solver, never imported by lib.
