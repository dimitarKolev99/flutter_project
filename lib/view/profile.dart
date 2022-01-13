import 'package:penny_pincher/models/preferences_articles.dart';
import 'package:penny_pincher/services/notification_service.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/view/theme.dart';
import 'package:penny_pincher/view/widget/app_bar_navigator.dart';
import 'package:penny_pincher/view/widget/article_card.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/view/widget/article_search.dart';
import 'dart:async';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';


import 'package:penny_pincher/view/widget/browser_article_card.dart';
import 'package:penny_pincher/view/extended_view.dart';

import 'about.dart';

StreamController<bool> streamController = StreamController<bool>.broadcast();

class ProfilePage extends StatefulWidget {
  late final Stream<bool> stream;
  late final StreamController updateStream;

  ProfilePage(this.stream, this.updateStream);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    MediaQueryData _mediaQueryData = MediaQuery.of(context);

    double displayWidth = _mediaQueryData.size.width;
    double displayHeight = _mediaQueryData.size.height;
    double blockSizeHorizontal = displayWidth / 100; // bildschirmbreite in 1%
    double blockSizeVertical = displayHeight / 100; // bildschirmhöhe in 1%
    return Scaffold(
      //ScreenUtil.init(context, height:896, width:414, allowFontScaling: true);
      appBar: ProfileAppBar(),
      body: Column(
        children: <Widget>[
          SizedBox(height: blockSizeVertical * 20),
          Expanded(
            child: ListView(
              //padding: EdgeInsets.only(top: 50),
              children: <Widget>[
                Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: ThemeChanger.textColor,
                  ),
                  child:
                  TextButton(
                    onPressed: () {
                      if(_themeChanger.getTheme() == ThemeData.light()){
                        return _themeChanger.setdarkTheme(ThemeData.dark());
                      }
                      if(_themeChanger.getTheme() == ThemeData.dark()){
                        return _themeChanger.setlightTheme(ThemeData.light());
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(ThemeChanger.lightBlue),
                        foregroundColor: MaterialStateProperty.all(Color.fromRGBO(45, 45, 45, 1)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                side: BorderSide(
                                    color: ThemeChanger.navBarColor,
                                    width: 2,
                                    style: BorderStyle.solid),
                                borderRadius:
                                BorderRadius.circular(3)),
                        ),
                        textStyle: MaterialStateProperty.all(TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                        ))),
                    child: Text("Dark/Light Mode",style: TextStyle(
                      color: ThemeChanger.textColor,
                    ),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: ThemeChanger.textColor,
                  ),
                  child:
                  TextButton(
                    onPressed: () {
                      NotificationService().showNotification(
                          1,
                          "Notification",
                          "New items have been added to your favorite category. Check them out now!",
                          5);
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(ThemeChanger.lightBlue),
                        foregroundColor: MaterialStateProperty.all(Color.fromRGBO(45, 45, 45, 1)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              side: BorderSide(
                                  color: ThemeChanger.navBarColor,
                                  width: 2,
                                  style: BorderStyle.solid),
                              borderRadius:
                              BorderRadius.circular(3)),
                        ),
                        textStyle: MaterialStateProperty.all(TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                        ))),
                    child: Text("Notification",style: TextStyle(
                      color: ThemeChanger.textColor,
                    ),),
                  ),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: ThemeChanger.textColor,
                  ),
                  child:
                  TextButton(
                    onPressed: () {
                      showAlertDialog(context);
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(ThemeChanger.lightBlue),
                        foregroundColor: MaterialStateProperty.all(Color.fromRGBO(45, 45, 45, 1)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              side: BorderSide(
                                  color: ThemeChanger.navBarColor,
                                  width: 2,
                                  style: BorderStyle.solid),
                              borderRadius:
                              BorderRadius.circular(3)),
                        ),
                        textStyle: MaterialStateProperty.all(TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                        ))),
                    child: Text("Suchverlauf Löschen",style: TextStyle(
                      color: ThemeChanger.textColor,
                    ),),
                  ),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: ThemeChanger.textColor,
                  ),
                  child:
                  TextButton(
                    onPressed: () {
                      Navigator.push (
                        context,
                        MaterialPageRoute(builder: (context) => About()),
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(ThemeChanger.lightBlue),
                        foregroundColor: MaterialStateProperty.all(Color.fromRGBO(45, 45, 45, 1)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              side: BorderSide(
                                  color: ThemeChanger.navBarColor,
                                  width: 2,
                                  style: BorderStyle.solid),
                              borderRadius:
                              BorderRadius.circular(3)),
                        ),
                        textStyle: MaterialStateProperty.all(TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                        ))),
                    child: Text("About",style: TextStyle(
                      color: ThemeChanger.textColor,
                    ),),
                  ),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: ThemeChanger.textColor,
                  ),
                  child:
                  TextButton(
                    onPressed: () {

                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(ThemeChanger.lightBlue),
                        foregroundColor: MaterialStateProperty.all(Color.fromRGBO(45, 45, 45, 1)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              side: BorderSide(
                                  color: ThemeChanger.navBarColor,
                                  width: 2,
                                  style: BorderStyle.solid),
                              borderRadius:
                              BorderRadius.circular(3)),
                        ),
                        textStyle: MaterialStateProperty.all(TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                        ))),
                    child: Text("Help",style: TextStyle(
                      color: ThemeChanger.textColor,
                    ),),
                  ),
                )
              ],
            )
          )
        ]
      )
    );
  }

  static showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Nein"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = TextButton(
      style: TextButton.styleFrom(
        primary: Colors.red,
      ),
      child: const Text("Ja"),
      onPressed: () async {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        ArticleSearch.deleteAllRecent();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Suchverlauf löschen?"),
      content: const Text(
          "Willst du wirklich deinen kompletten Textsuchverlauf löschen?"),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
