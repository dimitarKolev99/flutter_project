import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/services/fav_functions.dart';
import 'package:penny_pincher/services/product_api.dart';

import '../theme.dart';
import 'article_card.dart';

class BrowserArticleCard extends StatelessWidget {
  final int id;
  final String title;
  final int saving;
  final double price;
  final String image;
  final String description;
  final String category;
  dynamic callback;

  BrowserArticleCard({
    required this.id,
    required this.title,
    required this.saving,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
    required this.callback,
  });
  @override
  Widget build(BuildContext context) {
    double newprice = price/100;
    int x = 100 - saving;
    double prevpreis = newprice/x * 100;

    MediaQueryData _mediaQueryData = MediaQuery.of(context);;
    double displayWidth = _mediaQueryData.size.width;
    double displayHeight = _mediaQueryData.size.height;
    double blockSizeHorizontal = displayWidth / 100; // screen width in 1%
    double blockSizeVertical = displayHeight / 100; // screen height in 1%

    double _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right; // padding left-right
    double _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom; // padding top-bottom
    double safeBlockHorizontal = (displayWidth - _safeAreaHorizontal) / 100;
    double safeBlockVertical = (displayHeight - _safeAreaVertical) / 100;

    return Container(
      // card itself
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: ThemeChanger.articlecardbackground,
        borderRadius: BorderRadius.circular(3),
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
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              //image + fav icon
              Stack(
                children: [
                  //Image
                  Align(
                    child:
                    Container(
                      margin: EdgeInsets.only(top: blockSizeVertical*1),
                      //width: blockSizeHorizontal * 33.33, //width: blockSizeHorizontal * 33.33,
                      //height: blockSizeVertical * 16.67, //height: blockSizeVertical * 16.67,
                      child:
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child:
                        Image.network(
                          image,
                          width: blockSizeHorizontal * 33.33,
                          fit: BoxFit.fill,
                        ),
                      ),
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  // %Badge
                  Container(
                    margin: EdgeInsets.only(top: blockSizeVertical*0.8),
                    //padding: EdgeInsets.only(top: 3, bottom: 3, left: 10, right: 17),
                    padding: EdgeInsets.only(top: blockSizeVertical * 0.5, bottom: blockSizeVertical * 0.5, left: blockSizeHorizontal *1, right: blockSizeHorizontal * 1),//(top: 3, bottom: 3, left: 10, right: 17),
                    decoration: BoxDecoration(
                      color: ThemeChanger.highlightedColor, // const Color.fromRGBO(23, 41, 111, 0.8),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Text(
                      " -" + saving.toString() + "% ",
                      style: TextStyle(
                        color: ThemeChanger.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: safeBlockHorizontal * 4,
                      ),
                    ),
                  ),
                  //Favorite icon
                  Container(
                    padding: EdgeInsets.only(top: blockSizeVertical*1.3, right: blockSizeHorizontal*2.2),
                    width: blockSizeHorizontal * 60,//displayWidth / 3 -35,
                    child:
                    // Favourite Icon
                    Align(
                      child:
                      Icon(
                        Icons.favorite,
                        color: ThemeChanger.articlecardbackground,
                        size: 29.0,
                      ),
                      alignment: Alignment.centerRight,
                    ),
                  ),
                  Container(
                    //margin: EdgeInsets.only(bottom: blockSizeVertical*5),
                    width: blockSizeHorizontal * 60,//displayWidth / 3 -35,
                    child:
                    // Favourite Icon
                    Align(
                      child:
                      IconButton(
                        iconSize: 30.0,
                        icon: (FavFunctions.isFavorite(id) ?
                        Icon(Icons.favorite, color: Colors.red) :
                        Icon(Icons.favorite_border, color: ThemeChanger.reversetextColor)),
                        onPressed: _changeFavorite,
                      ),
                      alignment: Alignment.centerRight,
                    ),
                  ),
                ],
              ),
              // title
              Container(
                margin: EdgeInsets.only(top: blockSizeVertical*1),
                width: blockSizeVertical*22.5,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: safeBlockHorizontal * 4.5,//16,
                    color: ThemeChanger.reversetextColor,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                alignment: Alignment.topCenter,
              ),
              Container(
                margin: EdgeInsets.only(top: blockSizeVertical * 0.5),
                width: blockSizeVertical*22.5,
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: safeBlockHorizontal * 3.25,//16,
                    color: ThemeChanger.reversetextColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ]),
            //price
            Container(
              margin: EdgeInsets.only(bottom: blockSizeVertical*0.5),
              child: Column(children: [
                //oldprice
                Text(
                  prevpreis.toStringAsFixed(2) + "€",
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontSize: safeBlockHorizontal * 3.25,
                      color: ThemeChanger.reversetextColor),
                ),
                //newprice
                Text(
                  newprice.toStringAsFixed(2) + "€",
                  style: TextStyle(
                    fontSize: safeBlockHorizontal * 6.0,//16,
                    color: ThemeChanger.highlightedColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
              //alignment: Alignment.bottomCenter,
            ),
          ],
        ),
      ),
    );
  }

  Future _changeFavorite() async {
    ArticleCard articleCard = ArticleCard(
      id: id,
      title: title,
      saving: saving,
      category: category,
      description: description,
      image: image,
      price:price,
      callback: callback,);
    await FavFunctions.changeFavoriteState(articleCard, articleCard.callback);
  }
}