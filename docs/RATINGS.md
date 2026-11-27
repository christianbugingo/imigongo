# Kinyarwanda drafts and game ratings checkpoint

The user authorized draft Kinyarwanda translations for native review, followed by ratings. The user confirmed that no store listings exist yet. Purchases remain unstarted. No commits were made.

## Translation review

All 114 app messages now have assistant-written Kinyarwanda drafts in both `lib/l10n/app_rw.arb` and [the editable worksheet](translations/KINYARWANDA_TRANSLATIONS.csv). They are **needs native review**, not verified translations. Correct the worksheet's Kinyarwanda column, keep the keys/placeholders unchanged, and tell the developer when it is ready to apply. Worksheet edits do not automatically update the app.

All rw ARB descriptions retain draft/native-review flags; the language chooser also identifies rw as needing review. Framework controls retain the English fallback introduced for the locale crash. Color labels describe colors, without introducing pigment origins or cultural claims. No proverbs or cultural facts were added. The stale Free Play session-only note was corrected in all three languages to reflect saved on-device progress.

## Delivered rating behavior

Settings has a localized “Rate this game” row. Once a real listing is configured, it opens the native App Store review destination on iOS, or the installed package's Play Store listing on Android, using `in_app_review` 2.0.12. It does not display a custom star form, reward ratings, ask about satisfaction, or claim the user submitted a review. No automatic popup requests were added.

With no listing configured, the row is disabled and explains that rating is available after store release. Dev builds cannot open a real listing even if release flags are supplied. Only the production app environment can enable it. Windows/macOS/Linux are not supported by this game's rating flow.

`GameRating` handles gating, duplicate launch requests and platform errors behind a Riverpod provider. The Settings screen shows a localized retryable failure if opening the store fails. No rating or review text is collected by our database; the actual store interaction is handled by Apple/Google.

A manual rating button opens the store page because the quota-controlled native `requestReview()` popup is not guaranteed to appear. That distinction follows [Google's guidance](https://developer.android.com/guide/playcore/in-app-review#quotas), [Apple's guidance](https://developer.apple.com/documentation/storekit/requesting-app-store-reviews), and the [plugin's button guidance](https://pub.dev/packages/in_app_review/versions/2.0.12). No review display or submission can be inferred from a successful API return.

## Enabling later — requires your real store records

Do not enable the flags now. A real listing does not yet exist; no account setup, console change, upload or publication was performed.

1. Finalize the production iOS bundle ID and Android application ID before creating store records. The repository still has the existing `com.yourname.imigongo` development identity; changing it is separate release work.
2. For iOS, create/select this game's real App Store Connect record. Under **General → App Information**, copy the numeric **Apple ID** (not the bundle ID). [Apple's app information reference](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information/) distinguishes those identifiers.
3. For Android, use the Play Console record for the exact production application ID. The plugin uses the installed Android package ID, so the `.dev` flavor is deliberately blocked. Wait until the intended store listing/review destination is accessible to the intended users.
4. Copy `config/ratings.example.json` to `config/ratings.prod.json`. The filled file is gitignored. Put the real numeric Apple ID in `APP_STORE_ID`; set `IOS_STORE_LISTING_READY` and/or `ANDROID_STORE_LISTING_READY` to true only for the platform with a usable listing. Leave other flags false. These are public listing identifiers, not secret credentials; never put other service secrets in this file.
5. Run the production environment with the config:

```sh
# iOS simulator/device; native iOS flavors are not configured yet.
flutter run -t lib/main_prod.dart --dart-define-from-file=config/ratings.prod.json
# Android device, once Android tooling and the real release identity are ready:
flutter run --flavor prod -t lib/main_prod.dart --dart-define-from-file=config/ratings.prod.json
```

6. On a real device, open Settings → Rate this game. Verify the correct game's store page opens, dismiss/back returns to the game, and unavailable/offline store conditions degrade gracefully. Do not submit a real review as an automated test. TestFlight/simulator behavior does not establish production review submission. [Google's review testing guidance](https://developer.android.com/guide/playcore/in-app-review/test) describes internal-track/internal-sharing limitations for any future native-popup integration.

## Run and review now

```sh
flutter run -d 407020D1-FCAA-4F4A-8D99-C79B980A41CB -t lib/main_dev.dart
flutter analyze
flutter test
```

Switch Settings → Language to Kinyarwanda. Review Home, all difficulty labels, preview, Pause, results, reset confirmation, and the unavailable rating explanation. Correct unclear wording in the worksheet. The framework Back control can still be English by design.

**Local results:** `flutter analyze` reports no issues; `flutter test` passes all 129 tests. Worksheet validation confirms all 114 draft values match the ARB source and preserve their review flags.

Service tests inject a fake store gateway; widget tests cover disabled/configured/failure cases. Those tests do not open a real store. No production listing, actual review submission, physical Android build or live App Store link was verified. See `docs/verification/ratings-analyze.txt`, `ratings-test.txt` and `ratings-simulator.txt`.

Exercise: set a valid-looking Apple ID but keep `IOS_STORE_LISTING_READY` false in a test configuration. Predict whether the Settings rating action will be enabled, then run the service test and explain the extra gate.
