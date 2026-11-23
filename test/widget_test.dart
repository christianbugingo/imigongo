import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/main.dart';

void main() {
  testWidgets('Imigongo puzzle app loads foundation screen with English palette', (WidgetTester tester) async {
    await tester.pumpWidget(const ImigongoPuzzleApp());

    // Verify app bar title
    expect(find.text('IMIGONGO PUZZLE'), findsOneWidget);

    // Verify section title
    expect(find.text('Geometric Relief Puzzle'), findsOneWidget);

    // Verify plain English color labels are displayed
    expect(find.text('Charcoal'), findsOneWidget);
    expect(find.text('Chalk'), findsOneWidget);
    expect(find.text('Terracotta'), findsOneWidget);
    expect(find.text('Ochre'), findsOneWidget);

    // Verify engine notice is visible
    expect(
      find.text('Engine & Tests in progress. UI deferred until engine checkpoint review.'),
      findsOneWidget,
    );
  });
}
