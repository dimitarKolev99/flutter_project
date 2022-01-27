import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:penny_pincher/view/app_navigator.dart';
import 'package:penny_pincher/view/browser_view.dart';
import 'package:penny_pincher/view/theme.dart';
import 'package:provider/provider.dart';
import 'package:penny_pincher/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Always keep Portrait Orientation:
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();

  // Always keep Portrait Orientation:
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class SplashPage extends StatelessWidget {
  //const SplashPage({Key? key}) : super(key: key);

  int duration = 0;
  Widget goToPage;

  SplashPage({required this.goToPage, required this.duration});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: this.duration), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => this.goToPage));
    });
    return Scaffold(
      body: Container(
          color: ThemeChanger.lightBlue,
          alignment: Alignment.center,
          child: Icon(Icons.search, color: Colors.grey, size: 100)),
    );
  }
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppPage();
}

class _MyAppPage extends State<MyApp> {

  bool isLight = true;
  bool dataLoaded = false;

  @override
  void initState() {
    loadTheme();
  }

  loadTheme() async {
    var preferences = await SharedPreferences.getInstance();
    var light = preferences.getBool('isLight');
    if (light == null || light) {
      isLight = true;
      await preferences.setBool("isLight", true);
    } else {
      isLight = false;
    }
    setState(() {
      dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLight) {
      ThemeChanger _themeChanger = new ThemeChanger(ThemeData.light());
      _themeChanger.setlightTheme(ThemeData.light());
    } else {
      ThemeChanger _themeChanger = new ThemeChanger(ThemeData.dark());
      _themeChanger.setdarkTheme(ThemeData.dark());
    }
    if (!dataLoaded) {
      return MaterialApp();
    } else {
      return ChangeNotifierProvider<ThemeChanger>(
        // ToDo: changing the start value from light mode into the state from app closing (shared preferences)
        create: (_) => isLight ? ThemeChanger(ThemeData.light()) : ThemeChanger(ThemeData.dark()),
        child: new MaterialAppWithTheme(),
      );
    }
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
