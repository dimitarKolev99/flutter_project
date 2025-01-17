import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/services/product_controller.dart';
import 'package:penny_pincher/services/product_api.dart';

import '../theme.dart';



class ArticleCard extends StatelessWidget {
  late final int id;
  late final String title;
  late final String saving;
  late final String price;
  late final String previousPrice;
  late final String image;
  late final String description;
  late final String category;
  late dynamic callback;
  Product product;
  var isWeb = false;



  /*
  Widget titleSection = Container(
    padding: const EdgeInsets.all(32),
    child: Row(
      children: [
        Expanded(
            child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    "title",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
        ),
        IconButton(
          color: Colors.red[500],
          onPressed: () {},
          icon: Icon(Icons.favorite),
        ),
      ],
    ),
  );


   */



  ArticleCard(this.product, this.callback){
    this.title = product.title;
    //this.saving = product.saving;
    this.price = product.price.toString();
    //this.previousPrice = product.previousPrice;
    this.image = product.image;
    // this.image = product.smallImage;
    this.description = product.description;
    this.category = product.category;
    this.id = product.id;
  }


  @override
  Widget build(BuildContext context) {
    // double newprice = int.parse(price).toDouble()/100;
    // int x = 100 - int.parse(saving).toInt();
    // double prevpreis = newprice/x * 100;


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

     Widget iconButton = IconButton(
      color: Colors.red[500],
      onPressed: () { _changeFavoriteState(); },
      icon: Icon(Icons.favorite),
    );


    //BAD Code: make a class Responsive instead
    if (displayWidth > 412) {
      isWeb = true;
    } else  {
      isWeb = false;
    }

    //

    /*
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
                    //color: Colors.purple,
                    //width: blockSizeHorizontal / 10,//displayWidth/3 - 20,
                    //height: blockSizeVertical * 15,
                    margin: EdgeInsets.only(left: blockSizeHorizontal * 3),//(left: 10),
                    child:
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child:
                        Image(image: AssetImage('pictures/htw_logo.jpg'),
                          fit: BoxFit.contain,
                          width: blockSizeHorizontal*30,
                        ),
                          /*
                      Image.network(
                        image,
                        //width: blockSizeHorizontal * 50,//displayWidth / 3 - 30,
                        //height: blockSizeHorizontal * 50,//displayWidth / 3 - 30,
                        fit: BoxFit.contain,
                        width: blockSizeHorizontal*30,
                      ),

                           */
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
                  Text("-" + saving,
                    style: TextStyle(
                      color: ThemeChanger.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: safeBlockHorizontal * 4,
                    ),
                  ),
                  )
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
                              title,
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
                          Container(
                            margin: EdgeInsets.only(left:  blockSizeHorizontal * 2,top: blockSizeVertical * 0.5),
                            width: blockSizeHorizontal * 45,//displayWidth/3 ,
                            child: Text(
                              description,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: safeBlockHorizontal * 3.25,
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
                              width: blockSizeHorizontal * 45,
                              child: Text(
                                previousPrice,//prevpreis.toStringAsFixed(2) + "€",
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
                                price,//.toStringAsFixed(2) + "€",
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
                      icon: (ProductController.isFavorite(id) ?  //
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

     */

    return Container(
      margin: EdgeInsets.symmetric(horizontal: blockSizeHorizontal * 3, vertical: blockSizeVertical * 0.5),
      height: blockSizeVertical * 45,
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
          Image.network(
            image,
            fit: BoxFit.contain,
            width: displayWidth / 2,
            height: 200,
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
                              fontSize: safeBlockHorizontal * 1,//16,
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
                  onPressed: () => _changeFavoriteState(),
                ),
              ],
            ),
          ),
          //IconSection(_changeFavoriteState(), title),
        ],
      ),
    );


  }



  Future _changeFavoriteState() async {
    //await callback.changeFavoriteState(this);
    ProductController.changeFavoriteState(this, callback);
  }


}

class IconSection extends StatelessWidget {
  dynamic method;
  late String title;
  IconSection(method, title) {
    this.method = method;
    this.title = title;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
          ),
          IconButton(
            color: Colors.red[500],
            onPressed: () {},
            icon: Icon(Icons.favorite),
          ),
        ],
      ),
    );

  }
}












