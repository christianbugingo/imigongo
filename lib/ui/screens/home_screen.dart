import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_flavor.dart';
import '../../l10n/app_localizations.dart';
import 'how_to_play_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.settingsTitle,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          if (AppConfig.flavor.isDev)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(l10n.developmentBadge),
            ),
          IconButton(
            tooltip: l10n.howToPlay,
            icon: const Icon(Icons.help_outline),
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute(builder: (_) => const HowToPlayScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.geometricReliefPuzzle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(l10n.chooseDifficulty),
                  const SizedBox(height: 24),
                  for (final entry in [
                    ('easy', l10n.easy),
                    ('medium', l10n.medium),
                    ('hard', l10n.hard),
                  ])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: FilledButton(
                        key: ValueKey('difficulty_${entry.$1}'),
                        onPressed: () => context.push('/patterns/${entry.$1}'),
                        child: Text(entry.$2),
                      ),
                    ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => context.push('/free-play'),
                    child: Text(l10n.freePlay),
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.challengeSessionNote),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
