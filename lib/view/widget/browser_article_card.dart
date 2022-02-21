import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/services/product_controller.dart';
import 'package:penny_pincher/services/product_api.dart';

import '../theme.dart';
import 'article_card.dart';

class BrowserArticleCard extends StatelessWidget {
  late final int id;
  late final String title;
  late final String saving;
  late final String price;
  late final String image;
  late final String description;
  late final String category;
  dynamic callback;
  Product product;

  BrowserArticleCard(this.product, this.callback){
    this.id = product.id;
    this.title = product.title;
    // this.saving = product.saving;
    this.price = product.price.toString();
    this.image = product.image;
    this.description = product.description;
    this.category = product.category;
  }

  @override
  Widget build(BuildContext context) {

/*

    double newprice = int.parse(price).toDouble()/100;
    int x = 100 - int.parse(saving);
    double prevpreis = newprice/x * 100;


 */
    MediaQueryData _mediaQueryData = MediaQuery.of(context);;
    double displayWidth = _mediaQueryData.size.width;
    double displayHeight = _mediaQueryData.size.height;
    double blockSizeHorizontal = displayWidth / 100; // screen width in 1%
    double blockSizeVertical = displayHeight / 100; // screen height in 1%

    double _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right; // padding left-right
    double _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom; // padding top-bottom
    double safeBlockHorizontal = (displayWidth - _safeAreaHorizontal) / 100;
    double safeBlockVertical = (displayHeight - _safeAreaVertical) / 100;

    /*
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
                        Image.asset(
                          'pictures/htw_logo.jpg',
                          width: 400 ,
                          height: 400,
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
                        fontSize: safeBlockHorizontal * 1.5,
                      ),
                    ),
                  ),
                  //Favorite icon

                  Align(
                    alignment: Alignment.topRight,
                    child:
                    Container(
                      //color: Colors.redAccent,
                      padding: EdgeInsets.all(9),
                      //width: blockSizeHorizontal * 60,//displayWidth / 3 -35,
                      child:
                      // Favourite Icon
                      Icon(
                        Icons.favorite,
                        color: ThemeChanger.articlecardbackground,
                        size: 30.0,
                      ),
                    ),
                  ),
                  Align(
                  alignment: Alignment.topRight,
                  child:
                        Container(
                          //color: Colors.green,
                          padding: EdgeInsets.zero,
                          //margin: EdgeInsets.only(bottom: blockSizeVertical*5),
                          //width: blockSizeHorizontal * 60,//displayWidth / 3 -35,
                          child:
                          // Favourite Icon
                          IconButton(
                            iconSize: 30.0,
                            icon: (ProductController.isFavorite(id) ?
                            Icon(Icons.favorite, color: Colors.red) :
                            Icon(Icons.favorite_border, color: ThemeChanger.reversetextColor)),
                            onPressed: _changeFavorite,
                          ),


                        ),),
                      ],





              ),
              // title
              Container(
                margin: EdgeInsets.only(top: blockSizeVertical*1),
                width: blockSizeVertical*2,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: safeBlockHorizontal * 1.5,//16,
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
                width: blockSizeVertical*2,
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: safeBlockHorizontal * 1.5,//16,
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
                      fontSize: safeBlockHorizontal * 1.5,
                      color: ThemeChanger.reversetextColor),
                ),
                //newprice
                Text(
                  newprice.toStringAsFixed(2) + "€",
                  style: TextStyle(
                    fontSize: safeBlockHorizontal * 2,//16,
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

     */


    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      //height: blockSizeVertical * 45,
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
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              image,
              width: displayWidth / 4,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(32),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: safeBlockHorizontal * 1.5,//16,
                              color: ThemeChanger.reversetextColor,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    )
                ),
                IconButton(
                  iconSize: 30.0,
                  icon: (ProductController.isFavorite(id) ?  //
                  Icon(Icons.favorite, color: Colors.red) :
                  Icon(Icons.favorite_border, color: ThemeChanger.reversetextColor)),
                  onPressed: () => _changeFavorite(),
                ),
              ],
            ),
          ),
          //IconSection(_changeFavoriteState(), title),
        ],
      ),
    );
  }

  Future _changeFavorite() async {
    ArticleCard articleCard = ArticleCard(product, callback);
    await ProductController.changeFavoriteState(articleCard, articleCard.callback);
  }
}