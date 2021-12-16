import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:penny_pincher/services/fav_functions.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/view/theme.dart';

import '../browser_view.dart';
import 'article_search.dart';
import 'favorite_search.dart';


class HomeBrowserAppBar extends StatelessWidget implements PreferredSizeWidget {
  dynamic callback;
  HomeBrowserAppBar(callback) {
    this.callback = callback;
  }


  @override
  Widget build(BuildContext context) {

    MediaQueryData _mediaQueryData;
    double displayWidth;
    double displayHeight;
    double blockSizeHorizontal;
    double blockSizeVertical;

    double _safeAreaHorizontal;
    double _safeAreaVertical;
    double safeBlockHorizontal;
    double safeBlockVertical;

    _mediaQueryData = MediaQuery.of(context);
    displayWidth = _mediaQueryData.size.width;
    displayHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = displayWidth / 100;
    blockSizeVertical = displayHeight / 100;

    _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (displayWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (displayHeight - _safeAreaVertical) / 100;

    return AppBar(
      backgroundColor: ThemeChanger.navBarColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: blockSizeHorizontal * 17.8),
          Padding(
            padding: EdgeInsets.only(top: blockSizeVertical * 1),
            child:
            Text(
              'Penny Pincher',
              style: TextStyle(
                // Shaddow is used to get Distance to the underline -> TextColor itself is transparent
                shadows: [
                  Shadow(
                      color: Color.fromRGBO(240, 240, 240, 1),
                      offset: Offset(0, -6))
                ],
                //fontFamily: '....',
                fontSize: safeBlockVertical * 3.5,
                letterSpacing: safeBlockHorizontal * 0.5,
                color: Colors.transparent,
                fontWeight: FontWeight.w900,
                decoration:
                TextDecoration.underline,
                decorationColor: ThemeChanger.highlightedColor,
                decorationThickness: safeBlockVertical * 0.5,
              ),
            ),
          ),
          SizedBox(width: safeBlockHorizontal * 4),

        ],
      ),
      actions: [
        IconButton(
          iconSize: safeBlockHorizontal * 7.5,
          icon: Icon(Icons.search),
          onPressed: () {
            final results =
            showSearch(context: context, delegate: ArticleSearch(true, callback, streamController));
          },
        )
      ],
    );
  }

  @override
  // TODO: change to responsive height
  Size get preferredSize => Size.fromHeight(55.0);
}

class FavoriteAppBar extends StatelessWidget implements PreferredSizeWidget {
  dynamic callback;
  FavoriteAppBar(callback) {
    this.callback = callback;
  }

