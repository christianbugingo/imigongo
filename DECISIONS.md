# Architecture & Design Decisions (DECISIONS.md)

This document records architectural, engineering, and design decisions for the **Imigongo Pattern Puzzle** project.

---

## Record of Plan Deviations & Alignment

| Area | Initial Plan vs Delivered | Recorded adjustment / current status |
|---|---|---|
| **Packages** | Original stack plus later notification adjustment. | Riverpod/go_router are already installed by the early prototype. Drift is not installed; progress/sync persistence remains deferred. Installed packages are not evidence of implemented features. |
| **Directory Tree** | Feature-sliced tree was initially considered. | **Layered Layout Kept:** `lib/engine/`, `lib/models/`, `lib/core/`, `lib/services/`, `lib/ui/`. Simpler and enforces strict boundary: **zero Flutter imports in `lib/engine/`**. |
| **Target Platforms** | Web was initially created by default flutter create. | **Android & iOS Only:** Web target removed completely. |
| **Board Dimensions** | Initial enum omitted 6x6. | **Expanded Range:** Supported sizes are now 3x3 through 7x7 (`3x3`, `4x4`, `5x5`, `6x6`, `7x7`). |
| **Theming** | Light and dark themes. | **Staged:** Dark theme in Step 1; Light theme comes in Step 4 alongside board UI. |
| **Cultural Content** | Palette renamed, but later audit found leftover motif keys and an unsupported painter claim. | Remaining legacy motif identifiers and painter claim removed during the Step 4a audit. Unverified notes remain only in docs/CULTURAL_REVIEW.md; translations need native review. |

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
- **Deterministic PRNG:** Random generation uses a documented, seeded integer PRNG (Xoshiro128++ with a custom documented 32-bit seed expander) with fixed test vectors. Every puzzle stores its `generatorVersion` and integer `seed`.
- **Rule-Based Validation:** Boards are validated through geometrical continuity rules (edge connection masks), not by comparing against cached solution states.
- **Mandatory Review Checkpoint:** Work halts after Steps 2–3 for stakeholder review of the engine before any UI development begins.

### Steps 2–3 review corrections (2026-11-25)

- Generator version 2 replaces the unsymmetrical/disconnected version-1 motifs with connected reflection orbits; retain versions with all serialized seeds.
- Xoshiro128++ remains algorithm version 1 with a precisely documented custom 32-bit seed expander and independent fixed vectors (see docs/ENGINE.md).
- Par uses visually equivalent masks; it is a verified upper bound, never an unproven minimum.
- The solver implementation now lives exclusively in tool/solver. It searches all distinct tile orientations, not only tiles different from the stored target. ADR 001's 50 ms cooperative deadline and explicit Par fallback apply there.
- Validator adds the previously missing single-network traversal. Undo/reset use immutable engine snapshots.
- The existing UI commit was present before this task. Only Riverpod import and deprecated radio API compatibility repairs were made to unblock full-project analyze/test; no Step 4 features were added.


## Process correction and Step 4a authorization (2026-11-25)

Commit `0f2fd3b` (Game UI & Custom Painters) introduced UI before the required engine review checkpoint. This violated ADR 004. The UI was a prototype, not completed or accepted Step 4 work. Earlier wording that merely said the commit pre-existed did not acknowledge the process violation.

From now on, implement only the explicitly approved step. Discoveries outside that scope are documented, not silently implemented. Existing code, installed packages, or a past commit do not establish acceptance. Stop at each requested checkpoint and provide evidence before further work.

The user approved only Step 4a: audit the prototype and deliver board rendering, clockwise tap, move count, engine-derived solved status, undo and reset through a tested Riverpod controller. Remove premature star/victory/next-puzzle presentation and disconnect settings navigation. Hints, haptics, sound, win screen, 30-level content, Drift persistence and settings remain deferred. Do not implement Step 4b or Phase 2 without a new approval.

### Audit limitations that remain open

- App identity is configured as placeholder `com.yourname.imigongo` (Android dev adds `.dev`); a final owned release identifier has not been supplied. iOS dev/prod schemes are not implemented (only Runner exists).
- CI has analyze/test jobs but no debug-build step. Hosted CI green status is not verified by local tests.
- Web source target was removed in `5a37f3d`; `.metadata` still records its historical creation. No Web target is delivered.
- Contrast tests check selected foreground/background pairs; they do not certify every screen or accessibility behavior.
- Future hint design needs its own approved implementation and tests; Step 4a includes no hint logic.

Detailed evidence and before/after statuses: docs/AUDIT_4A.md. Solver observations are a sample, not a difficulty or optimality guarantee for all seeds.

## Historical app-logo experiment and commit permission (artwork superseded)

The user explicitly requested adapting their supplied circular pattern photograph as the app logo. This authorizes native branding/icon changes, separately from gameplay steps. The pattern was recreated without the wooden background and installed into native launcher icon assets; no new gameplay feature is authorized by this request.

The user instructed that no further changes be committed without permission. This applies to all future work: implementation approval is not commit approval. AGENTS.md records this rule. The logo work was never committed. Its artwork was subsequently retired by the Step 4b original-art policy below.


## Approved roadmap change: Step 4b only

The user approved the professional-game design brief and then the proposed Step 4b plan. The roadmap is 4b (win/results, How to Play, first-run authored tutorial, game/Pause layout), 4c (visual identity/seamless relief/new Home), 5 (Journey, persistent progress, Settings, Credits, Collection), 6 (sound/haptics and release/performance checks). Only 4b is authorized for implementation now. Stop for review afterward. No commits without explicit permission; approval of this step does not authorize commits.

The photo-derived logo is retired under the new original-art policy. The adaptation is moved outside the repo to Documents/imigongo_reference; default launcher icons are restored. An original logo and visual-art manifest belong to 4c. No third-party visual reference is embedded or committed.

Step 4b keeps the engine as the only gameplay authority. Undo restores the previous board and decreases the move count; Restart begins a fresh attempt. Once solved, the attempt locks (including Undo) through completion/results; Replay starts a new attempt. This intentionally replaces 4a's post-solve Undo behavior to prevent repeat rewards or duplicate result events. Best moves live only in memory and are keyed by size, seed and generatorVersion; tutorials do not write them.

Authored tutorial data uses generatorVersion=0 with lesson-index seeds, distinct from generated content version 2. Internal route/controller keys -1..-3 select these authored records and are never generated or ranked. No special tutorial game rules exist.

The 4b result flow uses a short 1-second completion hold followed by sequential star reveals. It does not implement 4c's network glow/region fill. System reduced motion removes both hold and star/diagram animations. Sounds and haptics wait for Step 6. No placeholder Settings action appears before Step 5.
