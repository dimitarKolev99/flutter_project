import 'package:flutter/material.dart';

import '../browser_view.dart';
import '../favorites.dart';
import '../home.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatefulWidget {
  const TabNavigator({Key? key, required this.navigatorKey, required this.tabItem}) : super(key: key);
  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  @override
  Widget build(BuildContext context) {

    Widget child = HomePage();
    if(widget.tabItem == "Page1") {
      child = HomePage();
    } else if(widget.tabItem == "Page2") {
      child = BrowserPage();
    } else if(widget.tabItem == "Page3") {
      child = FavoritePage();
    }
    // TODO: add Profile Page

    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
            builder: (context) => child
        );
      },
    );
  }
}