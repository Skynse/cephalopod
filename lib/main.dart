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
import 'package:cephalopod/theme/theme.dart';
import 'package:cephalopod/components/toolbar.dart';

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
      // set color scheme
      theme: ThemeData(
        colorScheme: Provider.of<ThemeModel>(context).themeData,
      ),
      home: Container(
        color: Provider.of<ThemeModel>(context, listen: false)
            .themeData
            .surfaceVariant,
        child: Column(
          children: [
            Expanded(
              child: Row(children: [
                const SideBar(),
                const FileView(),
                Divider(
                    color: Provider.of<ThemeModel>(context, listen: true)
                        .themeData
                        .primary,
                    thickness: 2,
                    endIndent: 5),

                // row for toolbar then editor and preview
                Expanded(
                  child: Column(children: [
                    const SizedBox(height: 40, child: ToolBar()),
                    Expanded(
                      child: Row(
                        children: [
                          const Expanded(
                            child: Editor(),
                          ),
                          const Expanded(
                            child: Preview(),
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
              ]),
            ),
            SizedBox(height: 20, child: StatusBar()),
          ],
        ),
      ),
    );
  }
}
