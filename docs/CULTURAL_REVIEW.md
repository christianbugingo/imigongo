# Cultural Review (docs/CULTURAL_REVIEW.md)

> [!WARNING]
> **Status: UNVERIFIED, NEEDS NATIVE REVIEW**
> The cultural assertions, Kinyarwanda naming, and historical pigment claims below are unverified working notes without verified source citations. They must NOT be presented in the user-facing UI, marketing, or code identifiers until reviewed, corrected, and approved by native Rwandan cultural and language reviewers. Source labels below are inherited notes, not verified provenance.

---

## 1. Terminology & Motif Names (Pending Native Verification)

| Term / Motif Name | Current Working Translation | Source / Context | Verification Status |
|---|---|---|---|
| *Imigongo* | Traditional relief geometric art | Historical literature | Unverified, needs native review |
| *Itana* / *Amashyiga* | Hearthstone / chevron wave pattern | Working hypothesis | Unverified, needs native review |
| *Uruhembe* | Cattle horns / diamond lozenge pattern | Working hypothesis | Unverified, needs native review |
| *Inyange* | Triangle motif / crane or purity | Working hypothesis | Unverified, needs native review |
| *Bwirande* | Concentric geometric square or spiral | Working hypothesis | Unverified, needs native review |

---

## 2. Color Pigments & Attributions (Pending Native Verification)

The following traditional names and pigment claims were removed from code identifiers and UI strings:

- **Charcoal / Black (working label "Uruzi"):** Claimed in literature to derive from banana peel ash, soot, and charcoal. Needs native verification of term and historical practice.
- **Chalk / White (working label "Ingwa"):** Claimed in literature to derive from kaolin white clay. Needs native verification.
- **Terracotta / Red (working label "Urukondo"):** Claimed to derive from iron-rich soil / ochre clay. Needs native verification.
- **Ochre / Yellow (working label "Icyondo"):** Claimed to derive from yellow clay mineral pigment. Needs native verification.

---

## 3. Policy for In-App UI and Code Identifiers
1. **Plain English Identifiers:** Code references must use descriptive English terms (`charcoal`, `chalk`, `terracotta`, `ochre`).
2. **No In-App Cultural Assertions:** Do not display unverified historical or pigment claims in the game interface.
3. **No Claims of Authenticity:** Avoid asserting "authenticity" until accredited by Rwandan cultural institutions (e.g., Rwanda Cultural Heritage Academy / Inteko y'Umuco).


## Step 4a cleanup

The early UI painter asserted "authentic" rendering without review; that claim was removed. Legacy motif identifiers were still present in engine_constants.dart despite the earlier cleanup claim; they are now removed, and the unverified names/translations above are retained only as review notes. No pigment origin is represented by palette code or tests.

The removed settings prototype asserted the art form's origin without its own review marker; that screen is deferred and removed from the active source. The original README cultural description is also withheld from the current status README pending review. None of these notes establishes authenticity or verifies terminology.

## Kinyarwanda ARB review checklist

Every value in app_rw.arb is a placeholder and has `needs native review` metadata. New Step 4a controls use explicitly marked English placeholders rather than invented translations. Review each entry before production:

- [ ] `appTitle`: Imigongo — **needs native review**
- [ ] `geometricReliefPuzzle`: Umukino w'Ubugeni bw'Imigongo — **needs native review**
- [ ] `play`: Gukina — **needs native review**
- [ ] `settings`: Ibyigenewe — **needs native review**
- [ ] `dailyChallenge`: Umukoro w'Umunsi — **needs native review**
- [ ] `moves`: Intambwe — **needs native review**
- [ ] `par`: Intego — **needs native review**
- [ ] `targetMoves`: Intambwe Ziteganyijwe — **needs native review**
- [ ] `solved`: Birarangiye — **needs native review**
- [ ] `starsEarned`: {count, plural, =1{Inyenyeri 1} other{Inyenyeri {count}}} — **needs native review**
- [ ] `rotateInstruction`: Kanda ku gasanduku kugira ngo gahindukire — **needs native review**
- [ ] `colorCharcoal`: Umukara — **needs native review**
- [ ] `colorChalk`: Umweru — **needs native review**
- [ ] `colorTerracotta`: Umutuku w'ibumba — **needs native review**
- [ ] `colorOchre`: Umuhondo w'ibumba — **needs native review**
- [ ] `undo`: Undo [needs native review] — **needs native review**
- [ ] `reset`: Reset [needs native review] — **needs native review**
- [ ] `inProgress`: In progress [needs native review] — **needs native review**
