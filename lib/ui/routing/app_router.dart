import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/puzzle_provider.dart';
import '../screens/free_play_screen.dart';
import '../screens/pattern_selection_screen.dart';

import '../screens/welcome_screen.dart';
import '../screens/puzzle_screen.dart';

/// Application routing table using go_router.
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LaunchGate()),
    GoRoute(path: '/free-play', builder: (_, _) => const FreePlayScreen()),
    GoRoute(
      path: '/patterns/:tier',
      builder: (_, state) => PatternSelectionScreen(
        tier:
            const [
              'easy',
              'medium',
              'hard',
            ].contains(state.pathParameters['tier'])
            ? state.pathParameters['tier']!
            : 'easy',
      ),
    ),
    GoRoute(
      path: '/preview/:id',
      builder: (_, state) =>
          PatternPreviewScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/challenge/:id',
      builder: (_, state) => Consumer(
        builder: (context, ref, _) {
          final id = state.pathParameters['id']!;
          final pattern = ref.watch(patternViewProvider(id));
          return pattern == null
              ? PatternPreviewScreen(id: id)
              : PuzzleScreen(
                  key: ValueKey('challenge_$id'),
                  size: pattern.size,
                  seed: 0,
                  challengeId: id,
                );
        },
      ),
    ),
    GoRoute(
      path: '/tutorial/:lesson',
      builder: (context, state) {
        final requested =
            int.tryParse(state.pathParameters['lesson'] ?? '') ?? 0;
        final lesson = requested.clamp(0, 2);
        return PuzzleScreen(
          key: ValueKey('tutorial_$lesson'),
          size: 3,
          seed: -lesson - 1,
          lesson: lesson,
        );
      },
    ),
    GoRoute(
      path: '/puzzle',
      builder: (context, state) {
        final requested = int.tryParse(state.uri.queryParameters['size'] ?? '');
        final size = requested != null && requested >= 3 && requested <= 7
            ? requested
            : 4;
        final seed =
            int.tryParse(state.uri.queryParameters['seed'] ?? '') ?? 42;
        return PuzzleScreen(
          key: ValueKey((size, seed)),
          size: size,
          seed: seed < 0 ? 42 : seed,
        );
      },
    ),
  ],
);
