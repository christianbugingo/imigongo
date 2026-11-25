import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../providers/puzzle_provider.dart';
import '../widgets/pattern_image.dart';

class PatternSelectionScreen extends ConsumerWidget {
  final String tier;
  const PatternSelectionScreen({super.key, required this.tier});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final patterns = ref.watch(patternCatalogProvider(tier));
    final title = switch (tier) {
      'easy' => l10n.easy,
      'medium' => l10n.medium,
      _ => l10n.hard,
    };
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        itemCount: patterns.length + 1,
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(l10n.choosePattern),
            );
          }
          final pattern = patterns[index - 1];
          return Card(
            child: InkWell(
              key: ValueKey('choose_${pattern.id}'),
              onTap: () => context.push('/preview/${pattern.id}'),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.patternNumber(pattern.number),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 220),
                        child: PatternImage(
                          tiles: pattern.tiles,
                          paletteId: pattern.paletteId,
                          size: pattern.size,
                          label: l10n.patternNumber(pattern.number),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.allowanceValue(
                        pattern.baseMoves + pattern.bonusMoves,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PatternPreviewScreen extends ConsumerWidget {
  final String id;
  const PatternPreviewScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final pattern = ref.watch(patternViewProvider(id));
    if (pattern == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.patternUnavailable),
              TextButton(
                onPressed: () => context.go('/'),
                child: Text(l10n.home),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.patternNumber(pattern.number))),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            key: const ValueKey('start_challenge'),
            onPressed: () => context.push('/challenge/$id'),
            child: Text(l10n.startPuzzle),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.patternPreview),
                const SizedBox(height: 16),
                PatternImage(
                  tiles: pattern.tiles,
                  paletteId: pattern.paletteId,
                  size: pattern.size,
                  label: l10n.referencePattern,
                ),
                const SizedBox(height: 16),
                Text(l10n.previewRule),
                const SizedBox(height: 12),
                Text(
                  l10n.allowanceValue(pattern.baseMoves + pattern.bonusMoves),
                ),
                if (pattern.bonusMoves > 0)
                  Text(l10n.bonusIncluded(pattern.bonusMoves)),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
