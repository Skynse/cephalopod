import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cephalopod/models/editor_model.dart';
import 'package:cephalopod/models/preview_model.dart';
import 'package:cephalopod/core/summarize.dart';

class FileItem {
  String name;
  String path;

  String getFileText() {
    //check if file exists first
    if (File(path).existsSync()) {
      return File(path).readAsStringSync();
    } else {
      return ""; //workaround for files that have just been deleted but are still in the list
    }
  }

  String getSummary() {
    return summarize(getFileText());
  }

  get size => File(path).lengthSync() + 1;

  delete(BuildContext context) {
    Provider.of<EditorModel>(context, listen: false).init();
    Provider.of<PreviewModel>(context, listen: false).updatePreview("");
    File(path).deleteSync();
  }

  Future<File> save(controller) async {
    return await File(path).writeAsString(controller.text);
  }

  rename(String newName) {
    var oldName = name;
    var path_ = path.replaceAll(oldName, newName);
    //rename file in file system
    File(path).renameSync(path_);
    //update name
    name = newName;

    //update path
    path = path_;
  }

  FileItem(this.name, this.path);
}