  @override
  Widget build(BuildContext context) {

    MediaQueryData _mediaQueryData;
    double displayWidth;
    double displayHeight;
    double blockSizeHorizontal;
    double blockSizeVertical;

    double _safeAreaHorizontal;
    double _safeAreaVertical;
    double safeBlockHorizontal;
    double safeBlockVertical;

    _mediaQueryData = MediaQuery.of(context);
    displayWidth = _mediaQueryData.size.width;
    displayHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = displayWidth / 100;
    blockSizeVertical = displayHeight / 100;

    _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (displayWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (displayHeight - _safeAreaVertical) / 100;

    return AppBar(
      backgroundColor: ThemeChanger.navBarColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: blockSizeHorizontal * 17.8),
          Padding(
            padding: EdgeInsets.only(top: blockSizeVertical * 1),
            child:
            Text(
              'Penny Pincher',
              style: TextStyle(
                // Shaddow is used to get Distance to the underline -> TextColor itself is transparent
                shadows: [
                  Shadow(
                      color: Color.fromRGBO(240, 240, 240, 1),
                      offset: Offset(0, -6))
                ],
                //fontFamily: '....',
                fontSize: safeBlockVertical * 3.5,
                letterSpacing: safeBlockHorizontal * 0.5,
                color: Colors.transparent,
                fontWeight: FontWeight.w900,
                decoration:
                TextDecoration.underline,
                decorationColor: ThemeChanger.highlightedColor,
                decorationThickness: safeBlockVertical * 0.5,
              ),
            ),
          ),
          SizedBox(width: safeBlockHorizontal * 4),

        ],
      ),
      actions: [
        IconButton(
          iconSize: safeBlockHorizontal * 7.5,
          icon: Icon(Icons.search),
          onPressed: () {
            final results =
            showSearch(context: context, delegate: FavoriteSearch(callback, streamController));
          },
        )
      ],
    );
  }

  @override
  // TODO: change to responsive height
  Size get preferredSize => Size.fromHeight(55.0);

}

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData;
    double displayWidth;
    double displayHeight;
    double blockSizeHorizontal;
    double blockSizeVertical;

    double _safeAreaHorizontal;
    double _safeAreaVertical;
    double safeBlockHorizontal;
    double safeBlockVertical;

    _mediaQueryData = MediaQuery.of(context);
    displayWidth = _mediaQueryData.size.width;
    displayHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = displayWidth / 100;
    blockSizeVertical = displayHeight / 100;

    _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (displayWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (displayHeight - _safeAreaVertical) / 100;

    return AppBar(
      backgroundColor: ThemeChanger.navBarColor,
      title: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: blockSizeHorizontal * 21),
          Padding(
            padding: EdgeInsets.only(top: blockSizeVertical * 1),
            child:
            Text(
              'Penny Pincher',
              style: TextStyle(
                // Shaddow is used to get Distance to the underline -> TextColor itself is transparent
                shadows: [
                  Shadow(
                      color: Color.fromRGBO(240, 240, 240, 1),
                      offset: Offset(0, -6))
                ],
                //fontFamily: '....',
                fontSize: safeBlockVertical * 3.5,
                letterSpacing: safeBlockHorizontal * 0.5,
                color: Colors.transparent,
                fontWeight: FontWeight.w900,
                decoration:
                TextDecoration.underline,
                decorationColor: ThemeChanger.highlightedColor,
                decorationThickness: safeBlockVertical * 0.5,
              ),
            ),
          ),
          SizedBox(width: safeBlockHorizontal * 4.5),

        ],
      ),
    );
  }

  @override
  // TODO: change to responsive height
  Size get preferredSize => Size.fromHeight(55.0);
}

class ExtendedViewAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ExtendedViewAppBar({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData;
    double displayWidth;
    double displayHeight;
    double blockSizeHorizontal;
    double blockSizeVertical;

    double _safeAreaHorizontal;
    double _safeAreaVertical;
    double safeBlockHorizontal;
    double safeBlockVertical;

    _mediaQueryData = MediaQuery.of(context);
    displayWidth = _mediaQueryData.size.width;
    displayHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = displayWidth / 100;
    blockSizeVertical = displayHeight / 100;

    _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (displayWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (displayHeight - _safeAreaVertical) / 100;

    return AppBar(
      backgroundColor: ThemeChanger.navBarColor,
      title: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: blockSizeHorizontal * 5.4),
          Padding(
            padding: EdgeInsets.only(top: blockSizeVertical * 1),
            child:
            Text(
              'Penny Pincher',
              style: TextStyle(
                // Shaddow is used to get Distance to the underline -> TextColor itself is transparent
                shadows: [
                  Shadow(
                      color: Color.fromRGBO(240, 240, 240, 1),
                      offset: Offset(0, -6))
                ],
                //fontFamily: '....',
                fontSize: safeBlockVertical * 3.5,
                letterSpacing: safeBlockHorizontal * 0.5,
                color: Colors.transparent,
                fontWeight: FontWeight.w900,
                decoration:
                TextDecoration.underline,
                decorationColor: ThemeChanger.highlightedColor,
                decorationThickness: safeBlockVertical * 0.5,
              ),
            ),
          ),
          SizedBox(width: safeBlockHorizontal * 4.5),

        ],
      ),
    );
  }

  @override
  // TODO: change to responsive height
  Size get preferredSize => Size.fromHeight(55.0);

}