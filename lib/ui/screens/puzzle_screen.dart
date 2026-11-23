import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/imigongo_palette.dart';
import '../../l10n/app_localizations.dart';
import '../../models/puzzle_enums.dart';
import '../providers/puzzle_provider.dart';
import '../widgets/puzzle_board_widget.dart';

class PuzzleScreen extends ConsumerWidget {
  final int size;
  final int seed;

  const PuzzleScreen({
    super.key,
    required this.size,
    required this.seed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzleKey = (size, seed);
    final puzzleState = ref.watch(puzzleProvider(puzzleKey));
    final puzzleNotifier = ref.read(puzzleProvider(puzzleKey).notifier);

    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final board = puzzleState.board;

    return Scaffold(
      appBar: AppBar(
        title: Text('${size}x$size ${l10n?.appTitle ?? "Puzzle"}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reset Puzzle',
            onPressed: () => puzzleNotifier.reset(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Score & Par Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Moves counter
                  _buildStatCard(
                    context,
                    label: l10n?.moves ?? 'Moves',
                    value: '${board.movesTaken}',
                    isDark: isDark,
                  ),

                  // Par benchmark (ADR 001)
                  _buildStatCard(
                    context,
                    label: l10n?.par ?? 'Par',
                    value: '${board.par}',
                    isDark: isDark,
                    highlight: true,
                  ),

                  // Star rating preview
                  _buildStarsDisplay(puzzleState.stars),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Main Puzzle Board
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: PuzzleBoardWidget(
                  board: board,
                  isDark: isDark,
                  onRotateTile: (r, c) => puzzleNotifier.rotateTile(r, c),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Victory Banner if won
            if (puzzleState.hasWon) ...[
              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: isDark ? ImigongoPalette.tileSurface : ImigongoPalette.parchment,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ImigongoPalette.ochre, width: 2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle, color: ImigongoPalette.ochre),
                        const SizedBox(width: 8),
                        Text(
                          l10n?.solved.toUpperCase() ?? 'SOLVED!',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: ImigongoPalette.ochre,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n?.starsEarned(puzzleState.stars.count) ?? '${puzzleState.stars.count} Stars',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? ImigongoPalette.chalk : ImigongoPalette.charcoal,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () => context.pop(),
                          child: const Text('Menu'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ImigongoPalette.ochre,
                            foregroundColor: ImigongoPalette.charcoal,
                          ),
                          onPressed: () {
                            final nextSeed = DateTime.now().millisecondsSinceEpoch % 1000000;
                            context.pushReplacement('/puzzle?size=$size&seed=$nextSeed');
                          },
                          child: const Text('Next Puzzle'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  l10n?.rotateInstruction ?? 'Tap a tile to rotate clockwise',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? ImigongoPalette.parchment : ImigongoPalette.charcoal,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String label,
    required String value,
    required bool isDark,
    bool highlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? ImigongoPalette.tileSurface : ImigongoPalette.parchment,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: highlight ? ImigongoPalette.ochre : ImigongoPalette.starInactive,
          width: highlight ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: highlight
                  ? ImigongoPalette.ochre
                  : (isDark ? ImigongoPalette.parchment : ImigongoPalette.charcoal),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? ImigongoPalette.chalk : ImigongoPalette.charcoal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarsDisplay(StarRating stars) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final isActive = index < stars.count;
        return Icon(
          isActive ? Icons.star_rounded : Icons.star_border_rounded,
          color: isActive ? ImigongoPalette.starGold : ImigongoPalette.starInactive,
          size: 26,
        );
      }),
    );
  }
}

