
import 'package:flutter_test/flutter_test.dart';
import 'package:smartcivic/app.dart';

void main() {
  testWidgets('SmartCivic app test', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartCivicApp());
  });
}
