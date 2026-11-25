import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../models/puzzle_view.dart';
import '../providers/onboarding_provider.dart';
import '../providers/puzzle_provider.dart';
import '../widgets/completion_sheet.dart';
import '../widgets/puzzle_board_widget.dart';
import 'how_to_play_screen.dart';

enum _PauseAction { resume, restart, help, home }

class PuzzleScreen extends ConsumerStatefulWidget {
  final int size, seed;
  final int? lesson;
  const PuzzleScreen({
    super.key,
    required this.size,
    required this.seed,
    this.lesson,
  });
  @override
  ConsumerState<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends ConsumerState<PuzzleScreen>
    with WidgetsBindingObserver {
  Timer? _resultTimer;
  bool _modalOpen = false;
  bool _finishingTutorial = false;
  (int, int) get _key => (widget.size, widget.seed);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _resultTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive &&
        mounted &&
        !_modalOpen &&
        ref.read(puzzleProvider(_key)).phase == PlayPhase.playing) {
      unawaited(_pause());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context) &&
        (_resultTimer?.isActive ?? false)) {
      _resultTimer?.cancel();
      final completion = ref.read(puzzleProvider(_key)).completion;
      if (completion != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) unawaited(_showResults(completion));
        });
      }
    }
  }

  void _completed(CompletionView result) {
    final l10n = AppLocalizations.of(context)!;
    unawaited(
      SemanticsService.sendAnnouncement(
        View.of(context),
        l10n.completionAnnouncement(result.stars),
        Directionality.of(context),
      ),
    );
    _resultTimer?.cancel();
    if (MediaQuery.disableAnimationsOf(context)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_showResults(result));
      });
    } else {
      _resultTimer = Timer(const Duration(seconds: 1), () {
        if (mounted) unawaited(_showResults(result));
      });
    }
  }

  Future<void> _finishTutorial() async {
    if (_finishingTutorial) return;
    setState(() => _finishingTutorial = true);
    final saved = await ref.read(onboardingProvider.notifier).finish();
    if (!mounted) return;
    setState(() => _finishingTutorial = false);
    if (saved) {
      context.go('/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.saveFailed)),
      );
      final completion = ref.read(puzzleProvider(_key)).completion;
      if (completion != null) {
        unawaited(_showResults(completion));
      } else {
        ref.read(puzzleProvider(_key).notifier).resume();
      }
    }
  }

  Future<void> _showResults(CompletionView result) async {
    if (!mounted ||
        _modalOpen ||
        ref.read(puzzleProvider(_key)).completion?.attemptId !=
            result.attemptId) {
      return;
    }
    final controller = ref.read(puzzleProvider(_key).notifier);
    controller.revealResults(result.attemptId);
    _modalOpen = true;
    final action = await showModalBottomSheet<ResultAction>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: false,
      sheetAnimationStyle: MediaQuery.disableAnimationsOf(context)
          ? AnimationStyle.noAnimation
          : null,
      builder: (_) => CompletionSheet(result: result, lesson: widget.lesson),
    );
    _modalOpen = false;
    if (!mounted) return;
    switch (action) {
      case ResultAction.replay:
        controller.reset();
      case ResultAction.next:
        if (widget.lesson != null) {
          if (widget.lesson == 2) {
            await _finishTutorial();
          } else {
            context.go('/tutorial/${widget.lesson! + 1}');
          }
        } else {
          context.go(
            '/puzzle?size=${widget.size}&seed=${(widget.seed + 1) & 0xFFFFFFFF}',
          );
        }
      case ResultAction.home:
        if (widget.lesson != null) {
          await _finishTutorial();
        } else {
          context.go('/');
        }
      case null:
        break;
    }
  }

  Future<void> _pause() async {
    if (_modalOpen) return;
    final controller = ref.read(puzzleProvider(_key).notifier);
    controller.pause();
    if (ref.read(puzzleProvider(_key)).phase != PlayPhase.paused) return;
    final l10n = AppLocalizations.of(context)!;
    _modalOpen = true;
    final action = await showModalBottomSheet<_PauseAction>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      sheetAnimationStyle: MediaQuery.disableAnimationsOf(context)
          ? AnimationStyle.noAnimation
          : null,
      builder: (sheetContext) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.paused, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            for (final entry in [
              (_PauseAction.resume, l10n.resume),
              (_PauseAction.restart, l10n.restart),
              (_PauseAction.help, l10n.howToPlay),
              (_PauseAction.home, l10n.home),
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(sheetContext, entry.$1),
                  child: Text(entry.$2),
                ),
              ),
          ],
        ),
      ),
    );
    _modalOpen = false;
    if (!mounted) return;
    switch (action) {
      case _PauseAction.restart:
        controller.reset();
      case _PauseAction.help:
        await Navigator.of(context).push<void>(
          MaterialPageRoute(builder: (_) => const HowToPlayScreen()),
        );
        if (mounted && (ModalRoute.of(context)?.isCurrent ?? false)) {
          await _pause();
        }
      case _PauseAction.home:
        if (widget.lesson != null) {
          await _finishTutorial();
        } else {
          context.go('/');
        }
      case _PauseAction.resume || null:
        controller.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(puzzleProvider(_key));
    final controller = ref.read(puzzleProvider(_key).notifier);
    ref.listen(puzzleProvider(_key), (previous, next) {
      if (next.completion != null &&
          previous?.completion?.attemptId != next.completion!.attemptId) {
        _completed(next.completion!);
      }
      if (next.completion == null) _resultTimer?.cancel();
    });
    final l10n = AppLocalizations.of(context)!;
    final lesson = widget.lesson;
    final reduce = MediaQuery.disableAnimationsOf(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(_pause());
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            lesson == null
                ? l10n.freePlayTitle(state.size)
                : l10n.tutorialTitle(lesson + 1),
          ),
          actions: [
            if (lesson != null)
              TextButton(
                onPressed: _finishingTutorial ? null : _finishTutorial,
                child: Text(l10n.skipTutorial),
              ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Wrap(
                  spacing: 20,
                  runSpacing: 8,
                  children: [
                    Text(
                      l10n.movesValue(state.movesTaken),
                      key: const ValueKey('move_counter'),
                    ),
                    Text(l10n.targetValue(state.targetMoves)),
                  ],
                ),
              ),
              if (lesson != null)
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      [
                        l10n.lessonOne,
                        l10n.lessonTwo,
                        l10n.lessonThree,
                      ][lesson],
                    ),
                  ),
                ),
              Expanded(
                flex: 4,
                child: Center(
                  child: RepaintBoundary(
                    child: AnimatedOpacity(
                      opacity:
                          state.phase == PlayPhase.completing ||
                              state.phase == PlayPhase.results
                          ? 0.85
                          : 1,
                      duration: reduce
                          ? Duration.zero
                          : const Duration(milliseconds: 250),
                      child: PuzzleBoardWidget(
                        state: state,
                        isDark: Theme.of(context).brightness == Brightness.dark,
                        onRotateTile: controller.rotateTile,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      key: const ValueKey('undo'),
                      onPressed: state.canUndo ? controller.undo : null,
                      icon: const Icon(Icons.undo),
                      label: Text(l10n.undo),
                    ),
                    OutlinedButton.icon(
                      key: const ValueKey('reset'),
                      onPressed: state.phase == PlayPhase.playing
                          ? controller.reset
                          : null,
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.restart),
                    ),
                    OutlinedButton.icon(
                      key: const ValueKey('pause'),
                      onPressed: state.phase == PlayPhase.playing
                          ? _pause
                          : null,
                      icon: const Icon(Icons.pause),
                      label: Text(l10n.pause),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
