import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cephalopod/models/editor_model.dart';
import 'package:cephalopod/models/preview_model.dart';

class FileItem {
  String name;
  final String path;

  String getFileText() {
    return File(path).readAsStringSync();
  }

  get size => File(path).lengthSync() + 1;

  void delete(BuildContext context) {
    File(path).deleteSync();
    Provider.of<EditorModel>(context, listen: false).init();

    Provider.of<PreviewModel>(context, listen: false).updatePreview("");
  }

  Future<File> save(controller) async {
    return await File(path).writeAsString(controller.text);
  }

  rename(String newName) {
    //rename file
    name = newName;
    var oldName =
        Platform.isLinux ? path.split('/').last : path.split('\\').last;
    var path_ = path.replaceAll(oldName, newName);
    //rename file in file system
    File(path).renameSync(path_);
    //update name

    //update path
  }

  FileItem(this.name, this.path);
}
