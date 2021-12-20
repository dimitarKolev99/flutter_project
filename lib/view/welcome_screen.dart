import 'package:flutter/cupertino.dart';
import 'package:penny_pincher/models/preferences_articles.dart';
import 'package:penny_pincher/services/json_functions.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/view/theme.dart';
import 'package:penny_pincher/view/widget/app_bar_navigator.dart';
import 'package:penny_pincher/view/widget/article_card.dart';
import 'package:penny_pincher/view/widget/article_search.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:penny_pincher/view/extended_view.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

StreamController<bool> streamController = StreamController<bool>.broadcast();

class WelcomePage extends StatefulWidget {
  final dynamic callback;

  WelcomePage(this.callback);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  List<bool> isSelected = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Expanded(
              child: ListView(children: <Widget>[
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Choose your favorite categories!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 45),
                Container(
                    child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ToggleButtons(
                      color: ThemeChanger.navBarColor,
                      borderColor: ThemeChanger.navBarColor,
                      fillColor: ThemeChanger.lightBlue,
                      borderWidth: 2,
                      selectedBorderColor: ThemeChanger.navBarColor,
                      selectedColor: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      children: <Widget>[
                        Icon(Icons.dry_cleaning, size: 35),
                        Icon(Icons.laptop, size: 35),
                        Icon(Icons.ad_units, size: 35),
                        Icon(Icons.book, size: 35),
                      ],
                      onPressed: (int index) {
                        int count = 0;
                        isSelected.forEach((bool val) {
                          if (val) count++;
                        });

                        if (isSelected[index] && count < 1) return;

                        setState(() {
                          isSelected[index] = !isSelected[index];
                        });
                      },
                      renderBorder: false,
                      constraints: BoxConstraints(minWidth: 70, minHeight: 70),
                      isSelected: isSelected,
                    ),
                  ],
                )),
              ]),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(33),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          offset: Offset(
                            0.0,
                            10.0,
                          ),
                          blurRadius: 20.0,
                          spreadRadius: -3.0,
                        ),
                      ],
                      color: ThemeChanger.textColor,
                    ),
                    child: TextButton(
                      onPressed: () {
                        widget.callback.closeWelcomeScreen();
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(ThemeChanger.textColor),
                          foregroundColor: MaterialStateProperty.all(
                              Color.fromRGBO(45, 45, 45, 1)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(33),
                            //side: BorderSide(color: Colors.black)
                          )),
                          textStyle: MaterialStateProperty.all(TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w500,
                          ))),
                      child: Text("Fortfahren"),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(33),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          offset: Offset(
                            0.0,
                            10.0,
                          ),
                          blurRadius: 20.0,
                          spreadRadius: -3.0,
                        ),
                      ],
                      color: ThemeChanger.textColor,
                    ),
                    child: TextButton(
                      onPressed: () {
                        widget.callback.closeWelcomeScreen();
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(ThemeChanger.textColor),
                          foregroundColor: MaterialStateProperty.all(
                              Color.fromRGBO(45, 45, 45, 1)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(33),
                            //side: BorderSide(color: Colors.black)
                          )),
                          textStyle: MaterialStateProperty.all(TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w500,
                          ))),
                      child: Text("Überspringen"),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
