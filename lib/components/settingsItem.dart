import 'package:flutter/material.dart';
import 'package:cephalopod/factory/config.dart';
import 'package:provider/provider.dart';

import '../models/theme_model.dart';

class SettingsSwitch extends StatefulWidget {
  const SettingsSwitch({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<SettingsSwitch> createState() => _SettingsSwitchState();
}

class _SettingsSwitchState extends State<SettingsSwitch> {
  @override
  Widget build(BuildContext context) {
    // When the user clicks on the switch, toggle the
    // dark theme. If darkTheme is false, set it to true.
    //get value of darkTheme in config

    var provider = Provider.of<ThemeModel>(context, listen: false);
    var v = false;
    return FutureBuilder(
      future: openConfig(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
              height: 20,
              child: Row(children: [
                Expanded(child: Text(widget.title)),
                Expanded(
                  child: Switch(
                    value: v,
                    onChanged: (bool value) {
                      v = value;
                      setState(() {
                        provider.themeData =
                            value ? ThemeData.dark() : ThemeData.light();
                      });
                    },
                  ),
                ),
              ]));
        } else {
          return Container();
        }
      },
    );
  }
}
