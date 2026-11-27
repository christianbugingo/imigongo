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

## Step 4b UI strings — needs native review

- [ ] `welcomeTitle`: Welcome to Imigongo [needs native review] — **needs native review**
- [ ] `welcomeBody`: A quiet puzzle of connected lines. Learn with three short practice boards. [needs native review] — **needs native review**
- [ ] `learnToPlay`: Learn to play [needs native review] — **needs native review**
- [ ] `skipTutorial`: Skip tutorial [needs native review] — **needs native review**
- [ ] `howToPlay`: How to Play [needs native review] — **needs native review**
- [ ] `back`: Back [needs native review] — **needs native review**
- [ ] `resume`: Resume [needs native review] — **needs native review**
- [ ] `restart`: Restart [needs native review] — **needs native review**
- [ ] `pause`: Pause [needs native review] — **needs native review**
- [ ] `paused`: Paused [needs native review] — **needs native review**
- [ ] `home`: Home [needs native review] — **needs native review**
- [ ] `replay`: Replay [needs native review] — **needs native review**
- [ ] `nextPuzzle`: Next puzzle [needs native review] — **needs native review**
- [ ] `nextLesson`: Next lesson [needs native review] — **needs native review**
- [ ] `finishTutorial`: Finish tutorial [needs native review] — **needs native review**
- [ ] `newBest`: New best [needs native review] — **needs native review**
- [ ] `levelComplete`: Level complete [needs native review] — **needs native review**
- [ ] `lessonComplete`: Lesson complete [needs native review] — **needs native review**
- [ ] `completionAnnouncement`: Level complete, {stars, plural, =1{1 star} other{{stars} stars}} [needs native review] — **needs native review**
- [ ] `freePlayTitle`: Free Play · {size}×{size} [needs native review] — **needs native review**
- [ ] `gridSize`: {size}×{size} [needs native review] — **needs native review**
- [ ] `tutorialTitle`: Tutorial {number} of 3 [needs native review] — **needs native review**
- [ ] `movesValue`: Moves: {count} [needs native review] — **needs native review**
- [ ] `targetValue`: Target moves: {count} [needs native review] — **needs native review**
- [ ] `tileLabel`: Tile at row {row}, column {col}. Connections: {connections}. [needs native review] — **needs native review**
- [ ] `north`: north [needs native review] — **needs native review**
- [ ] `east`: east [needs native review] — **needs native review**
- [ ] `south`: south [needs native review] — **needs native review**
- [ ] `west`: west [needs native review] — **needs native review**
- [ ] `noConnections`: none [needs native review] — **needs native review**
- [ ] `ruleOne`: Tap a tile to turn it a quarter turn clockwise. [needs native review] — **needs native review**
- [ ] `ruleTwo`: Join the lines so no line ends in the open or points off the board. [needs native review] — **needs native review**
- [ ] `ruleThree`: Everything must connect into one single pattern. [needs native review] — **needs native review**
- [ ] `ruleFour`: Use as few turns as you can. Reach the target moves for three stars. [needs native review] — **needs native review**
- [ ] `ruleFive`: Undo and Restart are always free. [needs native review] — **needs native review**
- [ ] `lessonOne`: One tile needs a turn. Tap it to complete the pattern. [needs native review] — **needs native review**
- [ ] `lessonTwo`: Match every open end. All lines must belong to one connected pattern; separate loops do not count. [needs native review] — **needs native review**
- [ ] `lessonThree`: Try Undo or Restart, then solve the board. Meet the target moves to earn three stars. [needs native review] — **needs native review**
- [ ] `tutorialNotice`: Practice only: these results do not affect your Free Play bests. [needs native review] — **needs native review**
- [ ] `chooseSize`: Choose a Free Play grid [needs native review] — **needs native review**
- [ ] `loading`: Loading [needs native review] — **needs native review**
- [ ] `loadFailed`: Could not load tutorial preferences. [needs native review] — **needs native review**
- [ ] `retry`: Retry [needs native review] — **needs native review**
- [ ] `saveFailed`: Could not remember tutorial completion. Please try again. [needs native review] — **needs native review**
- [ ] `practiceTutorial`: Practice the tutorial [needs native review] — **needs native review**
- [ ] `sessionBestNote`: Free Play bests last until the app closes. [needs native review] — **needs native review**
- [ ] `developmentBadge`: DEV [needs native review] — **needs native review**

## Challenge preview and move-budget strings — needs native review

