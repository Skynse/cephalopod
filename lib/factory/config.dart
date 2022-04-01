import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

Future<File> openConfig() async {
  final directory = await getApplicationDocumentsDirectory();
  final dir = Directory('${directory.path}/cephalopod/.config.json');
  final File _file = File(dir.path);
  return _file;
}

void initConfig() async {
  final directory = await getApplicationDocumentsDirectory();
  final dir = Directory('${directory.path}/cephalopod/.config.json');
  // crete conrfig file in directory
  final File _file = File(dir.path);
  _file.createSync(recursive: true);

  // write config file
  // check if config file exists
  if (!_file.existsSync()) {
    // if it doesnt exist, write default config
    _file.writeAsStringSync('{"darkTheme": "true"}');
  }
}

Future<String> getProperty(dynamic file, String property) async {
  final String data = await file.readAsString();
  try {
    final jsonData = json.decode(data);
    return jsonData[property];
  } catch (e) {
    throw ("Invalid config file");
  }
}

//write property function
Future<void> writeProperty(dynamic file, String property, String value) async {
  final String data = await file.readAsString();
  final jsonData = json.decode(data);
  jsonData[property] = value;
  final String jsonString = json.encode(jsonData);
  file.writeAsStringSync(jsonString);
}
