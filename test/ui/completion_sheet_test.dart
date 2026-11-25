import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/l10n/app_localizations.dart';
import 'package:imigongo_pattern_puzzle/ui/models/puzzle_view.dart';
import 'package:imigongo_pattern_puzzle/ui/widgets/completion_sheet.dart';

void main() {
  testWidgets('earned stars appear sequentially', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: CompletionSheet(
            result: CompletionView(
              attemptId: 1,
              moves: 3,
              targetMoves: 3,
              stars: 3,
              newBest: true,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    List<double> scales() => [
      for (var i = 0; i < 3; i++)
        tester
            .widget<Transform>(find.byKey(ValueKey('earned_star_$i')))
            .transform
            .storage[0],
    ];
    await tester.pump(const Duration(milliseconds: 200));
    expect(scales()[0], greaterThan(0));
    expect(scales()[1], 0);
    expect(scales()[2], 0);
    await tester.pump(const Duration(milliseconds: 350));
    expect(scales()[0], 1);
    expect(scales()[1], greaterThan(0));
    expect(scales()[2], 0);
    await tester.pumpAndSettle();
    expect(scales(), [1, 1, 1]);
    await tester.pumpWidget(const SizedBox());
  });
}
