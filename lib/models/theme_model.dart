import 'package:flutter/material.dart';
import 'package:cephalopod/factory/config.dart';
import 'package:cephalopod/theme/theme.dart';

class ThemeModel extends ChangeNotifier {
  ColorScheme _themeData = lightColorScheme;

  ColorScheme get themeData {
    return _themeData;
  }

  void setGlobalTheme(bool themeValue) {
    themeValue ? _themeData = darkColorScheme : _themeData = lightColorScheme;
    notifyListeners();
  }
}
