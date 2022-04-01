import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:cephalopod/models/editor_model.dart';

import '../models/preview_model.dart';

class FileView extends StatefulWidget {
  @override
  _FileViewState createState() => _FileViewState();
}

class _FileViewState extends State<FileView> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SizedBox(
        width: 200,
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setState(() {
                          createNewFile();
                        })),
              ],
            ),
            Expanded(
                child: FutureBuilder(
              future: scanDir(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onSecondaryTap: () {
                          // context menu popup
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Row(children: [
                                    Expanded(
                                        child: TextFormField(
                                      controller: _controller,
                                    )),
                                    IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          setState(() {
                                            snapshot.data[index]
                                                .delete(context);
                                            // clear editor if files = 0
                                            if (snapshot.data.length == 1) {
                                              Provider.of<EditorModel>(context,
                                                      listen: false)
                                                  .setPopulated(false);

                                              Provider.of<EditorModel>(context,
                                                      listen: false)
                                                  .text = "";
                                              Provider.of<PreviewModel>(context,
                                                      listen: false)
                                                  .updatePreview("");
                                            }
                                          });

                                          Navigator.pop(context);
                                        }),
                                  ]),
                                  content: Text(
                                      "size: ${snapshot.data[index].size}"),
                                  actions: [
                                    ElevatedButton(
                                      child: Text("Ok"),
                                      onPressed: () {
                                        setState(() {
                                          snapshot.data[index]
                                              .rename(_controller.text);
                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
                                    ElevatedButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        child: ListTile(
                            title: Text(snapshot.data[index].name),
                            onTap: () {
                              Provider.of<EditorModel>(context, listen: false)
                                  .setActiveFilename(snapshot.data[index].path);
                              Provider.of<EditorModel>(context, listen: false)
                                  .setPopulated(true);
                              Provider.of<EditorModel>(context, listen: false)
                                  .text = snapshot.data[index].getFileText();
                              Provider.of<PreviewModel>(context, listen: false)
                                  .updatePreview(
                                      snapshot.data[index].getFileText());
                            }),
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )),
          ],
        ),
      ),
    );
  }

  Future<List<FileItem>> scanDir() async {
    List<FileItem> files = [];
    String name = await getApplicationDocumentsDirectory().then((dir) {
      return dir.path;
    });
    Directory dir = Directory("$name/cephalopod");
    List<FileSystemEntity> entities = dir.listSync();
    for (FileSystemEntity entity in entities) {
      if (entity is File) {
        files.add(FileItem(
          entity.path.split('/').last,
          entity.path,
        ));
      }
    }
    return files;
  }
}

Future<File> createNewFile() async {
  String name = await getApplicationDocumentsDirectory().then((dir) {
    return dir.path;
  });
  Directory dir = Directory(name + "/cephalopod");
  //get number of files in dir
  int num = dir.listSync().length;
  //create new file
  File file = File("$name/cephalopod/note$num.md");
  file.createSync();
  return file;
}

// make a function to get documents path and return it as string
Future<String> getPath() {
  return getApplicationDocumentsDirectory().then((dir) {
    return dir.path;
  });
}

class FileItem {
  String name;
  final String path;

  String getFileText() {
    return File(path).readAsStringSync();
  }

  get size => File(path).lengthSync();

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
    path.replaceFirst(name, newName);

    //rename file in file system
    File(path).renameSync(path);
    //update name

    //update path
  }

  FileItem(this.name, this.path);
}
