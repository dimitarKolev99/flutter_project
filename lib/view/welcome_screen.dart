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
  WelcomePage();

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  List<bool> isSelected = [true, false, false, false];
  var itemData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

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
                      color: Colors.black,
                      fontSize: 40.0,
                    ),
                  ),
                ),
                SizedBox(height: 45),
                Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ToggleButtons(
                      borderColor: Colors.black,
                      fillColor: Colors.grey,
                      borderWidth: 2,
                      selectedBorderColor: Colors.black,
                      selectedColor: Colors.white,
                      borderRadius: BorderRadius.circular(0),
                      children: <Widget>[
                        Icon(Icons.dry_cleaning),
                        Icon(Icons.laptop),
                        Icon(Icons.ad_units),
                        Icon(Icons.book),
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
                      isSelected: isSelected,
                    ),
                  ],
                )),
              ]),
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
                      onPressed: () {},
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
