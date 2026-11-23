# Imigongo Pattern Puzzle 🇷🇼

A culturally grounded, offline-first mobile puzzle game celebrating **Imigongo**, the iconic traditional Rwandan geometric art form.

---

## 🎨 Cultural Heritage: What is Imigongo?

Originating in the 18th century in the Kibungo / Gisaka kingdom (modern Eastern Rwanda) under Prince Kakira, **Imigongo** is a celebrated decorative art form traditionally created by women artisans using natural materials (cow dung mixed with wood ash to create raised, sculpted relief ridges, then painted with mineral pigments).

Imigongo is distinguished by its striking, rhythmic mathematical geometries:
- **Itana / Amashyiga:** Chevron and zigzag waves symbolizing hearthstones, balance, and life energy.
- **Uruhembe:** Diamond lozenges and horns representing cattle, prosperity, and lineage.
- **Inyange:** Interlocking diamonds and triangles embodying grace and purity.
- **Bwirande:** Concentric geometric square or spiral formations.

### Traditional Palette
The authentic Imigongo color scheme uses four primary natural earthy pigments:
- **Uruzi (Deep Charcoal Black):** Prepared from soot, charcoal, and banana ash.
- **Ingwa (Chalk / Clay White):** Prepared from natural kaolin white clay.
- **Urukondo (Terracotta / Red Ochre):** Derived from iron-rich clay soils.
- **Icyondo (Warm Earth Ochre / Mustard):** Natural golden clay pigment.

---

## 🧩 Gameplay Concept

Players rotate and align scrambled geometric relief tiles on a grid ($3 \times 3$, $4 \times 4$, $5 \times 5$, or $7 \times 7$) to restore fragmented traditional Imigongo compositions into harmonic continuity.

- **Par & Move Targets:** Every level features a fair **Par** target derived from the generator's verified solution depth.
- **Star Thresholds:**
  - ⭐⭐⭐ Completed in $\le \text{Par}$ moves.
  - ⭐⭐ Completed in $\le \lfloor\text{Par} \times 1.5\rfloor$ moves.
  - ⭐ Puzzle solved.
- **Daily Challenge & Streaks:** Daily procedurally generated puzzle with local reminder notifications.
- **Lightweight & High-Performance:** Designed to run at steady 60 fps even on low-end 2GB RAM Android phones.

---

## 📂 Project Architecture

```
lib/
├── core/
│   ├── constants/       # Grid limits, time-box budgets, default rules
│   └── theme/           # Imigongo traditional color palette and styling
├── engine/              # Pure Dart puzzle engine (Zero Flutter UI dependencies)
│   ├── generator/       # Procedural puzzle generator
│   ├── par/             # Par calculator & generator solution tracker
│   ├── solver/          # Bounded time-boxed minimum solver with Par fallback
│   └── validator/       # Edge continuity & symmetry verifier
├── models/              # Immutable data structures (Board, Tile, Move, Motif)
├── services/            # Local storage (streaks) & Local notifications
└── ui/                  # Custom painters and game screens (built after engine review)
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter 3.24+ / 3.47+ & Dart 3.5+
- Android SDK (for physical device or emulator testing)

### Run Unit Tests
```bash
flutter test
```

### Run Static Analysis
```bash
flutter analyze
```

### Run Application
```bash
flutter run
```

---

## 📐 Key Architectural Decisions
See [DECISIONS.md](DECISIONS.md) for detailed Architecture Decision Records (ADRs).
