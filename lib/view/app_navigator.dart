//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/services/app_icons.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/view/theme.dart';
import 'package:penny_pincher/view/widget/tab_navigator.dart';
import 'package:provider/provider.dart';

class AppNavigator extends StatefulWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<AppNavigator> {
  bool _isLoading = true;
  bool isLargeDevice = true;
  bool isWeb = false;
  var sizedBoxHeight = 0.0;
  var iconSize = 0.0;
  String _currentPage = "Page1";
  List<String> pageKeys = ["Page1", "Page2", "Page3", "Page4"];
  final Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "Page1": GlobalKey<NavigatorState>(),
    "Page2": GlobalKey<NavigatorState>(),
    "Page3": GlobalKey<NavigatorState>(),
    "Page4": GlobalKey<NavigatorState>(),
  };
  int _selectedIndex = 0;

  void _selectTab(String tabItem, int index) {
    if (tabItem == _currentPage) {
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = pageKeys[index];
        _selectedIndex = index;
      });
    }
  }



  @override
  Widget build(context) {
    MediaQueryData _mediaQueryData;
    double displayWidth;
    double displayHeight;
    double blockSizeHorizontal;
    double blockSizeVertical;

    double _safeAreaHorizontal;
    double _safeAreaVertical;

    double _safeAreaBottomPadding;
    double safeBlockBottom;

    double safeBlockHorizontal;
    double safeBlockVertical;

    _mediaQueryData = MediaQuery.of(context);
    displayWidth = _mediaQueryData.size.width;
    displayHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = displayWidth / 100;
    blockSizeVertical = displayHeight / 100;

    _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;

    _safeAreaBottomPadding = _mediaQueryData.padding.bottom;
    safeBlockBottom = (displayWidth - _safeAreaBottomPadding) / 100;

    safeBlockHorizontal = (displayWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (displayHeight - _safeAreaVertical) / 100;

    if (displayHeight > 683) { //1280 Pixels Höhe
      isLargeDevice = true;
      sizedBoxHeight = (displayHeight / 100) * 9;
      iconSize = safeBlockHorizontal * 7;
    } else  {
      isLargeDevice = false;
      sizedBoxHeight = (displayHeight / 100) * 8.8;
      iconSize = safeBlockHorizontal * 6.5;
    }

    if (displayWidth > 412) {
      isWeb = true;
    } else  {
      isWeb = false;
    }

   // print("Höhe: $displayHeight");
   // print("Breite: $displayWidth");
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return WillPopScope(
        onWillPop: () async {
          final isFirstRouteInCurrentTab =
              !await _navigatorKeys[_currentPage]!.currentState!.maybePop();
          //  check if we deeper in the stack of the current page
          if (isFirstRouteInCurrentTab) {
            // check if we're not on first Page / LiveFeed -> If true return to Live Feed
            if (_currentPage != "Page1") {
              _selectTab("Page1", 0);
              return false;
            }
          }
          // let system handle back button if we're on the first route
          return isFirstRouteInCurrentTab;
        },
        child: Scaffold(
          body: Stack(children: <Widget>[
            _buildOffstageNavigator("Page1"),
            _buildOffstageNavigator("Page2"),
            _buildOffstageNavigator("Page3"),
            _buildOffstageNavigator("Page4"),
          ]),
          bottomNavigationBar: _isLoading
              ? SizedBox()
              : SizedBox(
                  height: isWeb ? (displayHeight / 100) * 9 : sizedBoxHeight,
                  child: BottomNavigationBar(
                    selectedItemColor: ThemeChanger.highlightedColor,
                    unselectedItemColor: ThemeChanger.textColor,
                    iconSize: safeBlockHorizontal * 6,
                    backgroundColor: ThemeChanger.navBarColor,
                    onTap: (int index) {
                      _selectTab(pageKeys[index], index);
                    },
                    currentIndex: _selectedIndex,
                    items: [
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding: EdgeInsets.only(bottom: safeBlockBottom * 0.5),
                          child: Icon(Icons.update, size: isWeb ? iconSize = safeBlockHorizontal * 1.9 : iconSize),
                        ),
                        label: 'LiveFeed',
                      ),
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding: EdgeInsets.only(bottom: safeBlockBottom * 0.5),
                          child: Icon(AppIcon.view_tile, size: isWeb ? iconSize = safeBlockHorizontal * 1.9 : iconSize),
                        ),
                        label: 'Browser',
                      ),
                      // TODO: change heart Icon to bookmark_add_outlined ?
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding: EdgeInsets.only(bottom: safeBlockBottom * 0.5),
                          child: Icon(Icons.bookmarks_outlined,  size: isWeb ? iconSize = safeBlockHorizontal * 1.9 : iconSize),

                        ),
                        label: 'Merkzettel',
                      ),
                      BottomNavigationBarItem(
                        icon: Padding(
                          padding: EdgeInsets.only(bottom: safeBlockBottom * 0.5),
                          child: Icon(Icons.account_circle, size: isWeb ? iconSize = safeBlockHorizontal * 1.9 : iconSize),
                        ),
                        label: 'Profil',
                      ),
                    ],
                    type: BottomNavigationBarType.fixed,
                  ),
              ),
        )
    );
  }

  Widget _buildOffstageNavigator(String tabItem) {
    return Offstage(
      offstage: _currentPage != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem]!,
        tabItem: tabItem,
        callback: this,
      ),
    );
  }

  loadingFinished() {
    setState(() {
      _isLoading = false;
    });
  }
}
