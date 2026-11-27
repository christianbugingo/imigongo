import 'core/localization/app_localization_delegates.dart';

import 'dart:async';

import 'core/services/game_settings.dart';
import 'core/services/game_effects.dart';
import 'core/storage/progress_database.dart';
import 'ui/providers/settings_provider.dart';
import 'ui/providers/effects_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_flavor.dart';
import 'core/theme/imigongo_theme.dart';
import 'l10n/app_localizations.dart';
import 'ui/providers/locale_provider.dart';
import 'ui/providers/theme_provider.dart';
import 'ui/routing/app_router.dart';

void runImigongoApp() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _Startup());
}

void main() {
  AppConfig.initialize(AppFlavor.prod);
  runImigongoApp();
}

class ImigongoPuzzleApp extends ConsumerWidget {
  const ImigongoPuzzleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final userLocale = ref.watch(localeProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: AppConfig.flavor.isDev,
      theme: ImigongoTheme.lightTheme,
      darkTheme: ImigongoTheme.darkTheme,
      themeMode: themeMode,
      locale: userLocale,
      localizationsDelegates: appLocalizationDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        if (!MediaQuery.disableAnimationsOf(context) &&
            !ref.watch(settingsProvider).reduceMotion) {
          return child!;
        }
        return Theme(
          data: Theme.of(context).copyWith(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: _InstantTransition(),
                TargetPlatform.iOS: _InstantTransition(),
                TargetPlatform.macOS: _InstantTransition(),
                TargetPlatform.linux: _InstantTransition(),
                TargetPlatform.windows: _InstantTransition(),
                TargetPlatform.fuchsia: _InstantTransition(),
              },
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: child!,
          ),
        );
      },
      routerConfig: appRouter,
    );
  }
}

class _InstantTransition extends PageTransitionsBuilder {
  const _InstantTransition();
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => child;
}

class _Startup extends StatefulWidget {
  const _Startup();
  @override
  State<_Startup> createState() => _StartupState();
}

class _StartupState extends State<_Startup> with WidgetsBindingObserver {
  final _database = ProgressDatabase();
  final _store = LocalSettingsStore();
  final _output = PlayerSoundOutput();
  late Future<(GameSettings, ProgressSnapshot)> _load = _read();
  Future<(GameSettings, ProgressSnapshot)> _read() async {
    final settings = await _store.load();
    return (settings, await _database.load());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) unawaited(_stop());
  }

  Future<void> _stop() async {
    try {
      await _output.stop();
    } catch (_) {
      /* optional audio */
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_output.dispose());
    unawaited(_database.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<(GameSettings, ProgressSnapshot)>(
        future: _load,
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data == null) {
            return MaterialApp(
              localizationsDelegates: appLocalizationDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(
                body: Center(
                  child: Builder(
                    builder: (context) => snapshot.hasError
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.localStorageError,
                              ),
                              TextButton(
                                onPressed: () =>
                                    setState(() => _load = _read()),
                                child: Text(
                                  AppLocalizations.of(context)!.retrySave,
                                ),
                              ),
                            ],
                          )
                        : const CircularProgressIndicator(),
                  ),
                ),
              ),
            );
          }
          return ProviderScope(
            overrides: [
              initialSettingsProvider.overrideWithValue(data.$1),
              settingsStoreProvider.overrideWithValue(_store),
              progressDatabaseProvider.overrideWithValue(_database),
              progressSnapshotProvider.overrideWith((ref) => data.$2),
              gameEffectsProvider.overrideWith(
                (ref) => GameEffects(_output, () => ref.read(settingsProvider)),
              ),
            ],
            child: const ImigongoPuzzleApp(),
          );
        },
      );
}
