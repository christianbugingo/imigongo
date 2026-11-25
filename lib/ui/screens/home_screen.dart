import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_flavor.dart';
import '../../core/theme/imigongo_palette.dart';
import '../../l10n/app_localizations.dart';
import '../../models/puzzle_enums.dart';
import 'how_to_play_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  GridDimension _selectedDimension = GridDimension.fourByFour;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDev = AppConfig.flavor.isDev;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: l10n.howToPlay,
            icon: const Icon(Icons.help_outline),
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute(builder: (_) => const HowToPlayScreen()),
            ),
          ),
        ],
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.appTitle),
            if (isDev) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: ImigongoPalette.terracotta,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  l10n.developmentBadge,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cultural Header Card
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: isDark
                      ? ImigongoPalette.tileSurface
                      : ImigongoPalette.parchment,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: ImigongoPalette.ochre.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.geometricReliefPuzzle,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? ImigongoPalette.chalk
                            : ImigongoPalette.charcoal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.rotateInstruction,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? ImigongoPalette.parchment
                            : ImigongoPalette.charcoal,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Grid Size Selector
              Text(
                l10n.chooseSize,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? ImigongoPalette.chalk
                      : ImigongoPalette.charcoal,
                ),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: GridDimension.values.map((dim) {
                  final isSelected = dim == _selectedDimension;
                  return ChoiceChip(
                    label: Text(
                      l10n.gridSize(dim.size),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? ImigongoPalette.charcoal
                            : (isDark
                                  ? ImigongoPalette.chalk
                                  : ImigongoPalette.charcoal),
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: ImigongoPalette.ochre,
                    backgroundColor: isDark
                        ? ImigongoPalette.canvasSlate
                        : Colors.white,
                    side: BorderSide(
                      color: isSelected
                          ? ImigongoPalette.ochre
                          : ImigongoPalette.starInactive,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedDimension = dim);
                      }
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 36),

              // Play Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ImigongoPalette.ochre,
                  foregroundColor: ImigongoPalette.charcoal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  final seed = DateTime.now().millisecondsSinceEpoch % 1000000;
                  context.push(
                    '/puzzle?size=${_selectedDimension.size}&seed=$seed',
                  );
                },
                child: Text(
                  l10n.play.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
