import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../models/puzzle_view.dart';

enum ResultAction { next, replay, home }

class CompletionSheet extends StatefulWidget {
  final CompletionView result;
  final int? lesson;
  final bool hasNext;
  const CompletionSheet({
    super.key,
    required this.result,
    this.lesson,
    this.hasNext = true,
  });
  @override
  State<CompletionSheet> createState() => _CompletionSheetState();
}

class _CompletionSheetState extends State<CompletionSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _stars = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  bool _started = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _stars.value = 1;
    } else if (!_started) {
      _stars.forward();
    }
    _started = true;
  }

  @override
  void dispose() {
    _stars.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final result = widget.result;
    return PopScope(
      canPop: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.lesson == null ? l10n.levelComplete : l10n.lessonComplete,
              key: const ValueKey('result_title'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (widget.lesson == null || widget.lesson == 2) ...[
              const SizedBox(height: 16),
              Semantics(
                label: l10n.starsEarned(result.stars),
                child: ExcludeSemantics(
                  child: AnimatedBuilder(
                    animation: _stars,
                    builder: (context, _) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < 3; i++)
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Transform.scale(
                              key: ValueKey('earned_star_$i'),
                              scale: i < result.stars
                                  ? ((_stars.value * 3 - i).clamp(0.0, 1.0))
                                  : 1,
                              child: Icon(
                                i < result.stars
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                size: 40,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(l10n.movesValue(result.moves), textAlign: TextAlign.center),
            Text(
              l10n.targetValue(result.targetMoves),
              textAlign: TextAlign.center,
            ),
            if (result.bonusAwarded > 0)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  l10n.bonusReward(result.bonusAwarded),
                  textAlign: TextAlign.center,
                ),
              ),
            if (result.newBest)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  l10n.newBest,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              widget.lesson == null
                  ? l10n.sessionBestNote
                  : l10n.tutorialNotice,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (widget.hasNext)
              FilledButton(
                key: const ValueKey('result_next'),
                onPressed: () => Navigator.pop(context, ResultAction.next),
                child: Text(
                  widget.lesson == null
                      ? l10n.nextPuzzle
                      : widget.lesson == 2
                      ? l10n.finishTutorial
                      : l10n.nextLesson,
                ),
              ),
            const SizedBox(height: 8),
            OutlinedButton(
              key: const ValueKey('result_replay'),
              onPressed: () => Navigator.pop(context, ResultAction.replay),
              child: Text(l10n.replay),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, ResultAction.home),
              child: Text(l10n.home),
            ),
          ],
        ),
      ),
    );
  }
}
