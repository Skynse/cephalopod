import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:cephalopod/models/preview_model.dart';

class Preview extends StatefulWidget {
  const Preview({Key? key}) : super(key: key);
  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  @override
  void dispose() {
    super.dispose();
    Provider.of<PreviewModel>(context, listen: false).dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment(-1.0, -4.0),
                end: Alignment(1.0, 4.0),
                colors: [
                  Color.fromARGB(255, 230, 230, 230),
                  Color.fromARGB(255, 236, 236, 236),
                ]),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(255, 241, 241, 241),
                  offset: Offset(5.0, 5.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0),
              BoxShadow(
                  color: Color.fromARGB(255, 133, 133, 133),
                  offset: Offset(-5.0, -5.0),
                  blurRadius: 15.0,
                  spreadRadius: 1.0),
            ]),
        child: Markdown(
          controller: ScrollController(),
          data: Provider.of<PreviewModel>(context).previewText,
        ));
  }
}
