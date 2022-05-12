import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:cephalopod/models/preview_model.dart';
import 'package:cephalopod/theme/theme.dart';

import '../models/theme_model.dart';

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
    Provider.of<ThemeModel>(context, listen: false).dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Provider.of<ThemeModel>(context, listen: true).themeData.primary,
        child: Markdown(
          controller: ScrollController(),
          data: Provider.of<PreviewModel>(context).previewText,
        ));
  }
}
