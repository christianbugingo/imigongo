# Architecture & Design Decisions (DECISIONS.md)

This document records architectural, engineering, and design decisions for the **Imigongo Pattern Puzzle** project.

---

## Record of Plan Deviations & Alignment

| Area | Initial Plan vs Delivered | Approved Adjustment & Rationale |
|---|---|---|
| **Packages** | Approved stack included Riverpod, go_router, Drift, shared_preferences, flutter_local_notifications. | **Staged Addition:** Added `shared_preferences` (settings only) and `flutter_local_notifications` in Step 1. `flutter_riverpod` and `go_router` will be added when UI begins (Step 4). `drift` is retained for player progress and future sync queue in Step 5 (never dropped silently). |
| **Directory Tree** | Feature-sliced tree was initially considered. | **Layered Layout Kept:** `lib/engine/`, `lib/models/`, `lib/core/`, `lib/services/`, `lib/ui/`. Simpler and enforces strict boundary: **zero Flutter imports in `lib/engine/`**. |
| **Target Platforms** | Web was initially created by default flutter create. | **Android & iOS Only:** Web target removed completely. |
| **Board Dimensions** | Initial enum omitted 6x6. | **Expanded Range:** Supported sizes are now 3x3 through 7x7 (`3x3`, `4x4`, `5x5`, `6x6`, `7x7`). |
| **Theming** | Light and dark themes. | **Staged:** Dark theme in Step 1; Light theme comes in Step 4 alongside board UI. |
| **Cultural Content** | Unverified Kinyarwanda pigment terms were initially in palette. | **Strict Neutrality:** Palette renamed to plain English (`charcoal`, `chalk`, `terracotta`, `ochre`). All unverified claims isolated in `docs/CULTURAL_REVIEW.md` marked "unverified, needs native review". No unverified claims shown in UI. |

---

## ADR 001: Move Targets, Star Thresholds & "Par" vs. Offline Generation Solver

### Context
Grid-based rotation puzzles feature combinatorial state spaces (up to $4^{49} \approx 3.24 \times 10^{29}$ for $7 \times 7$). Players rotate tiles using clockwise taps only.

### Decision
1. **Clockwise Controls & Move Accounting:**
   - Controls are strictly clockwise taps (+90° per tap).
   - Par counts clockwise taps only.
2. **Generator Par as Gameplay Benchmark:**
   - The generator creates a valid, solved board and applies an inverted sequence of $K$ clockwise taps (scramble depth).
   - This verified solution depth establishes **Par**.
   - **3 Stars:** $\text{movesTaken} \le \text{Par}$
   - **2 Stars:** $\text{movesTaken} \le \lfloor\text{Par} \times 1.5\rfloor$ (Note: when $\lfloor\text{Par} \times 1.5\rfloor == \text{Par}$, e.g. for $\text{Par} = 1$, 2 stars is unattainable; score jumps from 3 stars to 1 star).
   - **1 Star:** Level solved in $>\lfloor\text{Par} \times 1.5\rfloor$ moves.
3. **Offline Generation Tool Solver (Never on UI Thread):**
   - The exact minimum-move solver runs **only at content-generation time** in developer tooling (`tool/generate_puzzles.dart`), never on the user's UI thread during gameplay.
   - The solver is time-boxed (≤50ms per puzzle); if search exceeds the budget on $6 \times 6$ or $7 \times 7$ boards, the tool safely falls back to the generator's Par.
4. **Nomenclature:**
   - In UI and telemetry, always label the metric as **"Par"** or **"Target Moves"** (never an unproven "minimum").

---

## ADR 002: Notification Strategy (Local Notifications Only, Deferring FCM)

### Decision
- Daily challenge and streak reminders use local OS notifications via `flutter_local_notifications`.
- Offline-first: zero network or server dependencies required for core gameplay.
- Firebase Cloud Messaging is deferred until a feature explicitly requires remote push.

---

## ADR 003: Performance Profiling on Real Devices (Corrected)

### Context
Debug build timings and OS-level `dumpsys gfxinfo` do not reliably reflect Flutter engine frame scheduling or release bytecode performance.

### Decision
All performance profiling must be performed on physical low-end Android hardware using appropriate build modes:

1. **Cold Startup Time (Release Mode):**
   - Measured on a **Release build** (`flutter build apk --release` or `flutter run --release`).
   - Calculation: **Median of 5 consecutive cold launches** via `adb`:
     ```bash
     adb shell am force-stop com.yourname.imigongo
     adb shell am start -W -n com.yourname.imigongo/.MainActivity
     ```
   - Target: Median `TotalTime` $\le 1.8\text{ seconds}$.
2. **Release Binary Size:**
   - Measured on ABI-split release APKs (`flutter build apk --split-per-abi --release`).
   - Target: Each split APK (`app-armeabi-v7a-release.apk`, `app-arm64-v8a-release.apk`) $\le 15.0\text{ MB}$.
3. **Frame Timing & Rendering (Profile Mode):**
   - Measured strictly in **Profile mode** (`flutter run --profile`) on a physical device.
   - Measured using **Flutter DevTools Performance view** and the in-app **Performance Overlay** (`showPerformanceOverlay: true`), observing the UI thread and Raster thread rasterization time per frame.
   - Target: Consistent 60 fps ($\le 16.6\text{ms}$ per frame budget).
4. **Execution Timing:**
   - **Do not run frame profiling until the board UI exists (Step 4 onwards)**, as measuring an empty foundation screen yields misleading metrics.

---

## ADR 004: Engine Architecture & Phased Checkpoint Protocol

### Decision
- **Zero Flutter Engine Imports:** `lib/engine/` is pure Dart. It imports only standard Dart core/math libraries (`dart:math`, `dart:collection`), ensuring instantaneous headless execution and deterministic testing.
- **Deterministic PRNG:** Random generation uses a documented, seeded integer PRNG (Xoshiro128++ / 64-bit LCG) with fixed test vectors. Every puzzle stores its `generatorVersion` and integer `seed`.
- **Rule-Based Validation:** Boards are validated through geometrical continuity rules (edge connection masks), not by comparing against cached solution states.
- **Mandatory Review Checkpoint:** Work halts after Steps 2–3 for stakeholder review of the engine before any UI development begins.
