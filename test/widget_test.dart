import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/main.dart';

void main() {
  testWidgets('Imigongo puzzle app loads foundation screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ImigongoPuzzleApp());

    // Verify app bar title
    expect(find.text('IMIGONGO PUZZLE'), findsOneWidget);

    // Verify traditional art section
    expect(find.text('Traditional Rwandan Art'), findsOneWidget);

    // Verify palette labels are displayed
    expect(find.text('Uruzi'), findsOneWidget);
    expect(find.text('Ingwa'), findsOneWidget);
    expect(find.text('Urukondo'), findsOneWidget);
    expect(find.text('Icyondo'), findsOneWidget);

    // Verify checkpoint banner is visible
    expect(
      find.text('Ready for Steps 2-3 (Engine & Tests). UI will be built after your engine checkpoint review.'),
      findsOneWidget,
    );
  });
}
