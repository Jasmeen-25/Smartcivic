
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_civic/main.dart';

void main() {
  testWidgets('Smart Civic app loads successfully',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SmartCivicApp());

    await tester.pumpAndSettle();

    expect(find.text('Smart Civic 🌱'), findsOneWidget);
    expect(find.text('Make Your City Cleaner!'), findsOneWidget);
    expect(find.text('Report Garbage'), findsOneWidget);
  });
}
