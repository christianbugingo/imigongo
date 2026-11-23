import 'package:flutter/material.dart';
import 'core/config/app_flavor.dart';
import 'core/theme/imigongo_palette.dart';
import 'core/theme/imigongo_theme.dart';
import 'l10n/app_localizations.dart';

void runImigongoApp() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ImigongoPuzzleApp());
}

void main() {
  AppConfig.initialize(AppFlavor.prod);
  runImigongoApp();
}

class ImigongoPuzzleApp extends StatelessWidget {
  const ImigongoPuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.flavor.appTitle,
      debugShowCheckedModeBanner: AppConfig.flavor.isDev,
      theme: ImigongoTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const FoundationHomeScreen(),
    );
  }
}

class FoundationHomeScreen extends StatelessWidget {
  const FoundationHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDev = AppConfig.flavor.isDev;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n?.appTitle ?? 'IMIGONGO PUZZLE'),
            if (isDev) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: ImigongoPalette.terracotta,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'DEV',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            height: 4.0,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ImigongoPalette.terracotta,
                  ImigongoPalette.ochre,
                  ImigongoPalette.chalk,
                  ImigongoPalette.charcoal,
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: ImigongoPalette.tileSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: ImigongoPalette.ochre.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 28,
                          decoration: BoxDecoration(
                            color: ImigongoPalette.terracotta,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n?.geometricReliefPuzzle ?? 'Geometric Relief Puzzle',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ImigongoPalette.chalk,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n?.rotateInstruction ?? 'Tap a tile to rotate clockwise',
                      style: const TextStyle(
                        color: ImigongoPalette.parchment,
                        fontSize: 13.5,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Palette Swatches (using localized strings)
                    Row(
                      children: [
                        _buildColorPill(
                          l10n?.colorCharcoal ?? 'Charcoal',
                          ImigongoPalette.charcoal,
                          ImigongoPalette.chalk,
                        ),
                        const SizedBox(width: 6),
                        _buildColorPill(
                          l10n?.colorChalk ?? 'Chalk',
                          ImigongoPalette.chalk,
                          ImigongoPalette.charcoal,
                        ),
                        const SizedBox(width: 6),
                        _buildColorPill(
                          l10n?.colorTerracotta ?? 'Terracotta',
                          ImigongoPalette.terracotta,
                          ImigongoPalette.chalk,
                        ),
                        const SizedBox(width: 6),
                        _buildColorPill(
                          l10n?.colorOchre ?? 'Ochre',
                          ImigongoPalette.ochre,
                          ImigongoPalette.charcoal,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Foundation Summary Card
              Container(
                padding: const EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: ImigongoPalette.canvasSlate,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: ImigongoPalette.starInactive),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Step 1b: Flavors & Localization Skeleton',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: ImigongoPalette.ochre,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildStatusRow(
                      icon: Icons.layers_outlined,
                      title: 'Current Flavor',
                      value: '${AppConfig.flavor.name.toUpperCase()} (Package suffix: ${AppConfig.flavor.applicationIdSuffix.isEmpty ? "none (prod)" : AppConfig.flavor.applicationIdSuffix})',
                    ),
                    const Divider(color: ImigongoPalette.starInactive, height: 20),
                    _buildStatusRow(
                      icon: Icons.language,
                      title: 'Supported Locales',
                      value: '${AppLocalizations.supportedLocales.map((l) => l.languageCode).join(', ')} (English, French, Kinyarwanda)',
                    ),
                    const Divider(color: ImigongoPalette.starInactive, height: 20),
                    _buildStatusRow(
                      icon: Icons.grid_4x4,
                      title: 'Engine Status',
                      value: 'Core engine + 40 unit tests passing (Steps 2-3 verified)',
                    ),
                    const Divider(color: ImigongoPalette.starInactive, height: 20),
                    _buildStatusRow(
                      icon: Icons.star_half,
                      title: 'Par Target Term',
                      value: '${l10n?.par ?? "Par"} / ${l10n?.targetMoves ?? "Target Moves"}',
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

  static Widget _buildColorPill(String name, Color color, Color textColor) {
    return Expanded(
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white24, width: 0.8),
        ),
        alignment: Alignment.center,
        child: Text(
          name,
          style: TextStyle(
            color: textColor,
            fontSize: 10.5,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  static Widget _buildStatusRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: ImigongoPalette.ochre),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: ImigongoPalette.chalk,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: ImigongoPalette.parchment,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