- [ ] `chooseDifficulty`: Choose a challenge difficulty [needs native review] — **needs native review**
- [ ] `easy`: Easy [needs native review] — **needs native review**
- [ ] `medium`: Medium [needs native review] — **needs native review**
- [ ] `hard`: Hard [needs native review] — **needs native review**
- [ ] `freePlay`: Free Play [needs native review] — **needs native review**
- [ ] `challengeSessionNote`: Challenge progress and bonus moves last for this app session. Free Play has no move limit. [needs native review] — **needs native review**
- [ ] `choosePattern`: Choose the pattern you want to complete. [needs native review] — **needs native review**
- [ ] `patternNumber`: Pattern {number} [needs native review] — **needs native review**
- [ ] `allowanceValue`: Move allowance: {count} [needs native review] — **needs native review**
- [ ] `bonusIncluded`: Includes {count} earned bonus moves. [needs native review] — **needs native review**
- [ ] `patternUnavailable`: This pattern is not available. [needs native review] — **needs native review**
- [ ] `patternPreview`: Study the completed pattern before you start. [needs native review] — **needs native review**
- [ ] `previewRule`: Use this as your reference. Any single connected pattern with no loose ends is a valid solution. [needs native review] — **needs native review**
- [ ] `referencePattern`: Completed reference pattern [needs native review] — **needs native review**
- [ ] `referenceHint`: Your reference stays here. Tap it to enlarge. [needs native review] — **needs native review**
- [ ] `startPuzzle`: Start puzzle [needs native review] — **needs native review**
- [ ] `remainingMoves`: Moves left: {count} [needs native review] — **needs native review**
- [ ] `bonusReward`: +{count} moves earned for the next pattern [needs native review] — **needs native review**
- [ ] `gameOver`: Game over [needs native review] — **needs native review**
- [ ] `outOfMoves`: No moves left. Replay this pattern with a fresh allowance. [needs native review] — **needs native review**
- [ ] `challengeHelp`: Challenges have a move limit. Solving a pattern earns four extra moves for its next pattern, once per level. Undo returns a move while the attempt is active. [needs native review] — **needs native review**

## 50-level palette text

- [ ] `colorHelp`: Colors are decorative. Match the connections, not the colors. [needs native review] — **needs native review**. This is an English placeholder in app_rw.arb, not a verified translation.

The new networks and palette labels carry no traditional pattern names or cultural meanings.

## Settings checkpoint strings

All new rw values remain English placeholders, **needs native review**.
- [ ] `settingsTitle`
- [ ] `soundEnabled`
- [ ] `volumeLabel`
- [ ] `previewSound`
- [ ] `hapticsEnabled`
- [ ] `reduceMotionSetting`
- [ ] `languageSetting`
- [ ] `themeSetting`
- [ ] `systemSetting`
- [ ] `lightSetting`
- [ ] `darkSetting`
- [ ] `resetProgress`
- [ ] `resetProgressQuestion`
- [ ] `cancelSetting`
- [ ] `progressResetDone`
- [ ] `settingsSaveError`
- [ ] `retrySave`
- [ ] `savingProgress`
- [ ] `progressSaveError`
- [ ] `localStorageError`
- [ ] `savedProgressLabel`
- [ ] `rwReviewLabel`
- [ ] `challengeSessionNote`

## User translation worksheet

All 109 current app strings are listed with English references and blank Kinyarwanda fields in [KINYARWANDA_TRANSLATIONS.csv](translations/KINYARWANDA_TRANSLATIONS.csv). See [worksheet instructions](translations/README.md). Entries remain **needs native review** until reviewed. Editing the worksheet does not automatically change ARB files. Built-in framework controls temporarily use English for rw; this fallback is not a verified Kinyarwanda translation.

## Assistant-written drafts requested by the user

The worksheet now has 114 draft translations, also applied to `app_rw.arb`. This supersedes the earlier blank 109-row worksheet. Every draft is **needs native review**; no string has been marked reviewed. The five rating-message keys also need review:

- [ ] `rateGame`
- [ ] `rateGameDescription`
- [ ] `ratingNotReleased`
- [ ] `ratingOpenFailed`
- [ ] `ratingOpening`

Review and correct all worksheet entries, including the earlier placeholder strings. App terminology, directions, plural wording, accessibility labels and the distinction between haptics and animations need particular attention. Color labels are descriptive drafts, not pigment-origin claims. Framework controls continue to use the explicit English fallback.
