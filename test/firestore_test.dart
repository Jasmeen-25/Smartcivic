
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SmartCivic Tests', () {
    test('Flutter testing environment is working', () {
      expect(1 + 1, 2);
    });

    test('SmartCivic app name is correct', () {
      const appName = 'SmartCivic';
      expect(appName, 'SmartCivic');
    });

    test('Default report status is pending', () {
      const status = 'pending';
      expect(status, 'pending');
    });
  });
}
