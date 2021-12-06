import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/services/product_api.dart';

import '../theme.dart';


class ArticleCard extends StatelessWidget {
  final int id;
  final String title;
  final int saving;
  final double price;
  final String image;
  final String description;
  final String category;
  dynamic callback;

  ArticleCard({
    required this.title,
    required this.saving,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
    required this.id,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    double newprice = price/100;
    int x = 100 - saving;
    double prevpreis = newprice/x * 100;

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
              margin: EdgeInsets.only(left: blockSizeHorizontal * 2, right: blockSizeHorizontal * 2, top: blockSizeVertical * 7),//(left: 4, right: 4, top: 20),
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
                height: blockSizeVertical * 25,
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
                          IconButton(
                          icon: (callback.isFavorite(id) ?
                            const Icon(Icons.favorite,
                            color: Colors.red) : const Icon(Icons.favorite_border,
                            color: Colors.black)),
                            onPressed: _changeFavoriteState,
                            ),
                      ),
                      alignment: Alignment.centerRight,
                    ),
                    Container(                                                      // % Badge
                      padding: EdgeInsets.only(top: blockSizeVertical * 1, bottom: blockSizeVertical * 1, left: blockSizeHorizontal * 3, right: blockSizeHorizontal * 3),//(top: 3, bottom: 3, left: 10, right: 17),
                      decoration: BoxDecoration(color: ThemeChanger.highlightedColor,  // const Color.fromRGBO(23, 41, 111, 0.8),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child:
                      Text("-" + saving.toString() + "%",
                        style: TextStyle(
                          color: ThemeChanger.textColor,
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
                              "Aktueller Preis:",
                              style: TextStyle(
                                  fontWeight: FontWeight
                                      .bold,
                                  fontSize: safeBlockHorizontal * 2.5,//10,
                                  color: Colors
                                      .black),
                            ),
                            Text(
                              newprice.toStringAsFixed(2) + "€",
                              style: TextStyle(
                                fontWeight: FontWeight
                                    .bold,
                                fontSize: safeBlockHorizontal * 5,
                                color: ThemeChanger.highlightedColor),
                            ),
                            Text(
                              prevpreis.toStringAsFixed(2) + "€",
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: safeBlockHorizontal * 4.0,
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













