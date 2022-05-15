import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cephalopod/models/editor_model.dart';

class StatusBar extends StatefulWidget {
  const StatusBar({Key? key}) : super(key: key);
  @override
  _StatusBarState createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> {
  @override
  void dispose() {
    super.dispose();
    Provider.of<EditorModel>(context, listen: false).dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "char count: ${Provider.of<EditorModel>(context, listen: true).textlength}",
            style: const TextStyle(color: Color.fromARGB(255, 216, 14, 74)),
          ),
          Text(
              " filename: ${Provider.of<EditorModel>(context, listen: false).splittedName}",
              style: const TextStyle(color: Color.fromARGB(255, 216, 9, 81))),
        ],
      ),
    ));
  }
}
