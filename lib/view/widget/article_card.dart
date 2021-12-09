import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/services/fav_functions.dart';
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
        margin: EdgeInsets.symmetric(horizontal: blockSizeHorizontal * 3, vertical: blockSizeVertical * 0.5),
        height: blockSizeVertical * 20,
        decoration: BoxDecoration(
          color: ThemeChanger.articlecardbackground,
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
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Picture + Discount%
            Stack(
              children:[
              // Product Image
              Container(
                //color: Colors.purple,
                //width: blockSizeHorizontal * 30,//displayWidth/3 - 20,
                //height: blockSizeVertical * 15,
                margin: EdgeInsets.only(left: blockSizeHorizontal * 3),//(left: 10),
                child:
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child:
                  Image.network(
                    image,
                    //width: blockSizeHorizontal * 50,//displayWidth / 3 - 30,
                    //height: blockSizeHorizontal * 50,//displayWidth / 3 - 30,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
                // % Badge
                Container(
                  margin: EdgeInsets.only(top: blockSizeVertical*0.5),
                  //padding: EdgeInsets.only(top: 3, bottom: 3, left: 7, right: 5),
                  padding: EdgeInsets.only(top: blockSizeVertical * 0.5, bottom: blockSizeVertical * 0.5, left: blockSizeHorizontal *1, right: blockSizeHorizontal * 1),//(top: 3, bottom: 3, left: 10, right: 17),
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
              ]
            ),
            Stack(
              children: [
                //title/description/price
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Column(
                        children: [
                          //title
                          Container(
                            //color: Colors.blue,
                            margin: EdgeInsets.only(left: blockSizeHorizontal * 2, top: blockSizeVertical * 2),//(left: 4, right: 4, top: 20),
                            width: blockSizeHorizontal * 50,//displayWidth/3 ,
                            //height: blockSizeVertical * 10,
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: safeBlockHorizontal * 4.5,//16,
                                color: ThemeChanger.reversetextColor,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          // description
                          Container(
                            margin: EdgeInsets.only(left:  blockSizeHorizontal * 2,top: blockSizeVertical * 0.5),
                            width: blockSizeHorizontal * 50,//displayWidth/3 ,
                            child: Text(
                              description,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: safeBlockHorizontal * 3.5,
                                color: ThemeChanger.reversetextColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          )
                        ],),
                      Column(
                          children:[
                            //old price
                            Container(
                              margin: EdgeInsets.only(left:  blockSizeHorizontal * 2),
                              width: blockSizeHorizontal * 50,
                              child: Text(
                                prevpreis.toStringAsFixed(2) + "€",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: safeBlockHorizontal * 4.0,
                                    color: ThemeChanger.reversetextColor),
                              ),
                            ),
                            //Price
                            Container(
                              margin: EdgeInsets.only(bottom: blockSizeVertical*1, left:  blockSizeHorizontal * 2),
                              //padding: EdgeInsets.only(top: blockSizeVertical * 3),
                              //margin: EdgeInsets.only(bottom: blockSizeVertical*0.2),
                              width: blockSizeHorizontal * 50,
                              child:
                              Text(
                                newprice.toStringAsFixed(2) + "€",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: safeBlockHorizontal * 6.0,//16,
                                  color: ThemeChanger.highlightedColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ])
                    ]),
                //icon
                Container(
                  //margin: EdgeInsets.only(bottom: blockSizeVertical*5),
                  width: blockSizeHorizontal * 60,//displayWidth / 3 -35,
                  child:
                  // Favourite Icon
                  Align(
                    child:
                    IconButton(
                      iconSize: 30.0,
                      icon: (callback.isFavorite(id) ?
                      Icon(Icons.favorite, color: Colors.red) :
                      Icon(Icons.favorite_border, color: ThemeChanger.reversetextColor)),
                      onPressed: _changeFavoriteState,
                    ),
                    alignment: Alignment.centerRight,
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  Future _changeFavoriteState() async {
    //await callback.changeFavoriteState(this);
    FavFunctions.changeFavoriteState(this, callback);
  }
}













