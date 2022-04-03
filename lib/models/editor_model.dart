import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditorModel extends ChangeNotifier {
  String _text = "";
  int _textlength = 0;
  String _filename = "";
  bool populated = false;
  int _position = 0;

  String get text => _text;
  String get filename => _filename;
  int get textlength => _textlength;
  int get position => _position;

  set position(int position) {
    _position = position;
    notifyListeners();
  }

  void setActiveFilename(String name) {
    _filename = name;
    notifyListeners();
  }

  void init() {
    _filename = "";
    _text = "";
    _textlength = 0;
    notifyListeners();
  }

  Future<File> saveFile() async {
    final file = await File(_filename).create(recursive: true);
    file.writeAsString(_text);
    notifyListeners();
    return file;
  }

  void setPopulated(bool val) {
    populated = val;
    notifyListeners();
  }

  set text(String str) {
    _text = str;
    _textlength = str.length;
    notifyListeners();
  }
}
