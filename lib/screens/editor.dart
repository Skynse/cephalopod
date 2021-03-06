import 'package:flutter/material.dart';
import 'package:cephalopod/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:cephalopod/models/preview_model.dart';
import 'package:cephalopod/models/theme_model.dart';

import '../models/editor_model.dart';

class Editor extends StatefulWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _controller.text = Provider.of<EditorModel>(context, listen: false).text;
    _controller.selection = TextSelection.fromPosition(TextPosition(
        offset: Provider.of<EditorModel>(context, listen: false).position));

    bool populated = Provider.of<EditorModel>(context, listen: true).populated;
    return !populated
        ? const Scaffold(
            body: Center(
            child: Text(
              "Nothing here\nTry creating a new file",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30, color: Color.fromARGB(255, 160, 160, 160)),
            ),
          ))
        : Scaffold(
            body: Container(
              color: Provider.of<ThemeModel>(context, listen: true)
                  .themeData
                  .primary,
              child: TextField(
                cursorColor: Color.fromARGB(255, 198, 33, 80),
                controller: _controller,
                toolbarOptions: const ToolbarOptions(
                  selectAll: true,
                  copy: true,
                  cut: true,
                  paste: true,
                ),
                onChanged: (val) {
                  Provider.of<EditorModel>(context, listen: false).position =
                      _controller.selection.baseOffset;
                  Provider.of<PreviewModel>(context, listen: false)
                      .updatePreview(val);

                  Provider.of<EditorModel>(context, listen: false).text = val;

                  Provider.of<EditorModel>(context, listen: false).saveFile();
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  //remove line
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.multiline,
                enableInteractiveSelection: true,
                maxLines: 99999,
              ),
            ),
          );
  }
}
