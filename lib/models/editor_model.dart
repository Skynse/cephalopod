import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cephalopod/core/summarize.dart';

class EditorModel extends ChangeNotifier {
  String _text = "";
  int _textlength = 0;
  String _activeFile = "";
  bool populated = false;
  int _position = 0;
  int _namePosition = 0;

  String get text => _text;
  String get activeFile => _activeFile;
  int get textlength => _textlength;
  int get position => _position;
  int get namePosition => _namePosition;
  String get summary => summarize(_text);
  String get splittedName => Platform.isLinux
      ? _activeFile.split('/').last
      : _activeFile.split('\\').last;

  set position(int position) {
    _position = position;
    notifyListeners();
  }

  set namePosition(int position) {
    _namePosition = position;
    notifyListeners();
  }

  set summary(String summary) {
    this.summary = summary;
    notifyListeners();
  }

  void setActiveFilename(String name) {
    _activeFile = name;
    notifyListeners();
  }

  void init() {
    _activeFile = "";
    _text = "";
    _textlength = 0;
    _position = 0;
    _namePosition = 0;
    notifyListeners();
  }

  Future<File> saveFile() async {
    final file = await File(_activeFile).create(recursive: true);
    file.writeAsString(_text);
    notifyListeners();
    return file;
  }

  //rename
  void rename(String newName) {
    var oldName = _activeFile;
    var path_ = oldName.replaceAll(oldName, newName);
    //rename file in file system
    File(oldName).renameSync(path_);
    //update name
    _activeFile = path_;

    notifyListeners();
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

  get path {
    var lastsep = _activeFile.lastIndexOf('/');
    var path = _activeFile.substring(0, lastsep);
    return path;
  }
}
