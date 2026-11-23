import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/puzzle_screen.dart';
import '../screens/settings_screen.dart';

/// Application routing table using go_router.
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/puzzle',
      builder: (context, state) {
        final size = int.tryParse(state.uri.queryParameters['size'] ?? '') ?? 4;
        final seed = int.tryParse(state.uri.queryParameters['seed'] ?? '') ?? 42;
        return PuzzleScreen(size: size, seed: seed);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

