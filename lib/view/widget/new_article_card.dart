import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/models/ws_product.dart';
import 'package:penny_pincher/services/product_controller.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/services/product_controller_ws.dart';

import '../theme.dart';



class NewArticleCard extends StatelessWidget {
  late final int productId;
  late final int siteId;
  late final DateTime date;
  late final String currentPrice;
  late final String previousPrice;
  late final String dropPercentage;
  late final String productName;
  late final String productImageUrl;
  late final String productPageUrl;
  late final int categoryId;
  late dynamic callback;
  ProductWS productWS;



  NewArticleCard(this.productWS, this.callback){
    this.productName = productWS.productName;
    this.dropPercentage = productWS.dropPercentage;
    this.currentPrice = productWS.currentPrice;
    this.productImageUrl = productWS.productImageUrl;
    //this.description = productWS.description;
    this.previousPrice = productWS.previousPrice;
    this.categoryId = productWS.categoryId;
    this.productId = productWS.productId;
  }



  @override
  Widget build(BuildContext context) {
    //double newprice = currentPrice/100;
    //int x = 100 - currentPrice as int;
    //double prevpreis = newprice/x * 100;

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
        child:
        Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Picture + Discount%
            Stack(
                children:[
                  // Product Image
                  Container(
                    width: blockSizeHorizontal * 30,//displayWidth/3 - 20,
                    height: blockSizeVertical * 15,
                    margin: EdgeInsets.only(left: blockSizeHorizontal * 3),//(left: 10),
                    child:
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child:
                      Image.network(
                        productImageUrl,
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
                    decoration: BoxDecoration(
                      color: ThemeChanger.highlightedColor,  // const Color.fromRGBO(23, 41, 111, 0.8),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child:
                    Text("-" + dropPercentage.toString(),
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
                            width: blockSizeHorizontal * 45,//displayWidth/3 ,
                            //height: blockSizeVertical * 10,
                            child: Text(
                              productName,
                              style: TextStyle(
                                fontSize: safeBlockHorizontal * 4.5,//16,
                                color: ThemeChanger.reversetextColor,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          // description
                        ],),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            //old price
                            Container(
                              margin: EdgeInsets.only(left:  blockSizeHorizontal * 2),
                              width: blockSizeHorizontal * 45,
                              child: Text(
                                previousPrice,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: safeBlockHorizontal * 3.25,
                                    color: ThemeChanger.reversetextColor),
                              ),
                            ),
                            //Price
                            Container(
                              margin: EdgeInsets.only(bottom: blockSizeVertical*1, left:  blockSizeHorizontal * 2),
                              //padding: EdgeInsets.only(top: blockSizeVertical * 3),
                              //margin: EdgeInsets.only(bottom: blockSizeVertical*0.2),
                              width: blockSizeHorizontal * 45,
                              child:
                              Text(
                                currentPrice,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: safeBlockHorizontal * 6.0,//16,
                                  color: ThemeChanger.highlightedColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ]
                      )

                    ]
                ),
                //icon
                Container(
                  //margin: EdgeInsets.only(bottom: blockSizeVertical*5),
                  width: blockSizeHorizontal * 60,//displayWidth / 3 -35,
                  child:
                  // Favourite Icon
                  Align(
                    child:
                    Icon(Icons.favorite, color: ThemeChanger.articlecardbackground),
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
                      icon: (ProductControllerWS.isFavoriteWS(productId) ?
                      Icon(Icons.favorite, color: Colors.red) :
                      Icon(Icons.favorite_border, color: ThemeChanger.reversetextColor)),
                      onPressed: () {
                        _changeFavoriteStateWS();
                      }//_changeFavoriteState,

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

  Future _changeFavoriteStateWS() async {
    //await callback.changeFavoriteState(this);
    print("WE ARE IN _changeFavoriteStateWS");
    ProductControllerWS.changeFavoriteStateWS(this, callback);
  }
}













