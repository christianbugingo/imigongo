import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/tutorial_preferences.dart';

final tutorialPreferencesProvider = Provider<TutorialPreferences>(
  (ref) => LocalTutorialPreferences(),
);
final onboardingProvider = AsyncNotifierProvider<OnboardingController, bool>(
  OnboardingController.new,
);

class OnboardingController extends AsyncNotifier<bool> {
  @override
  Future<bool> build() => ref.watch(tutorialPreferencesProvider).readFinished();

  Future<bool> finish() async {
    try {
      await future;
      await ref.read(tutorialPreferencesProvider).markFinished();
      if (ref.mounted) state = const AsyncData(true);
      return true;
    } catch (_) {
      // Keep the welcome/tutorial available so a failed preference write is retryable.
      return false;
    }
  }
}
