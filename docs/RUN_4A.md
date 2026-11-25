# Run and review Step 4a

## Current machine

Flutter 3.47.7 / Dart 3.13.5. Xcode and CocoaPods are installed. An iOS simulator is available, and the app was built and launched on it during this audit (see docs/verification/step4a-simulator.txt). flutter doctor reports no Android SDK; Android emulator setup below must be completed by the developer. No cloud account or key is needed.

## iOS Simulator

1. Open Simulator (`open -a Simulator`). If no device exists, use Xcode > Window > Devices and Simulators > Simulators to create one using an installed runtime.
2. In Terminal:

   ```sh
   cd /Users/a/Documents/imigongo_pattern_puzzle
   flutter pub get
   flutter devices
   ```

3. Choose an iOS simulator ID from the output. The simulator present during this audit can be run with:

   ```sh
   flutter run -d D106DC36-CC7E-4489-B710-1D1D1C7A258F -t lib/main_dev.dart
   ```

   Substitute your device ID if different. Do not pass `--flavor dev` for iOS yet: only the Runner scheme exists. main_dev.dart sets Dart dev branding; the native bundle identity is still com.yourname.imigongo, not a separate dev bundle. Real iOS flavors remain an explicitly recorded foundation gap.

## Android Emulator (setup required here)

1. Install Android Studio from https://developer.android.com/studio and run its setup wizard to install the Android SDK.
2. In SDK Manager, install the SDK platform/build tools required by flutter doctor and Android SDK Command-line Tools. If Flutter cannot find the SDK, use the SDK location shown by Android Studio:

   ```sh
   flutter config --android-sdk "<SDK location shown in Android Studio>"
   flutter doctor --android-licenses
   flutter doctor -v
   ```

3. In Android Studio's Device Manager, create a virtual device, download a compatible system image, and start it. This download/install is a developer setup action; it was not performed during the audit.
4. List devices, replace ANDROID_DEVICE_ID below with the running emulator's ID, then launch:

   ```sh
   cd /Users/a/Documents/imigongo_pattern_puzzle
   flutter devices
   flutter run --flavor dev -t lib/main_dev.dart -d ANDROID_DEVICE_ID
   ```

The configured Android dev application ID is com.yourname.imigongo.dev. It is a placeholder and must be replaced with an owned release identifier before publishing.

Official setup references checked for this audit:
- https://docs.flutter.dev/platform-integration/android/setup
- https://docs.flutter.dev/platform-integration/ios/setup
- https://docs.flutter.dev/deployment/flavors

## Review checklist

- Choose 3x3 or 6x6 and press Play; board renders with zero moves.
- Tap a tile: only that tile changes orientation and the counter advances by one.
- Undo restores both orientation and previous count. Undo starts disabled.
- Reset restores the original scramble, resets moves to zero, and disables Undo.
- The status becomes Solved only through the engine's rules. Undo after solve returns to In progress.
- No settings action, stars, hint button, sound, haptics, win screen or next-puzzle action is offered.
- On a narrow display, pan the large board; tiles remain at least 48 dp.

Automated checks:

```sh
flutter analyze
flutter test
flutter test test/ui/puzzle_provider_test.dart test/ui/puzzle_screen_test.dart
```

## UI learning exercise

Temporarily change the Undo button to always use `onPressed: controller.undo`, removing the `state.canUndo` condition. Predict which disabled-button assertions in puzzle_screen_test.dart fail, and why the engine can still safely handle an empty undo stack. Run that test, then restore the condition. This separates interaction presentation from engine correctness.

## Stop point

Step 4a only. Any additional feature needs a separately approved step. The next discussion can review this audit and choose one small subsequent UI step.
