import 'package:flutter/material.dart';

import '../browser_view.dart';
import '../favorites.dart';
import '../home.dart';
import '../profile.dart';
import 'dart:async';

import '../welcome_screen.dart';

int count = 0;

StreamController<bool> streamControllerHome =
    StreamController<bool>.broadcast(sync: true);
StreamController<bool> streamControllerBrowser =
    StreamController<bool>.broadcast(sync: true);
StreamController<bool> streamControllerFavorites =
    StreamController<bool>.broadcast(sync: true);
StreamController<bool> streamControllerProfile =
    StreamController<bool>.broadcast(sync: true);
StreamController<bool> updateStream =
    StreamController<bool>.broadcast(sync: true);

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatefulWidget {
  const TabNavigator(
      {Key? key,
      required this.navigatorKey,
      required this.tabItem,
      required this.callback})
      : super(key: key);
  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;
  final dynamic callback;

  @override
  State<TabNavigator> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  @override
  void initState() {
    super.initState();
    if (!updateStream.hasListener) {
      updateStream.stream.listen((update) {
        updateStreams(update);
      });
    }
  }

  void updateStreams(bool update) {
    streamControllerHome.add(true);
    streamControllerBrowser.add(true);
    streamControllerFavorites.add(true);
    streamControllerProfile.add(true);
  }

  @override
  Widget build(BuildContext context) {
    Widget child = WelcomePage();
    /*Widget child =
    HomePage(streamControllerHome.stream, updateStream, widget.callback);
    if (widget.tabItem == "Page1") {
      child =
          HomePage(streamControllerHome.stream, updateStream, widget.callback);
    } else if (widget.tabItem == "Page2") {
      child = BrowserPage(streamControllerBrowser.stream, updateStream);
    } else if (widget.tabItem == "Page3") {
      child = FavoritePage(streamControllerFavorites.stream, updateStream);
    } else if (widget.tabItem == "Page4") {
      child = ProfilePage(streamControllerProfile.stream, updateStream);
    }*/

    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }
}
