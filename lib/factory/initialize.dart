import 'dart:io';
import 'package:path_provider/path_provider.dart';

// if cephalopod directory doesnt exist in documents, create it
Future<String> initDir() async {
  final directory = await getApplicationDocumentsDirectory();
  final dir = Directory('${directory.path}/cephalopod');
  final Directory _dir = await dir.create(recursive: true);
  return _dir.path;
}
