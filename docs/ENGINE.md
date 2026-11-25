# Engine review: Steps 2–3

## Run and test

Use the existing pinned dependency lockfile (Flutter 3.47.7 / Dart 3.13.5 was used for this review). No new packages or cloud credentials are needed.

```sh
flutter analyze
flutter test
flutter test test/engine
# Tool runs under Dart, with no Flutter runtime or UI thread:
dart run tool/generate_puzzles.dart
```

The generation tool prints diagnostics followed by a JSON record containing every board, seed, generatorVersion, Par, targetMoves and optimality status. Elapsed time/status can differ between machines; the board and its generator Par do not.

## Walkthrough

A tile is a four-bit mask: north=1, east=2, south=4, west=8. A clockwise tap cycles these four bits and increments the board's move count. Board tile lists are immutable snapshots. GameSession keeps previous snapshots for undo; reset returns to the original board and clears history. This session API is ready for later UI integration.

The validator first checks the board boundary and matching neighboring edges. It then walks the network from one active tile: every nonempty tile must be reachable. An empty board or two separate closed loops fails. Target rotations are not consulted, so any rule-valid solution wins.

Generator version 2 starts with a connected perimeter. It grows edges from that network in a representative quadrant and reflects each addition horizontally and vertically. Thus odd/even boards retain connectivity and both reflection symmetries. These are procedural geometric placeholders, not authenticated cultural motifs. Generation supports square sizes 3 through 7.

After constructing the solved board, the generator scrambles tile rotations. If it accidentally remains solved, one rotatable tile is turned again. Par sums the cheapest clockwise restoration for each tile's visible mask: a straight needs at most one tap, an empty/cross needs zero. This is a verified route to the generated solution, not proof of a global minimum. targetScrambleTaps counts scramble operations; cancellation can make Par different from that budget.

Generator version was incremented from 1 to 2 because topology and Par changed. Every serialized board retains its seed and generatorVersion. Version 1 seeds must not silently be regenerated with version 2; preserve their full saved board or explicitly migrate them before publishing content. There is no version-1 regeneration adapter in this change.

## PRNG specification

Xoshiro128++ 1.0 uses four unsigned 32-bit words, following the authors' reference transition:
https://prng.di.unimi.it/xoshiro128plusplus.c

Our version-1 seed expansion is explicitly defined here rather than relying on Dart Random: normalize seed modulo 2^32; for each of four words add 0x9E3779B9 modulo 2^32, then apply xor-shift 16, multiply 0x85EBCA6B, xor-shift 13, multiply 0xC2B2AE35, xor-shift 16. Every multiply is reduced modulo 2^32. If all words are zero, set the first to one. Multiplication uses 16-bit limbs to avoid floating-point precision loss on JavaScript runtimes. This is a custom seed expander using the MurmurHash3 finalizer, not a claim that the authors prescribe this seeding scheme.

The PRNG algorithm version (1) is distinct from the puzzle-generator version (2). Bounded draws use nextInt modulo max, with a documented slight modulo bias; changing this mapping requires a generator-version bump. max=1 returns zero without consuming state. This generator is not for security tokens.

Independent integer-reference vectors, first five unsigned outputs:

| Seed | Outputs |
| --- | --- |
| 0 | 4226848253, 3853465007, 1657604656, 2135928087, 1643513283 |
| 1 | 3187778163, 3899520863, 270678034, 2950105546, 3415064141 |
| 123456789 | 3168685543, 1443940476, 2581779008, 4122392184, 3303506236 |
| 4294967295 | 2846478547, 2130249462, 456585916, 4065942502, 3472031905 |

Native tests freeze these vectors; they are not a substitute for running tests on every target architecture before release.

## Exact solver: tooling only

The implementation lives in tool/solver, outside lib. It considers every distinct orientation of every tile, including tiles already at the stored target. It prunes boundary violations, mismatches against assigned neighbors, duplicate visible orientations and branches costing at least the best verified solution. Complete candidates still pass the normal connectivity validator.

A valid generated solution provides an upper bound. Exhausting all cheaper candidates proves the minimum; timing out returns the generator's Par with isProvablyOptimal=false. No fallback is labeled a minimum. Budgets are restricted to 0–50 ms by ADR 001, measured with Stopwatch; checks are cooperative, so OS scheduling or an in-flight operation can make observed wall-clock duration slightly exceed the deadline. Zero budget deterministically tests fallback without depending on machine speed.

No application code imports the solver. A source-boundary test guards this, alongside the pure-Dart engine import rule. Stronger isolation into a separate package can follow if the project grows.

## Verification scope

- 1,000 PRNG-selected seeds per size 3–7: reproducibility, stored version, unsolved scramble, restored solution, exact Par restoration cost and horizontal/vertical reflection properties.
- Dangling edges, boundary escapes, empty boards, disconnected closed loops, alternative target orientations and all tile degrees.
- Cheapest equivalent rotation for all 16 masks and four starting rotations.
- Undo/reset, immutable snapshots, invalid coordinates and generator parameters.
- Exact tooling solver versus an independent exhaustive 2x2 orientation oracle; explicit timeout fallback and small-board exact cases.
- Existing provider/widget/foundation tests also run.

The generator creates geometric candidates; chapter quality and difficulty tuning remain content work. Exhaustive optimality on every 7x7 is deliberately not promised. No device performance claim is made by these headless tests.

## Learning exercise

In the connected-network fixture `[6,14,12,7,15,13,3,11,9]`, change the center mask from 15 (N+E+S+W) to 7 (N+E+S). Before running tests, predict which test fails and which neighbor loses its matching connection. Then run `flutter test test/engine/properties_test.dart` and explain why the remaining connected-looking pattern is still invalid.

## Documentation checked

- Dart Stopwatch: https://api.dart.dev/dart-core/Stopwatch-class.html
- Flutter test guidance: https://docs.flutter.dev/testing/overview
- Existing Riverpod 3 providers required the documented legacy import: https://riverpod.dev/docs/3.0_migration
- Existing settings radio APIs were updated without adding features: https://api.flutter.dev/flutter/widgets/RadioGroup-class.html
