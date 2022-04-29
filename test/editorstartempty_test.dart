import 'package:flutter_test/flutter_test.dart';
import 'package:cephalopod/models/editor_model.dart';

void main() {
  testWidgets('EditorModel', (WidgetTester tester) async {
    final EditorModel model = EditorModel();
    expect(model.text, "");
    expect(model.textlength, 0);
    expect(model.filename, "");
    expect(model.populated, false);
    expect(model.position, 0);
  });
}
