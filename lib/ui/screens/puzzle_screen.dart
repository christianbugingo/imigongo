import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../providers/puzzle_provider.dart';
import '../widgets/puzzle_board_widget.dart';

class PuzzleScreen extends ConsumerWidget {
  final int size, seed;
  const PuzzleScreen({super.key, required this.size, required this.seed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (size, seed);
    final state = ref.watch(puzzleProvider(key));
    final controller = ref.read(puzzleProvider(key).notifier);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text('${state.size}×${state.size}')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 16,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    '${l10n.moves}: ${state.movesTaken}',
                    key: const ValueKey('move_counter'),
                  ),
                  Text(
                    state.isSolved ? l10n.solved : l10n.inProgress,
                    key: const ValueKey('puzzle_status'),
                  ),
                  OutlinedButton.icon(
                    key: const ValueKey('undo'),
                    onPressed: state.canUndo ? controller.undo : null,
                    icon: const Icon(Icons.undo),
                    label: Text(l10n.undo),
                  ),
                  OutlinedButton.icon(
                    key: const ValueKey('reset'),
                    onPressed: controller.reset,
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.reset),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PuzzleBoardWidget(
                state: state,
                isDark: Theme.of(context).brightness == Brightness.dark,
                onRotateTile: controller.rotateTile,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(l10n.rotateInstruction),
            ),
          ],
        ),
      ),
    );
  }
}
