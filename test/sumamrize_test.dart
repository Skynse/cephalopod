import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:cephalopod/core/summarize.dart';

void main() {
  testWidgets('Test Summarization functions', (WidgetTester tester) async {
    String test_string = "This is a test string.";
    expect(summarize(test_string), "This is a test string.");
  });
}
