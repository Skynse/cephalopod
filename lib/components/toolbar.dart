import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cephalopod/screens/export_page_pdf.dart';
import 'package:cephalopod/theme/theme.dart';
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
    nameController.text =
        Provider.of<EditorModel>(context, listen: false).splitted_name;

    nameController.addListener(() {
      Provider.of<EditorModel>(context, listen: false)
          .setActiveFilename(nameController.text);
    });
  }

  bool themeValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 10, bottom: 10),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextFormField(
                  cursorColor: Color.fromARGB(255, 228, 29, 129),
                  onEditingComplete: () {
                    setState(() {
                      Provider.of<EditorModel>(context, listen: false)
                          .setActiveFilename(nameController.text);

                      FileItem(
                              nameController.text,
                              Provider.of<EditorModel>(context, listen: false)
                                  .filename)
                          .rename(nameController.text);
                    });
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: nameController.text,
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
                  activeThumbImage: const AssetImage('assets/thumbs/moon.png'),
                  inactiveThumbImage: const AssetImage('assets/thumbs/sun.png'),
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
        ),
      ),
    );
  }
}
