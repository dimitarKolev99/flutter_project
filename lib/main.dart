import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:penny_pincher/view/app_navigator.dart';
import 'package:penny_pincher/view/theme.dart';
import 'package:provider/provider.dart';


void main() {
  // Always keep Portrait Orientation:
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      // ToDo: changing the start value from light mode into the state from app closing (shared preferences)
      create: (_) => ThemeChanger(ThemeData.light()),
    child: new MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      home: const AppNavigator(),
      theme: theme.getTheme(),
      );
  }
}



