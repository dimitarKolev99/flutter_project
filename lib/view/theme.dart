import 'package:flutter/material.dart';
import '../services/StorageManager.dart';

//build with https://www.youtube.com/watch?v=G7gV89hnooM

class ThemeChanger with ChangeNotifier{
  // IDEALO Colors (default)
  static Color navBarColor = Color.fromRGBO(10, 55, 97, 1);
  static Color lightBlue = Color.fromRGBO(55, 95, 134, 1);
  static Color highlightedColor = Color.fromRGBO(255, 102, 0, 1);
  static Color textColor = Color.fromRGBO(255, 255, 255, 1);
  static Color reversetextColor = Color.fromRGBO(0, 0, 0, 1);
  static Color articlecardbackground = Color.fromRGBO(255, 255, 255, 1);

  ThemeData _themeData;

  ThemeChanger(this._themeData);

  getTheme(){
    return _themeData;
  }

  // ThemeNotifier() {
  //   StorageManager.readData('themeMode').then((value) {
  //     print('value read from storage: ' + value.toString());
  //     var themeMode = value ?? 'light';
  //     if (themeMode == 'light') {
  //       _themeData = ThemeData.light();
  //     } else {
  //       print('setting dark theme');
  //       _themeData = ThemeData.dark();
  //     }
  //     notifyListeners();
  //   });
  // }

  // setTheme(ThemeData theme){
  //   _themeData = theme;
  //
  //   notifyListeners();
  // }

  setlightTheme(ThemeData theme){
    _themeData = theme;

    navBarColor = Color.fromRGBO(10, 55, 97, 1);
    lightBlue = Color.fromRGBO(55, 95, 134, 1);
    highlightedColor = Color.fromRGBO(255, 102, 0, 1);
    textColor = Color.fromRGBO(255, 255, 255, 1);
    reversetextColor = Color.fromRGBO(0, 0, 0, 1);
    articlecardbackground = Color.fromRGBO(255, 255, 255, 1);

    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }

  setdarkTheme(ThemeData theme){
    _themeData = theme;

    navBarColor = Color.fromRGBO(60, 60, 60, 1);
    lightBlue = Color.fromRGBO(120, 120, 120, 1);
    highlightedColor = Color.fromRGBO(255, 102, 0, 1);
    textColor = Color.fromRGBO(255, 255, 255, 1);
    reversetextColor = Color.fromRGBO(255, 255, 255, 1);
    articlecardbackground = Color.fromRGBO(60, 60, 60, 1);

    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }
}