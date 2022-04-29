import 'package:flutter/material.dart';

class ExportPage extends StatefulWidget {
  ExportPage({Key? key}) : super(key: key);

  _ExportPageState createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  Widget buttonSection = Container(
    padding: EdgeInsets.only(top: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text('Export as PDF'),
        ),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Export PDF"),
        foregroundColor: Colors.white,
      ),
      body: Container(
        child: Column(
          children: [
            buttonSection,
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
      ),
    );
  }
}

class ExportPdfPopup extends AlertDialog {
  ExportPage pdf = new ExportPage();
  ExportPdfPopup({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return AlertDialog(
      content: pdf,
    );
  }
}
