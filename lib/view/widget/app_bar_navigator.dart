import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:penny_pincher/services/product_controller.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/view/theme.dart';

import '../browser_view.dart';
import '../search_view.dart';
import 'article_search.dart';
import 'favorite_search.dart';


class HomeBrowserAppBar extends StatelessWidget implements PreferredSizeWidget {
  dynamic callback;
  HomeBrowserAppBar(callback) {
    this.callback = callback;
  }

  bool isWeb = false;


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

    if (displayWidth > 412) {
      isWeb = true;
    } else  {
      isWeb = false;
    }

    return AppBar(
      backgroundColor: ThemeChanger.navBarColor,
      title: Center(
        child:
          Image.asset(
            'pictures/pp_logo1.png',
              width: blockSizeHorizontal * 50,
          ),

      ),
      actions: [
        IconButton(
          iconSize: isWeb ? safeBlockHorizontal * 2 : safeBlockHorizontal * 7.5,
          icon: Icon(Icons.search),
          onPressed: () {
            final results =
            showSearch(context: context, delegate: ArticleSearch(true, callback, callback.streamController));
          },
        ),
      ],

      leading: callback.widget is BrowserPage ?
      IconButton(
        iconSize: safeBlockHorizontal * 7.5,
        icon: Icon(Icons.bookmarks_outlined),
        onPressed: () {
          callback.showSearches = !callback.showSearches;
          callback.setState(() {});
          },
      ) : SizedBox(width:0)
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

  bool isWeb = false;


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

    if (displayWidth > 412) {
      isWeb = true;
    } else  {
      isWeb = false;
    }

    return AppBar(
      backgroundColor: ThemeChanger.navBarColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: blockSizeHorizontal * 17.8),
          Image.asset(
            'pictures/pp_logo1.png',
            width: blockSizeHorizontal * 50,
          ),
          SizedBox(width: blockSizeHorizontal * 4),

        ],
      ),
      actions: [
        IconButton(
          iconSize: isWeb ? safeBlockHorizontal * 2 : safeBlockHorizontal * 7.5,
          icon: Icon(Icons.search),
          onPressed: () {
            final results =
            showSearch(context: context, delegate: FavoriteSearch(callback, callback.streamController));
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: blockSizeHorizontal * 5.6),
          Image.asset(
            'pictures/pp_logo1.png',
            width: blockSizeHorizontal * 50,
          ),
          SizedBox(width: blockSizeHorizontal * 4),
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
          SizedBox(width: blockSizeHorizontal * 7.5),
          Image.asset(
            'pictures/pp_logo1.png',
            width: blockSizeHorizontal * 50,
          ),
          SizedBox(width: blockSizeHorizontal * 4),
        ],
      ),
    );
  }

  @override
  // TODO: change to responsive height
  Size get preferredSize => Size.fromHeight(55.0);

}

class CategorieViewAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CategorieViewAppBar({Key? key}) : super(key: key);


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
          SizedBox(width: blockSizeHorizontal * 7.5),
          Image.asset(
            'pictures/pp_logo2.png',
            width: blockSizeHorizontal * 50,
          ),
          SizedBox(width: blockSizeHorizontal * 4),
        ],
      ),
    );
  }

  @override
  // TODO: change to responsive height
  Size get preferredSize => Size.fromHeight(55.0);

}