import 'package:flutter/material.dart';

class PreviewModel extends ChangeNotifier {
  String previewText = "";
  int textlength = 0;

  void updatePreview(String str) {
    previewText = str;
    textlength = str.length;
    notifyListeners();
  }
}
