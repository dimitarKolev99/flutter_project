import 'package:flutter/cupertino.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
  List<bool> isSelected1 = [false, false, false, false];
  List<bool> isSelected2 = [false, false, false, false];
  List<bool> isSelected3 = [false, false, false];
  late bool _isButtonDisabled;

  @override
  void initState() {
    _isButtonDisabled = true;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Expanded(
              child: ListView(children: <Widget>[
                SizedBox(height: 30),
                const Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Choose your start categories!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 45),
                Container(
                    child: Row(
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.ad_units, size: 40),
                            SizedBox(height: 10),
                            Text(
                              "Elektroartikel",
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(MdiIcons.pill, size: 40),
                            SizedBox(height: 10),
                            Text(
                              "Drogerie",
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(MdiIcons.flowerTulip, size: 40),
                            SizedBox(height: 10),
                            Text(
                              "Garten",
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(MdiIcons.tshirtCrew, size: 40),
                            SizedBox(height: 10),
                            Text(
                              "Mode",
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        )
                      ],
                      onPressed: (int index) {
                        int count = 0;
                        isSelected1.forEach((bool val) {
                          if (val) count++;
                        });

                        if (isSelected1[index] && count < 1) {
                          _isButtonDisabled = true;
                          return;
                        }

                        setState(() {
                          isSelected1[index] = !isSelected1[index];
                          if (count <= 1 && !isSelected1[index]) {
                            _isButtonDisabled = true;
                          } else {
                            _isButtonDisabled = false;
                          }
                        });
                      },
                      renderBorder: false,
                      constraints: BoxConstraints(minWidth: 90, minHeight: 90),
                      isSelected: isSelected1,
                    ),
                  ],
                )),
                const SizedBox(height: 40),
                Container(
                    child: Row(
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(MdiIcons.paw, size: 40),
                            SizedBox(height: 10),
                            Text(
                              "Tierbedarf",
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(MdiIcons.controllerClassic, size: 40),
                            SizedBox(height: 10),
                            Text(
                              "Gaming",
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(MdiIcons.food, size: 40),
                            SizedBox(height: 10),
                            Text(
                              "Essen",
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(MdiIcons.babyCarriage, size: 40),
                            SizedBox(height: 10),
                            Text(
                              "Baby",
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                      ],
                      onPressed: (int index) {
                        int count = 0;
                        isSelected2.forEach((bool val) {
                          if (val) count++;
                        });

                        if (isSelected2[index] && count < 1) {
                          _isButtonDisabled = true;
                          return;
                        }

                        setState(() {
                          isSelected2[index] = !isSelected2[index];
                          if (count <= 1 && !isSelected2[index]) {
                            _isButtonDisabled = true;
                          } else {
                            _isButtonDisabled = false;
                          }
                        });
                      },
                      renderBorder: false,
                      constraints: BoxConstraints(minWidth: 90, minHeight: 90),
                      isSelected: isSelected2,
                    ),
                  ],
                )),
                const SizedBox(height: 45),
                Container(
                    child: Row(
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(MdiIcons.car, size: 40),
                            SizedBox(height: 10),
                            Text(
                              "Auto",
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(MdiIcons.vacuum, size: 40),
                            SizedBox(height: 10),
                            Text(
                              "Haushaltselektronik",
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(MdiIcons.tennis, size: 40),
                            SizedBox(height: 10),
                            Text(
                              "Sport",
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                      ],
                      onPressed: (int index) {
                        int count = 0;
                        isSelected3.forEach((bool val) {
                          if (val) count++;
                        });

                        if (isSelected3[index] && count < 1) {
                          _isButtonDisabled = true;
                          return;
                        }

                        setState(() {
                          isSelected3[index] = !isSelected3[index];
                          if (count <= 1 && !isSelected3[index]) {
                            _isButtonDisabled = true;
                          } else {
                            _isButtonDisabled = false;
                          }
                        });
                      },
                      renderBorder: false,
                      constraints: BoxConstraints(minWidth: 90, minHeight: 90),
                      isSelected: isSelected3,
                    ),
                  ],
                )),
              ]),
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: 50,
                        margin:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                          onPressed: _isButtonDisabled
                              ? null
                              : () {
                                  for (var i = 0; i < isSelected1.length; i++) {
                                    if (isSelected1[i]) {
                                      widget.callback.selectCategory(i);
                                    }
                                  }
                                  for (var i = 0; i < isSelected2.length; i++) {
                                    if (isSelected2[i]) {
                                      widget.callback.selectCategory(4 + i);
                                    }
                                  }
                                  for (var i = 0; i < isSelected3.length; i++) {
                                    if (isSelected3[i]) {
                                      widget.callback.selectCategory(8 + i);
                                    }
                                  }
                                  widget.callback.closeWelcomeScreen();
                                },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  ThemeChanger.lightBlue),
                              foregroundColor: MaterialStateProperty.all(
                                  Color.fromRGBO(45, 45, 45, 1)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: ThemeChanger.navBarColor,
                                        width: 2,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(3)),
                              ),
                              textStyle: MaterialStateProperty.all(TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w500,
                              ))),
                          child: Text(
                            "Fortfahren",
                            style: TextStyle(
                              color: ThemeChanger.textColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                )),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
