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
                    "Choose your favorite categories!",
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
                        Icon(Icons.ad_units, size: 35),
                        Icon(MdiIcons.pill, size: 35),
                        Icon(MdiIcons.flowerTulip, size: 35),
                        Icon(MdiIcons.tshirtCrew, size: 35),
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
                      constraints: BoxConstraints(minWidth: 70, minHeight: 70),
                      isSelected: isSelected1,
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
                      children: const <Widget>[
                        Icon(MdiIcons.paw, size: 35),
                        Icon(MdiIcons.controllerClassic, size: 35),
                        Icon(MdiIcons.food, size: 35),
                        Icon(MdiIcons.babyCarriage, size: 35),
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
                      constraints: BoxConstraints(minWidth: 70, minHeight: 70),
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
                      children: const <Widget>[
                        Icon(MdiIcons.car, size: 35),
                        Icon(MdiIcons.vacuum, size: 35),
                        Icon(MdiIcons.tennis, size: 35),
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
                      constraints: BoxConstraints(minWidth: 70, minHeight: 70),
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
                            for(var i = 0; i < isSelected1.length; i++) {
                              if (isSelected1[i]) {
                                widget.callback.selectCategory(i);
                              }
                            }
                            for(var i = 0; i < isSelected2.length; i++) {
                              if (isSelected2[i]) {
                                widget.callback.selectCategory(4 + i);
                              }
                            }
                            for(var i = 0; i < isSelected3.length; i++) {
                              if (isSelected3[i]) {
                                widget.callback.selectCategory(8 + i);
                              }
                            }
                                  widget.callback.closeWelcomeScreen();
                                },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  ThemeChanger.textColor),
                              foregroundColor: MaterialStateProperty.all(
                                  Color.fromRGBO(45, 45, 45, 1)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
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
                )),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
