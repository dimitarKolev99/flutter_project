
import 'package:flutter/material.dart';

import '../browser_view.dart';
import '../favorites.dart';
import '../home.dart';
import 'dart:async';

StreamController<bool> streamControllerHome = StreamController<bool>.broadcast();
StreamController<bool> streamControllerBrowser = StreamController<bool>.broadcast();
StreamController<bool> streamControllerFavorites = StreamController<bool>.broadcast();

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

  late int state = 0;

  @override
  Widget build(BuildContext context) {

    Widget child = HomePage(streamControllerHome.stream);
    if(widget.tabItem == "Page1") {
      child = HomePage(streamControllerHome.stream);
      streamControllerHome.add(true);
      state = 0;
    } else if(widget.tabItem == "Page2") {
      child = BrowserPage(streamControllerBrowser.stream);
      streamControllerBrowser.add(true);
      state = 1;
    } else if (widget.tabItem == "Page3") {
      child = FavoritePage(streamControllerFavorites.stream);
      streamControllerFavorites.add(true);
      state = 2;
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