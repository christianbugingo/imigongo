import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/ui/providers/onboarding_provider.dart';

import '../support/tutorial_preferences.dart';

void main() {
  test(
    'finish is remembered by a new controller; write failure is retryable',
    () async {
      final store = MemoryTutorialPreferences();
      ProviderContainer create() => ProviderContainer(
        overrides: [tutorialPreferencesProvider.overrideWithValue(store)],
      );
      final first = create();
      addTearDown(first.dispose);
      expect(await first.read(onboardingProvider.future), isFalse);
      store.failWrites = true;
      expect(await first.read(onboardingProvider.notifier).finish(), isFalse);
      expect(first.read(onboardingProvider).requireValue, isFalse);
      store.failWrites = false;
      expect(await first.read(onboardingProvider.notifier).finish(), isTrue);
      final second = create();
      addTearDown(second.dispose);
      expect(await second.read(onboardingProvider.future), isTrue);
    },
  );
}
