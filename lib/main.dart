import 'package:flutter/material.dart';
import 'core/theme/imigongo_palette.dart';
import 'core/theme/imigongo_theme.dart';
import 'models/puzzle_enums.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ImigongoPuzzleApp());
}

class ImigongoPuzzleApp extends StatelessWidget {
  const ImigongoPuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Imigongo Pattern Puzzle',
      debugShowCheckedModeBanner: false,
      theme: ImigongoTheme.darkTheme,
      home: const FoundationHomeScreen(),
    );
  }
}

class FoundationHomeScreen extends StatelessWidget {
  const FoundationHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IMIGONGO PUZZLE'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            height: 4.0,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ImigongoPalette.urukondoRed,
                  ImigongoPalette.icyondoYellow,
                  ImigongoPalette.ingwaWhite,
                  ImigongoPalette.uruziBlack,
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
              // Cultural Header Card
              Container(
                padding: const EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: ImigongoPalette.tileSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: ImigongoPalette.icyondoYellow.withValues(alpha: 0.4),
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
                            color: ImigongoPalette.urukondoRed,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Traditional Rwandan Art',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ImigongoPalette.ingwaWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Imigongo originated in the 18th century Gisaka Kingdom. '
                      'Sculpted cow dung reliefs painted with natural organic '
                      'and mineral pigments create rhythmic geometric harmony.',
                      style: TextStyle(
                        color: ImigongoPalette.parchment,
                        fontSize: 13.5,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Traditional Palette Swatches
                    Row(
                      children: [
                        _buildColorPill('Uruzi (Black)', ImigongoPalette.uruziBlack, ImigongoPalette.ingwaWhite),
                        const SizedBox(width: 6),
                        _buildColorPill('Ingwa (White)', ImigongoPalette.ingwaWhite, ImigongoPalette.uruziBlack),
                        const SizedBox(width: 6),
                        _buildColorPill('Urukondo (Red)', ImigongoPalette.urukondoRed, ImigongoPalette.ingwaWhite),
                        const SizedBox(width: 6),
                        _buildColorPill('Icyondo (Ochre)', ImigongoPalette.icyondoYellow, ImigongoPalette.uruziBlack),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Step 1 Foundation Summary Card
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
                      'Phase 1 • Step 1: Foundation Status',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: ImigongoPalette.icyondoYellow,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildStatusRow(
                      icon: Icons.grid_4x4,
                      title: 'Supported Grids',
                      value: GridDimension.values.map((d) => '${d.size}x${d.size}').join(', '),
                    ),
                    const Divider(color: ImigongoPalette.starInactive, height: 20),
                    _buildStatusRow(
                      icon: Icons.star_half,
                      title: 'Move Targets',
                      value: 'Par-based (ADR 001: 50ms solver time-box)',
                    ),
                    const Divider(color: ImigongoPalette.starInactive, height: 20),
                    _buildStatusRow(
                      icon: Icons.notifications_active_outlined,
                      title: 'Reminders',
                      value: 'Local notifications (ADR 002: Offline first)',
                    ),
                    const Divider(color: ImigongoPalette.starInactive, height: 20),
                    _buildStatusRow(
                      icon: Icons.speed,
                      title: 'Android Target',
                      value: '60 fps @ ≤16.6ms • Cold start ≤1.8s • APK ≤15MB',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Checkpoint notice
              Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: ImigongoPalette.uruziBlack,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ImigongoPalette.urukondoRed.withValues(alpha: 0.6)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: ImigongoPalette.urukondoRed, size: 22),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Ready for Steps 2-3 (Engine & Tests). UI will be built after your engine checkpoint review.',
                        style: TextStyle(
                          color: ImigongoPalette.ingwaWhite,
                          fontSize: 13,
                        ),
                      ),
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
          name.split(' ').first,
          style: TextStyle(
            color: textColor,
            fontSize: 10.5,
            fontWeight: FontWeight.bold,
          ),
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
        Icon(icon, size: 18, color: ImigongoPalette.icyondoYellow),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: ImigongoPalette.ingwaWhite,
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
