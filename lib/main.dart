import 'package:cephalopod/components/statusbar.dart';
import 'package:cephalopod/models/editor_model.dart';
import 'package:cephalopod/models/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:cephalopod/screens/editor.dart';
import 'package:cephalopod/screens/sidebar.dart';
import 'package:cephalopod/screens/preview.dart';
import 'package:provider/provider.dart';
import 'package:cephalopod/models/preview_model.dart';
import 'package:cephalopod/screens/fileview.dart';
import 'package:cephalopod/factory/initialize.dart';
import 'package:cephalopod/factory/config.dart';

void main() {
  initDir();
  initConfig();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => PreviewModel(),
    ),
    ChangeNotifierProvider(
      create: (context) => EditorModel(),
    ),
    ChangeNotifierProvider(
      create: (context) => ThemeModel(),
    ),
  ], child: const App()));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //darkTheme: Provider.of<ThemeModel>(context).themeData,
      debugShowCheckedModeBanner: false,
      title: 'Cephalopod',
      theme: ThemeData(
        backgroundColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: Column(
        children: [
          Expanded(
            child: Row(children: [
              SideBar(),
              const Divider(color: Colors.white, thickness: 2, endIndent: 5),
              FileView(),
              const Divider(color: Colors.white, thickness: 2, endIndent: 5),
              const Expanded(
                child: Editor(),
              ),
              const Expanded(
                child: Preview(),
              )
            ]),
          ),
          SizedBox(height: 20, child: StatusBar()),
        ],
      ),
    );
  }
}

class Footer extends StatefulWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      color: Colors.blue,
    );
  }
}
