import 'package:flutter/material.dart';
import 'package:cephalopod/factory/config.dart';

class ThemeModel extends ChangeNotifier {
  ThemeData _themeData = ThemeData.light();

  ThemeData get themeData {
    return _themeData;
  }

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    openConfig().then((value) {
      writeProperty(value, 'darkTheme',
          _themeData == ThemeData.dark() ? 'true' : 'false');
    });

    notifyListeners();
  }
}
