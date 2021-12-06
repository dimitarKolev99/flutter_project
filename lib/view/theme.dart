import 'package:flutter/material.dart';

//build with https://www.youtube.com/watch?v=G7gV89hnooM

class ThemeChanger with ChangeNotifier{
  // IDEALO Colors (default)
  static Color navBarColor = Color.fromRGBO(10, 55, 97, 1);
  static Color lightBlue = Color.fromRGBO(55, 95, 134, 1);
  static Color highlightedColor = Color.fromRGBO(255, 102, 0, 1);
  static Color textColor = Color.fromRGBO(255, 255, 255, 1);

  ThemeData _themeData;

  ThemeChanger(this._themeData);

  getTheme(){
    return _themeData;
  }

  setTheme(ThemeData theme){
    _themeData = theme;

    notifyListeners();
  }
}