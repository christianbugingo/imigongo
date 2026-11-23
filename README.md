# Imigongo Pattern Puzzle

A mobile puzzle game inspired by traditional geometric relief patterns.

---

## 🎨 Cultural Context & Review
Imigongo is a traditional geometric relief art form from Rwanda featuring rhythmic mathematical patterns (diamonds, chevrons, zigzags, and concentric formations).

> [!NOTE]
> All specific historical assertions, Kinyarwanda terminology, and pigment claims are documented in [docs/CULTURAL_REVIEW.md](docs/CULTURAL_REVIEW.md) and marked **"unverified, needs native review"**. In-game code identifiers use descriptive English terms (`charcoal`, `chalk`, `terracotta`, `ochre`), and unverified claims are omitted from the UI pending review by cultural authorities.

---

## 🧩 Gameplay Concept

Players rotate scrambled geometric tiles on a grid ($3 \times 3$ through $7 \times 7$) using single clockwise taps to align path edges into harmonic continuity.

- **Par & Move Targets:** Every level features a fair **Par** target derived from the generator's verified solution depth.
- **Clockwise-Only Accounting:** Controls are clockwise only; Par counts clockwise taps.
- **Star Thresholds:**
  - ⭐⭐⭐ Completed in $\le \text{Par}$ moves.
  - ⭐⭐ Completed in $\le \lfloor\text{Par} \times 1.5\rfloor$ moves.
  - ⭐ Puzzle solved.
- **Daily Challenge & Streaks:** Offline-first daily puzzle with local reminder notifications.
- **Performance:** Release cold startup median $\le 1.8\text{s}$, 60 fps in Profile mode, APK $\le 15\text{MB}$.

---

## 📂 Project Architecture

```
lib/
├── core/
│   ├── constants/       # Grid limits, time-box budgets, default rules
│   └── theme/           # Color palette and styling
├── engine/              # Pure Dart puzzle engine (Zero Flutter UI imports)
│   ├── generator/       # Deterministic PRNG & procedural generator
│   ├── models/          # Board, Tile, Move, ConnectionMask
│   ├── par/             # Par calculator & generator solution tracker
│   └── validator/       # Rule-based geometrical continuity verifier
├── models/              # Shared enums (GridDimension, TileRotation, StarRating)
├── services/            # Local storage & Local notifications
└── ui/                  # Custom painters and game screens (Step 4 onwards)
tool/
└── generate_puzzles.dart # Offline puzzle generation & solver tool
```

---

## 🚀 Getting Started

### Run Tests
```bash
flutter test
```

### Run Static Analysis
```bash
flutter analyze
```

### Key Decisions
See [DECISIONS.md](DECISIONS.md) for Architecture Decision Records (ADRs).
