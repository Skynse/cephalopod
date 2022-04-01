import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cephalopod/models/editor_model.dart';

class StatusBar extends StatefulWidget {
  @override
  _StatusBarState createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.bottomRight,
      child: Row(
        children: [
          Text(
            "char count: ${Provider.of<EditorModel>(context).textlength}",
            style: const TextStyle(color: Color.fromARGB(255, 53, 53, 53)),
          ),
          Text(" filename: ${Provider.of<EditorModel>(context).filename}",
              style: const TextStyle(color: Color.fromARGB(255, 53, 53, 53))),
        ],
      ),
    ));
  }
}
