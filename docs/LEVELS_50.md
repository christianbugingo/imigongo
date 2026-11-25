# 50-level catalog and palettes checkpoint

## Delivered

| Difficulty | Displayed levels | Count | Board sizes |
| --- | --- | --- | --- |
| Easy | 1–15 | 15 | 3×3, 4×4 |
| Medium | 16–35 | 20 | 4×4, 5×5 |
| Hard | 36–50 | 15 | 5×5, 6×6, 7×7 |

All 50 have distinct solved topologies even after normalizing quarter-turn rotations. Color or a different scramble is not counted as a new pattern. The nine earlier pattern IDs retain their original seed, grid size and generatorVersion=2. Medium/Hard display numbers are now shifted to 16/36 to make the 1–50 sequence contiguous; IDs remain stable. The other 41 entries use generatorVersion=3.

The catalog contains varied connected orthogonal networks, from sparse branches to frames and dense junctions. These are original procedural placeholders with no assigned cultural names or meanings. Difficulty is an initial size/Par/rotatable-tile filtering choice, not a claim of calibrated human difficulty or strictly increasing optimal move count. Playtesting remains necessary.

## Generator versions and content tooling

- Free Play and earlier patterns continue to use the unmodified v2 generator.
- CenterNetworkGenerator (v3) starts with a connected central seed: an axis/cross for odd grids, a central square for even grids. It adds reflected edge orbits anchored to existing active tiles. Because the active network is reflection-invariant, all reflected additions remain connected. An integer seeded PRNG selects growth and scrambling; no Flutter APIs, wall clock or platform RNG are used.
- v3 does not require a perimeter and varies density/empty space. Par is the sum of cheapest visually equivalent clockwise restorations. A valid board is still checked by the normal validator, never by comparison with the reference image.
- ChallengeLevel dispatches by stored generatorVersion; unknown versions fail rather than silently regenerating different content. A fixed v3 mask vector and the existing PRNG vectors protect version identity.
- The tool selects seeds offline, rejects duplicate rotated topologies and applies initial content filters. It performs no search while the player starts a level. The exact solver remains tooling-only and is not called by the app.

```sh
# Inspect the reproducible catalog without changing source:
dart run tool/build_50_levels.dart
# Deliberately rebuild the versioned static table:
dart run tool/build_50_levels.dart --write
dart format lib/engine/content/challenge_levels.g.dart
```

The generated table is lib/engine/content/challenge_levels.g.dart. Full ID/seed/version/size/palette/Par/next-level metadata is saved in docs/verification/catalog-50.json. Tool reconstruction is compared to every checked-in catalog row in tests.

## Colors and rendering

Five repeating palettes use the existing four colors: classic, clay, ochre, mixed and inverse. Mixed varies ridge colors by stable tile coordinates. Palette ID is separate display metadata, never a generation/validation/move-limit input. The same resolver is used for list previews, the pre-play reference, reference enlargement/thumbnail and the playing tiles. Restart keeps the same palette.

Both themes use contrasting connection outlines; tests require outline/surface contrast >=4.5:1. Decorative fill colors can have lower contrast because the outline carries the connection shape. Text colors use the existing light/dark theme contrast tests. This does not certify every device or the whole app as WCAG compliant. No color distinction is required to solve a level; How to Play says so in English/French, with a flagged rw placeholder.

The selection list now constructs cards lazily. Production painters remain inside RepaintBoundary; no game bitmap or new runtime font/package was added. The existing seams/relief treatment and the richer network-fill reveal are not redesigned in this checkpoint.

Contact sheets produced with the production palette resolver/painter were inspected in both themes:
- docs/verification/catalog-light.png
- docs/verification/catalog-dark.png

They are developer review artifacts, not images bundled into the app. To regenerate them, set FLUTTER_ROOT to the installed SDK and run:

```sh
flutter test tool/render_catalog_test.dart
```

The export uses the SDK's existing Roboto font for technical labels; its license is already recorded in ASSETS.md.

## Progress and rewards

The Next chain now runs 1 → 50, including 15 → 16 and 35 → 36. The one-time +4 reward follows this chain; only level 50 has no Next action. The Home difficulty choices still let players pick any pattern. This is not a locked Journey map.

Move budgets remain Par plus Easy/Medium/Hard margins 6/3/1. Undo refunds moves during play; final-turn success takes precedence over exhaustion. Game Over/Replay remains unchanged. Rewards and bests are still memory-only; persistent progress belongs to the following checkpoint. No purchases or paid wallet is implemented here.

## Verification and review

```sh
flutter analyze
flutter test
flutter test test/engine/catalog_50_test.dart test/ui/level_palette_test.dart test/ui/catalog_navigation_test.dart
flutter run -d 407020D1-FCAA-4F4A-8D99-C79B980A41CB -t lib/main_dev.dart
```

Evidence is in docs/verification/levels-50-analyze.txt, levels-50-test.txt, levels-50-render.txt and levels-50-simulator.txt. The suite includes 1,000 PRNG-selected seeds per grid size for both v2 and v3 (10,000 cases total), all 50 catalog solutions/allowances, normalized uniqueness, preserved earlier identities, versioned deterministic rebuilds, global reward links, palette contrast, preview/game color equality and scrolling to level 50.

Check on the simulator:
1. Easy lists 1–15, Medium 16–35, Hard 36–50.
2. Open a mixed-color preview (for example Pattern 4 or 19); start and compare its thumbnail/board colors. Colors stay fixed while rotating.
3. Try an inverse palette in light and dark modes (the app follows its existing theme setting/provider); inspect the contact sheets for both themes if system theme changes are not exposed yet.
4. Complete the final Easy/Medium level: Next leads to 16/36 and grants +4 once. Level 50 has Replay/Home only.
5. Confirm Free Play, tutorials, Undo/Replay, reduced-motion completion and Game Over still work.

Manual native VoiceOver, Android builds and physical-device performance are not claimed. The local Android SDK is still absent. No new package or store/backend configuration was introduced.

## Learning exercise

Temporarily change only one catalog entry's paletteId from mixed to clay. Predict which values must stay identical: seed/version, solved masks, Par, move allowance and reward. Run the palette and catalog tests, inspect the preview, then restore the generated file with the content tool. A cosmetic palette must never change puzzle validity.

## Stop point

Only the 50-level catalog and color variations are delivered. Sound/Settings/persistence, ratings and purchase preparation require their next approved checkpoints. All changes remain uncommitted.

Official Flutter APIs checked: CustomPainter, ListView.builder and RepaintBoundary at https://api.flutter.dev/. Existing Flutter/Dart and package lock versions were kept.
