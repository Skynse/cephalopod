import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:cephalopod/models/editor_model.dart';

import 'package:cephalopod/models/preview_model.dart';
import 'package:cephalopod/logic/export_pdf.dart';
import 'package:cephalopod/screens/export_page_pdf.dart';
import 'package:cephalopod/core/fuzzy_match.dart';
import 'package:flutter/foundation.dart';

import '../models/theme_model.dart';
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
                                    FlatButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                          // context menu popup
                          /* showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Row(children: [
                                    Expanded(
                                        child: TextFormField(
                                      controller: _nameController,
                                    )),
                                    IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          setState(() {
                                            snapshot.data[index]
                                                .delete(context);
                                            Provider.of<EditorModel>(context,
                                                    listen: false)
                                                .setPopulated(false);
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
                                      child: const Text("Ok"),
                                      onPressed: () {
                                        setState(() {
                                          snapshot.data[index]
                                              .rename(_nameController.text);
                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
                                    ElevatedButton(
                                      child: const Text("Cancel"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              }); */
                        },
                        child: Row(children: [
                          Expanded(
                            child: ListTile(
                              title: Text(snapshot.data[index].name),
                              onTap: () {
                                setState(() {
                                  Provider.of<EditorModel>(context,
                                          listen: false)
                                      .position = 0;
                                  Provider.of<EditorModel>(context,
                                          listen: false)
                                      .setActiveFilename(
                                          snapshot.data[index].path);
                                  Provider.of<EditorModel>(context,
                                          listen: false)
                                      .setPopulated(true);
                                  Provider.of<EditorModel>(context,
                                              listen: false)
                                          .text =
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
                              setState(() {
                                snapshot.data[index].delete(context);
                              });
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
      String filename = Platform.isLinux
          ? entity.path.split("/").last
          : entity.path.split("\\").last;
      if (entity is File) {
        if (match(filename, filter.toLowerCase()) && filter != "") {
          files.add(FileItem(
            filename,
            entity.path,
          ));
        } else if (filter == "") {
          files.add(FileItem(
            filename,
            entity.path,
          ));
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
