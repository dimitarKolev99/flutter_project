import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:penny_pincher/view/app_navigator.dart';
import 'package:penny_pincher/view/browser_view.dart';
import 'package:penny_pincher/view/theme.dart';
import 'package:provider/provider.dart';
import 'package:penny_pincher/services/notification_service.dart';

void main() {
  // Always keep Portrait Orientation:
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();

  // Always keep Portrait Orientation:
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: ThemeChanger.lightBlue,
          alignment: Alignment.center,
          child: Icon(Icons.search, color: Colors.grey, size: 100)),
    );
  }
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
      home: SplashPage(), //const AppNavigator(),
      theme: theme.getTheme(),
    );
  }
}
