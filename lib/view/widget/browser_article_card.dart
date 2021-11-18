import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/services/product_api.dart';

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
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
                  Container(
                    margin: EdgeInsets.only(top: blockSizeVertical*1),
                    child: Image.network(
                      image,
                      width: blockSizeHorizontal * 33.33,
                      height: blockSizeVertical * 16.67,
                      fit: BoxFit.contain,
                    ),
                    alignment: Alignment.topCenter,
                  ),
                  // %Badge
                  Container(
                    margin: EdgeInsets.only(top: blockSizeVertical*0.8, left: blockSizeHorizontal*1),
                    //padding: EdgeInsets.only(top: 3, bottom: 3, left: 10, right: 17),
                    decoration: BoxDecoration(
                      color: ProductApi.orange, // const Color.fromRGBO(23, 41, 111, 0.8),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Text(
                      " -" + saving.toString() + "% ",
                      style: TextStyle(
                        color: ProductApi.white,
                        fontWeight: FontWeight.bold,
                        fontSize: safeBlockHorizontal * 4.5,
                      ),
                    ),
                  ),
                  //Favorite icon
                  Container(
                    margin: EdgeInsets.only(top: blockSizeVertical*0.1, right: blockSizeHorizontal*0.1),
                    child: Align(
                      child: IconButton(
                        icon: (callback.isFavorite(id)
                            ? const Icon(Icons.favorite,
                            color: Colors.red)
                            : const Icon(Icons.favorite_border,
                            color: Colors.black)),
                        onPressed: _changeFavorite,
                      ),
                      alignment: Alignment.topRight,
                    ),
                  ),
                ],
              ),
              // title
              Container(
                margin: EdgeInsets.only(top: blockSizeVertical*0.1),
                width: blockSizeVertical*20,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: safeBlockHorizontal * 4,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                alignment: Alignment.topCenter,
              ),
            ]),
            //price
            Container(
              margin: EdgeInsets.only(bottom: blockSizeVertical*0.2),
              child: Column(children: [
                Text(
                  prevpreis.toStringAsFixed(2) + "€",
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontSize: safeBlockHorizontal * 4, color: Colors.black
                  ),
                ),
                Text(
                  newprice.toStringAsFixed(2) + "€",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: safeBlockHorizontal * 7,
                    color: ProductApi.orange,
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
    await callback.changeFavoriteState(articleCard);
  }
}