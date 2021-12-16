import 'package:flutter/cupertino.dart';
import 'package:penny_pincher/models/preferences_articles.dart';
import 'package:penny_pincher/services/fav_functions.dart';
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

class WelcomePage extends StatefulWidget {
  WelcomePage();

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  List<bool> isSelected = [true, false, false, false];
  List<IconData> iconList = [
    Icons.dry_cleaning,
    Icons.laptop,
    Icons.ad_units,
    Icons.book
  ];

  @override
  Widget build(BuildContext context) {
    //wrap the GridView wiget in an Ink wiget and set the width and height,
    //otherwise the GridView widget will fill up all the space of its parent widget
    return Ink(
      width: 100,
      height: 60,
      color: Colors.white,
      child: GridView.count(
        primary: true,
        crossAxisCount: 4, //set the number of buttons in a row
        crossAxisSpacing: 16, //set the spacing between the buttons
        childAspectRatio: 1, //set the width-to-height ratio of the button,
        //>1 is a horizontal rectangle
        children: List.generate(isSelected.length, (index) {
          //using Inkwell widget to create a button
          return InkWell(
              splashColor: Colors.yellow, //the default splashColor is grey
              onTap: () {
                //set the toggle logic
                int count = 0;
                isSelected.forEach((bool val) {
                  if (val) count++;
                });
                if (isSelected[index] && count < 1) return;
                setState(() {
                  isSelected[index] = !isSelected[index];
                });
                isSelected:
                isSelected;
              },
              child: Ink(
                decoration: BoxDecoration(
                  //set the background color of the button when it is selected/ not selected
                  color: isSelected[index] ? Color(0xffD6EAF8) : Colors.white,
                  // here is where we set the rounded corner
                  borderRadius: BorderRadius.circular(8),
                  //don't forget to set the border,
                  //otherwise there will be no rounded corner
                  border: Border.all(color: Colors.red),
                ),
                child: Icon(
                  iconList[index],
                  //set the color of the icon when it is selected/ not selected
                  color: isSelected[index] ? Colors.blue : Colors.grey,
                  size: 50,
                ),
              ));
        }),
      ),
    );
  }
}
