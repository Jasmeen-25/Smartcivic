
import 'package:flutter_test/flutter_test.dart';
import 'package:smartcivic/app.dart';

void main() {
  testWidgets('SmartCivic app widget test', (WidgetTester tester) async {
    const app = SmartCivicApp();

    expect(app, isA<SmartCivicApp>());
  });
}
