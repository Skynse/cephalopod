import 'package:cephalopod/core/summarize.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:cephalopod/models/editor_model.dart';

import 'package:cephalopod/models/preview_model.dart';
import 'package:cephalopod/core/fuzzy_match.dart';
import 'package:cephalopod/core/file_item.dart';

class FileView extends StatefulWidget {
  const FileView({Key? key}) : super(key: key);
  @override
  _FileViewState createState() => _FileViewState();
}

class _FileViewState extends State<FileView> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
  }

  String filter = "";
  bool themeValue = false;

  List<String> summaries = [];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SizedBox(
        width: 200,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setState(() {
                          createNewFile();
                        })),
              ],
            ),
            // search bar
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(10),
                hintText: 'Search',
                border: InputBorder.none,
              ),
              onChanged: (text) {
                setState(() {
                  filter = text;
                });
              },
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
                            // open options dialog with rename, delete, export
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Options'),
                                    content: Column(
                                      children: [
                                        Text('Rename'),
                                        Text('Delete'),
                                        Text('Export'),
                                      ],
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Row(children: [
                            Expanded(
                              child: ListTile(
                                title: Text(snapshot.data[index].name),
                                subtitle: Text(
                                  summarize(snapshot.data[index].getFileText()),
                                ),
                                onTap: () {
                                  setState(() {
                                    Provider.of<EditorModel>(context,
                                        listen: false)
                                      ..fileItem = snapshot.data[index]
                                      ..position = 0
                                      ..setActiveFilename(
                                          snapshot.data[index].path)
                                      ..setPopulated(true)
                                      ..text =
                                          snapshot.data[index].getFileText();
                                    Provider.of<PreviewModel>(context,
                                            listen: false)
                                        .updatePreview(
                                            snapshot.data[index].getFileText());
                                  });
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(
                                  () {
                                    snapshot.data[index].delete(context);
                                  },
                                );
                              },
                              icon: const Icon(Icons.delete),
                            )
                          ]),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
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
      String filename = Platform.isLinux
          ? entity.path.split("/").last
          : entity.path.split("\\").last;
      if (entity is File) {
        if (match(filename, filter.toLowerCase()) && filter != "") {
          files.add(FileItem(
            filename,
            entity.path,
          ));
          summaries.add(summarize(entity.readAsStringSync()));
        } else if (filter == "") {
          files.add(FileItem(
            filename,
            entity.path,
          ));
          summaries.add(summarize(entity.readAsStringSync()));
        }
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
