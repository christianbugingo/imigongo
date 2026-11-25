import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../providers/onboarding_provider.dart';
import 'home_screen.dart';

class LaunchGate extends ConsumerWidget {
  const LaunchGate({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return ref
        .watch(onboardingProvider)
        .when(
          data: (finished) =>
              finished ? const HomeScreen() : const WelcomeScreen(),
          loading: () => Scaffold(
            body: Center(
              child: CircularProgressIndicator(semanticsLabel: l10n.loading),
            ),
          ),
          error: (_, _) => Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.loadFailed),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => ref.invalidate(onboardingProvider),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
  }
}

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});
  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool _saving = false;
  Future<void> _skip() async {
    setState(() => _saving = true);
    final saved = await ref.read(onboardingProvider.notifier).finish();
    if (!mounted) return;
    if (saved) {
      context.go('/');
    } else {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.saveFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.welcomeTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  Text(l10n.welcomeBody),
                  const SizedBox(height: 32),
                  FilledButton(
                    key: const ValueKey('learn'),
                    onPressed: _saving ? null : () => context.go('/tutorial/0'),
                    child: Text(l10n.learnToPlay),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    key: const ValueKey('skip'),
                    onPressed: _saving ? null : _skip,
                    child: Text(l10n.skipTutorial),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
