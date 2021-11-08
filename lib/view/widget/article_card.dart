//import 'dart:html';

import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/models/preferences_articles.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ArticleCard extends StatelessWidget {
  final int id;
  final String title;
  final String rating = "30";
  final double price;
  final String image;
  final String description;
  final String category;
  dynamic callback;

  ArticleCard({
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
    required this.id,
    required this.callback,
  });

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

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        width: displayWidth,
        height: blockSizeHorizontal * 35,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              offset: Offset(
                0.0,
                10.0,
              ),
              blurRadius: 10.0,
              spreadRadius: -6.0,
            ),
          ],
        ),
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Picture + Rating / Discount%
            Align(
              child:
              // Product Image
              Container(
                //color: Colors.purple,
                width: blockSizeHorizontal * 30,//displayWidth/3 - 20,
                height: blockSizeVertical * 20,
                margin: EdgeInsets.only(left: blockSizeHorizontal * 1),//(left: 10),
                child:
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                  Image.network(
                    image,
                    width: blockSizeHorizontal * 50,//displayWidth / 3 - 30,
                    height: blockSizeHorizontal * 30,//displayWidth / 3 - 30,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              alignment: Alignment.centerLeft,
            ),


            Container(
              // title
              //color: Colors.blue,
              margin: EdgeInsets.only(left: blockSizeHorizontal * 2, right: blockSizeHorizontal * 2, top: blockSizeVertical * 4),//(left: 4, right: 4, top: 20),
              width: blockSizeHorizontal * 30,//displayWidth/3 ,
              height: blockSizeVertical * 20,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: safeBlockHorizontal * 3.5,//16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
                textAlign: TextAlign.center,
              ),
              alignment: Alignment.topCenter,
            ),

            Container(
              //color: Colors.red,
                width: blockSizeHorizontal * 25,//displayWidth / 3 -35,
                height: blockSizeVertical * 20,
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Favourite Icon
                    Align(
                      child: Padding(
                        padding: EdgeInsets.only(right: blockSizeHorizontal * 2),
                        child:
                        //TODO: adjust to clickable Icon
                        Icon(Icons.favorite_border),
                      ),
                      alignment: Alignment.centerRight,
                    ),
                    Container(                                                      // % Badge
                      padding: EdgeInsets.only(top: blockSizeVertical * 1, bottom: blockSizeVertical * 1, left: blockSizeHorizontal * 5, right: blockSizeHorizontal * 4),//(top: 3, bottom: 3, left: 10, right: 17),
                      decoration: BoxDecoration(color: Color.fromRGBO(220, 110, 30, 1),  // const Color.fromRGBO(23, 41, 111, 0.8),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child:
                      Text("-" + rating+ "%",
                        style: TextStyle(
                          color: Color.fromRGBO(240, 240, 240, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: safeBlockHorizontal * 4,
                        ),
                      ),
                    ),
                    // current Price...
                    Container(
                      margin: EdgeInsets.only(right: blockSizeHorizontal * 2, bottom: blockSizeVertical * 0),
                      child:
                      Column(
                          children: [
                            Text(
                              "Current Price:",
                              style: TextStyle(
                                  fontWeight: FontWeight
                                      .bold,
                                  fontSize: safeBlockHorizontal * 2.5,//10,
                                  color: Colors
                                      .black),
                            ),
                            Text(
                              price.toString() + " €",
                              style: TextStyle(
                                fontWeight: FontWeight
                                    .bold,
                                fontSize: safeBlockHorizontal * 5,
                                color: Color
                                    .fromRGBO(
                                    220, 110, 30,
                                    1),),
                            ),
                            Text(
                              //ToDO: add previous price
                              "Previously 9.99€",
                              style: TextStyle(
                                  fontSize: safeBlockHorizontal * 2.0,
                                  color: Colors
                                      .black),
                            ),
                          ]
                      ),
                    ),
                  ],
                )
            ),
          ],
        )
    );
  }

  Future _changeFavoriteState() async {
    await callback.changeFavoriteState(this);
  }
}













