import 'package:flutter/material.dart';
import 'package:cephalopod/theme/style.dart';
import 'package:provider/provider.dart';
import 'package:cephalopod/models/preview_model.dart';

import '../models/editor_model.dart';

class Editor extends StatefulWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.text = Provider.of<EditorModel>(context).text;
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));
    bool populated = Provider.of<EditorModel>(context).populated;
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
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  toolbarOptions: const ToolbarOptions(
                    selectAll: true,
                    copy: true,
                    cut: true,
                    paste: true,
                  ),
                  onChanged: (val) {
                    setState(() {
                      Provider.of<PreviewModel>(context, listen: false)
                          .updatePreview(val);
                      Provider.of<EditorModel>(context, listen: false).text =
                          val;
                      Provider.of<EditorModel>(context, listen: false)
                          .saveFile();
                    });
                  },
                  decoration: const InputDecoration(
                    //remove line
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.multiline,
                  enableInteractiveSelection: true,
                  maxLines: 99999,
                ),
              ),
            ),
          );
  }
}
