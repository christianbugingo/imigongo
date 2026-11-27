# Kinyarwanda translation worksheet

Open **KINYARWANDA_TRANSLATIONS.csv** in Excel, Numbers, a spreadsheet editor, or your code editor. It contains all 114 app messages, including existing unverified text that also needs review.

1. Read the English reference column.
2. Correct the draft text in **Kinyarwanda — write here**. Every draft is unverified and needs native review; you can work in batches.
3. Keep the key column unchanged. Keep placeholders such as `{count}`, `{moves}` and `{size}` exactly as shown; they are replaced by numbers or other values while playing.
4. For messages containing `plural`, keep the syntax and translate only the words inside each branch. If uncertain, leave it blank and add your question to Notes.
5. Save as CSV (UTF-8). Send the file back, or tell me it is ready in this folder, and I will validate the entries and transfer them to `lib/l10n/app_rw.arb`.

Editing the worksheet does not change the running app automatically. Do not edit generated `app_localizations_rw.dart`. The live translation source is `lib/l10n/app_rw.arb`, but the worksheet avoids requiring you to edit JSON or metadata.

All translations remain **needs native review** until explicitly reviewed by a native speaker. At your request, this worksheet now contains assistant-written drafts, also applied to the app for review. They are not verified translations. Cultural claims and proverbs require separate review.

English reference example: `Moves: {count}`. Translate the words `Moves:` and keep `{count}` unchanged.

Flutter's built-in Material/Cupertino control text currently uses an explicitly documented English fallback for rw; those framework strings are separate from the app messages in this worksheet. A fully reviewed framework translation is later work.

The 114 rows include five new rating messages. The worksheet and ARB drafts match at this checkpoint. The built-in framework labels still use the documented English fallback.
