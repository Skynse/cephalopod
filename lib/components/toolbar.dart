import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cephalopod/screens/export_page_pdf.dart';
import 'package:cephalopod/models/theme_model.dart';

import '../models/editor_model.dart';
import 'package:cephalopod/core/file_item.dart';

class ToolBar extends StatefulWidget {
  const ToolBar({Key? key}) : super(key: key);

  @override
  _ToolBarState createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  bool themeValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: SizedBox(
              width: 30,
              child: TextField(
                style: TextStyle(color: Color.fromARGB(255, 142, 142, 142)),
                cursorColor: Color.fromARGB(255, 228, 29, 129),
                onSubmitted: (value) {
                  setState(
                    () {
                      nameController.text = value;
                      var oldPath =
                          Provider.of<EditorModel>(context, listen: false)
                              .activeFile;
                      var oldName = oldPath.split("/").last;

                      var newpath = FileItem(
                        oldName,
                        oldPath,
                      )..rename(value);
                      Provider.of<EditorModel>(context, listen: false)
                          .setActiveFilename(newpath.path);
                    },
                  );
                },
                controller: nameController
                  ..text = Provider.of<EditorModel>(context, listen: true)
                      .splittedName,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(),
                  border: InputBorder.none,
                  hintText: nameController.text,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ExportPdfPopup();
                  });
            },
          ),
          Switch.adaptive(
              activeTrackColor: Color.fromARGB(255, 35, 210, 102),
              inactiveTrackColor: Color.fromARGB(255, 210, 35, 105),
              inactiveThumbColor: Colors.transparent,
              activeColor: Provider.of<ThemeModel>(context, listen: true)
                  .themeData
                  .primary,
              trackColor: MaterialStateProperty.all(
                  Provider.of<ThemeModel>(context, listen: true)
                      .themeData
                      .tertiary),
              value: themeValue,
              onChanged: (value) {
                setState(() {
                  themeValue = value;
                  Provider.of<ThemeModel>(context, listen: false)
                      .setGlobalTheme(themeValue);
                });
              }),
        ],
      ),
    );
  }
}
