# Architecture & Design Decisions (DECISIONS.md)

This document records the foundational architectural, engineering, and design decisions for the **Imigongo Pattern Puzzle** Flutter project.

---

## ADR 001: Move Targets, Star Thresholds & "Par" vs. Exact Minimum-Move Solver

### Context
In grid-based tile puzzles (such as rotation or swap puzzles representing traditional Rwandan Imigongo geometric patterns), determining the star rating (1, 2, or 3 stars) requires establishing a benchmark target move count. While small boards ($3 \times 3$ or $4 \times 4$) can potentially be solved to absolute optimality using graph search (BFS or IDA\*), larger grids ($5 \times 5$, and especially $7 \times 7$) explode combinatorially:
- A $7 \times 7$ board with 4 possible tile orientations per cell yields $4^{49} \approx 3.24 \times 10^{29}$ states.
- Exact minimum-move solvers for $7 \times 7$ are NP-hard or computationally prohibitive on mobile devices or during quick generation.

### Decision
1. **Generator-Derived "Par" as the Source of Truth for Stars:**
   - Every generated puzzle begins in a solved target state and is scrambled by applying a sequence of $K$ valid inverted moves (rotations/swaps).
   - The value $K$ (or the simplified path discovered during generation) establishes the **Par** value.
   - Star rating thresholds are strictly anchored to this Par:
     - **3 Stars:** Completed in $\le \text{Par}$ moves.
     - **2 Stars:** Completed in $\le \lfloor\text{Par} \times 1.5\rfloor$ moves.
     - **1 Star:** Completed with more moves (puzzle resolved successfully).
2. **Time-Boxed Minimum-Move Solver:**
   - Any exact solver implementation (IDA\* or branch-and-bound) is constrained to a strict, bounded time budget (e.g., maximum $50\text{ms}$ or a max search depth / expanded nodes cutoff).
   - If the solver does not terminate with an optimal proof within that time-box (especially on $7 \times 7$ boards), the engine **must safely fall back to the generator's Par value**.
3. **Strict Truth-in-Labeling Rule:**
   - **Never label an unproven heuristic number as an "Exact Minimum" or "Optimal Moves".**
   - In all UI, documentation, and telemetry, the benchmark is presented to the player as **"Par"** or **"Target Moves"**, creating fair, transparent gameplay without false claims of mathematical optimality.

---

## ADR 002: Notification Strategy (Local Notifications Only, Deferring FCM)

### Context
A core mechanic for daily player engagement is the Daily Imigongo Challenge and streak reminders. Push notifications can be implemented either locally via the device OS alarm/scheduler (`flutter_local_notifications`) or remotely via Firebase Cloud Messaging (FCM).

### Decision
- **Local Notifications Only:** We use `flutter_local_notifications` for scheduling daily challenge reminders at a player-selected time (e.g., 9:00 AM or 8:00 PM local time).
- **Zero Backend / Offline First:** The game must be completely playable offline. Players in areas with intermittent connectivity (a key demographic across East Africa and mobile gamers globally) must have a seamless, uninterrupted experience.
- **Defer Firebase Cloud Messaging:** FCM is deferred until a feature explicitly requires server-driven real-time pushes (such as live multiplayer tournaments or dynamic remote live-ops). This eliminates external network latency, backend infrastructure maintenance, privacy consent hurdles, and APK size bloat during Phase 1.

---

## ADR 003: Performance Budgets & Real Low-End Android Phone Strategy

### Context
Mobile gaming in emerging markets requires high responsiveness on entry-level hardware (e.g., devices with 2GB RAM, Android Go Edition, quad-core ARM Cortex-A53 or A55 CPUs, running Android 10, 11, or 12).

### Decision
We establish explicit performance budgets and profiling workflows:

| Metric | Target Budget | Measurement Method |
|---|---|---|
| **Cold Startup Time** | $\le 1.8\text{ seconds}$ | `adb shell am start -W -n ...` (`TotalTime`) |
| **Warm / Hot Startup** | $\le 600\text{ ms}$ | `adb shell am start -W -n ...` |
| **Frame Rendering Time** | $60\text{ fps}$ ($\le 16.6\text{ ms}$ per frame) | `adb shell dumpsys gfxinfo <package> framestats` |
| **Janky Frames ($>16.6\text{ms}$)** | $< 3\%$ of total frames | `dumpsys gfxinfo` jank percentage |
| **Release APK Size (per ABI)** | $\le 15.0\text{ MB}$ | `flutter build apk --split-per-abi` |
| **Runtime Memory (RAM)** | $\le 75\text{ MB}$ PSS | `adb shell dumpsys meminfo <package>` |

### Technical Architectural Enforcements:
- **Vector-Based CustomPainters:** Traditional Imigongo geometric patterns (zigzags, chevrons, lozenges, rhombuses) are drawn using lightweight mathematical paths (`CustomPainter` / `Canvas`) rather than high-resolution bitmap assets. This guarantees crisp rendering on all screen densities, near-zero image decoding overhead, and microscopic asset size.
- **Pure Dart Game Engine:** The engine (`lib/engine/`) has zero Flutter UI or widget dependencies. It operates entirely on integer bitmasks and primitive coordinate grids, executing move validations and parity checks in microseconds.

---

## ADR 004: Engine Architecture & Phased Checkpoint Protocol

### Context
Clean software engineering dictates separating logic from UI. Furthermore, the game engine's correctness must be formally validated before constructing visual layers.

### Decision
- **Strict Layer Decoupling:**
  - `lib/models/`: Immutable data structures (Board, Tile, Move, ImigongoPattern, Difficulty).
  - `lib/engine/`: Pure algorithmic logic (Generator, ParCalculator, Scrambler, Validator, Solver).
  - `lib/core/`: Palettes, cultural motifs, styling, constants.
  - `lib/services/`: Persistence, notifications, audio.
  - `lib/ui/`: Widgets, screens, custom painters (deferred to after engine review).
- **Phase 1 Checkpoint Rule:**
  - After completing Steps 2 & 3 (engine implementation + comprehensive unit tests), all work stops.
  - A comprehensive review and plain-language walkthrough of the engine will be submitted for stakeholder review before any UI is implemented.
