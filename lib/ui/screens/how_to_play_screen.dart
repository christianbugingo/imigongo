import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../models/puzzle_view.dart';
import '../painters/tile_painter.dart';
import '../providers/puzzle_provider.dart';

class HowToPlayScreen extends ConsumerStatefulWidget {
  const HowToPlayScreen({super.key});
  @override
  ConsumerState<HowToPlayScreen> createState() => _HowToPlayScreenState();
}

class _HowToPlayScreenState extends ConsumerState<HowToPlayScreen> {
  Timer? _timer;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timer?.cancel();
    if (!MediaQuery.disableAnimationsOf(context) &&
        TickerMode.valuesOf(context).enabled) {
      _timer = Timer.periodic(const Duration(milliseconds: 1400), (_) {
        ref.read(rotationDiagramProvider.notifier).advance();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final demo = ref.watch(rotationDiagramProvider);
    final network = ref.watch(networkDiagramProvider);
    final reduce = MediaQuery.disableAnimationsOf(context);
    final rules = [
      l10n.ruleOne,
      l10n.ruleTwo,
      l10n.ruleThree,
      l10n.ruleFour,
      l10n.ruleFive,
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.howToPlay),
        leading: IconButton(
          tooltip: l10n.back,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          for (var i = 0; i < rules.length; i++)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rules[i],
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    if (i == 0) ...[
                      const SizedBox(height: 12),
                      ExcludeSemantics(
                        child: AnimatedSwitcher(
                          duration: reduce
                              ? Duration.zero
                              : const Duration(milliseconds: 180),
                          child: _DiagramTile(
                            key: ValueKey(demo.mask),
                            tile: demo,
                          ),
                        ),
                      ),
                    ],
                    if (i == 2) ...[
                      const SizedBox(height: 12),
                      ExcludeSemantics(
                        child: SizedBox.square(
                          dimension: 120,
                          child: RepaintBoundary(
                            child: GridView.count(
                              crossAxisCount: 3,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              children: [
                                for (final tile in network)
                                  _DiagramTile(tile: tile),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          Text(l10n.challengeHelp),
          const SizedBox(height: 12),
          Text(l10n.colorHelp),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => context.go('/tutorial/0'),
            child: Text(l10n.practiceTutorial),
          ),
        ],
      ),
    );
  }
}

class _DiagramTile extends StatelessWidget {
  final TileView tile;
  const _DiagramTile({super.key, required this.tile});
  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: 64,
    child: RepaintBoundary(
      child: CustomPaint(
        painter: TilePainter(
          tile: tile,
          ridgeColor: Theme.of(context).colorScheme.onSurface,
          surfaceColor: Theme.of(context).colorScheme.surface,
          isDark: Theme.of(context).brightness == Brightness.dark,
        ),
      ),
    ),
  );
}
