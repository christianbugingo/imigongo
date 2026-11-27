import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/game_effects.dart';
import '../../core/services/game_rating.dart';
import '../providers/rating_provider.dart';
import '../../core/storage/progress_database.dart';
import '../../l10n/app_localizations.dart';
import '../providers/effects_provider.dart';
import '../providers/puzzle_provider.dart';
import '../providers/settings_provider.dart';
import 'how_to_play_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _resetting = false;
  bool _openingRating = false;
  Future<void> _rateGame() async {
    if (_openingRating) return;
    setState(() => _openingRating = true);
    final outcome = await ref.read(gameRatingProvider).openListing();
    if (!mounted) return;
    setState(() => _openingRating = false);
    if (outcome == RatingOutcome.failed ||
        outcome == RatingOutcome.notConfigured) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            outcome == RatingOutcome.failed
                ? l10n.ratingOpenFailed
                : l10n.ratingNotReleased,
          ),
        ),
      );
    }
  }

  Future<void> _reset() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetProgress),
        content: Text(l10n.resetProgressQuestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelSetting),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.resetProgress),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _resetting = true);
    try {
      await ref.read(progressDatabaseProvider)?.resetProgress();
      if (!mounted) return;
      ref.read(progressSnapshotProvider.notifier).state =
          const ProgressSnapshot();
      ref.invalidate(memoryBestsProvider);
      ref.invalidate(challengeProgressProvider);
      ref.invalidate(challengePuzzleProvider);
      ref.invalidate(puzzleProvider);
      ref.invalidate(patternViewProvider);
      ref.invalidate(patternCatalogProvider);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.progressResetDone)));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.settingsSaveError)));
      }
    } finally {
      if (mounted) setState(() => _resetting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final controller = ref.read(settingsProvider.notifier);
    return PopScope(
      canPop: !_resetting,
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.settingsTitle)),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (ref.watch(settingsSaveErrorProvider))
                ListTile(
                  title: Text(l10n.settingsSaveError),
                  trailing: TextButton(
                    onPressed: controller.retry,
                    child: Text(l10n.retrySave),
                  ),
                ),
              SwitchListTile(
                title: Text(l10n.soundEnabled),
                value: settings.sound,
                onChanged: (value) async {
                  final effects = ref.read(gameEffectsProvider);
                  final pending = controller.update(
                    settings.copyWith(sound: value),
                  );
                  if (!value) {
                    try {
                      await effects?.output.stop();
                    } catch (_) {
                      /* optional audio */
                    }
                  }
                  await pending;
                },
              ),
              ListTile(
                title: Text(l10n.volumeLabel),
                subtitle: Slider(
                  label: '${(settings.volume * 100).round()}%',
                  divisions: 20,
                  value: settings.volume,
                  onChanged: settings.sound
                      ? (value) =>
                            controller.update(settings.copyWith(volume: value))
                      : null,
                ),
              ),
              TextButton.icon(
                onPressed: settings.sound && settings.volume > 0
                    ? () => ref.read(gameEffectsProvider)?.play(GameCue.rotate)
                    : null,
                icon: const Icon(Icons.volume_up),
                label: Text(l10n.previewSound),
              ),
              SwitchListTile(
                title: Text(l10n.hapticsEnabled),
                value: settings.haptics,
                onChanged: (value) =>
                    controller.update(settings.copyWith(haptics: value)),
              ),
              SwitchListTile(
                title: Text(l10n.reduceMotionSetting),
                value: settings.reduceMotion,
                onChanged: (value) =>
                    controller.update(settings.copyWith(reduceMotion: value)),
              ),
              ListTile(
                title: Text(l10n.languageSetting),
                subtitle: DropdownButton<String>(
                  isExpanded: true,
                  value: settings.language ?? 'system',
                  items: [
                    DropdownMenuItem(
                      value: 'system',
                      child: Text(l10n.systemSetting),
                    ),
                    const DropdownMenuItem(value: 'en', child: Text('English')),
                    const DropdownMenuItem(
                      value: 'fr',
                      child: Text('Français'),
                    ),
                    DropdownMenuItem(
                      value: 'rw',
                      child: Text(l10n.rwReviewLabel),
                    ),
                  ],
                  onChanged: (value) => controller.update(
                    settings.copyWith(
                      language: value,
                      systemLanguage: value == 'system',
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(l10n.themeSetting),
                subtitle: DropdownButton<String>(
                  isExpanded: true,
                  value: settings.theme,
                  items: [
                    DropdownMenuItem(
                      value: 'system',
                      child: Text(l10n.systemSetting),
                    ),
                    DropdownMenuItem(
                      value: 'light',
                      child: Text(l10n.lightSetting),
                    ),
                    DropdownMenuItem(
                      value: 'dark',
                      child: Text(l10n.darkSetting),
                    ),
                  ],
                  onChanged: (value) =>
                      controller.update(settings.copyWith(theme: value)),
                ),
              ),
              ListTile(
                title: Text(l10n.howToPlay),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push<void>(
                  MaterialPageRoute(builder: (_) => const HowToPlayScreen()),
                ),
              ),
              const Divider(),
              ListTile(
                key: const ValueKey('rate_game'),
                leading: const Icon(Icons.rate_review_outlined),
                title: Text(l10n.rateGame),
                subtitle: Text(
                  _openingRating
                      ? l10n.ratingOpening
                      : ref.watch(gameRatingProvider).canOpen
                      ? l10n.rateGameDescription
                      : l10n.ratingNotReleased,
                ),
                enabled:
                    !_openingRating && ref.watch(gameRatingProvider).canOpen,
                onTap: !_openingRating && ref.watch(gameRatingProvider).canOpen
                    ? _rateGame
                    : null,
              ),
              OutlinedButton.icon(
                onPressed: _resetting ? null : _reset,
                icon: const Icon(Icons.delete_outline),
                label: Text(l10n.resetProgress),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
