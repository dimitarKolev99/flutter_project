import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penny_pincher/services/fav_functions.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/view/widget/app_bar_navigator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'theme.dart';
import 'widget/article_card.dart';

class ExtendedView extends StatefulWidget {
  final int id;
  final String title;
  final int saving;
  final double price;
  final String image;
  final String description;
  final String category;
  final Stream<bool> stream;
  final dynamic callback;

  ExtendedView({
    required this.id,
    required this.title,
    required this.saving,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
    required this.stream,
    required this.callback,
  });

  @override
  State<ExtendedView> createState() => _ExtendedViewState();
}

class _ExtendedViewState extends State<ExtendedView> {

  @override
  void initState() {
    super.initState();
    widget.stream.listen((update) {
      updateExtendedView(update);
    });
  }

  updateExtendedView(bool update) {
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double newprice = widget.price / 100;
    int x = 100 - widget.saving;
    double prevpreis = newprice / x * 100;

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

    return Scaffold(
        appBar: const ExtendedViewAppBar(),
        body: SingleChildScrollView(
          // this will make your body scrollable

            child: Container(

                alignment: Alignment.topLeft,
                margin: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                width: displayWidth,
                //height: displayHeight,
                decoration: BoxDecoration( color: ThemeChanger.articlecardbackground,
                    // borderRadius: BorderRadius.circular(15),
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
                    ]),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // SizedBox(height: 20),
                      // Picture, % Badge , Fav Icon

                      ///Title
                      Container(
                        //color: Colors.yellow,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: blockSizeHorizontal * 2),
                        child: Text(
                            widget.title,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: safeBlockHorizontal * 6,
                                color: Colors.black,
                              ),
                            )
                        ),
                      ),
                      SizedBox(height: blockSizeVertical * 1),

                      ///Price,Savings and Heart Icon
                      ///Current Price
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: blockSizeHorizontal * 70,//blockSizeHorizontal * 60,//150,
                              decoration: BoxDecoration(
                                //color: ProductApi.darkBlue,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(5))),
                              margin: EdgeInsets.only(left: blockSizeHorizontal * 2),
                              child: Text(
                                newprice.toStringAsFixed(2) + " €",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: safeBlockHorizontal * 9,
                                  color: ThemeChanger.highlightedColor,
                                ),
                              ),
                            ),

                            ///Discount Label
                            Container(
                                decoration: BoxDecoration(
                                  color: ThemeChanger.highlightedColor,
                                  // const Color.fromRGBO(23, 41, 111, 0.8),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 3, bottom: 3, left: 13, right: 10),
                                  child: Text(
                                    "-" + widget.saving.toString() + "%",
                                    style: TextStyle(
                                      color: ThemeChanger.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: safeBlockHorizontal * 6.5,
                                      letterSpacing: 1.4,
                                    ),
                                  ),
                                )),
                          ]
                      ),

                      ///Previose Price
                      Row(
                        children: [
                          Container(
                            width: blockSizeHorizontal * 70,
                            decoration: BoxDecoration(
                              //color: ProductApi.darkBlue,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(5)),
                            ),
                            margin: EdgeInsets.only(left: blockSizeHorizontal * 3),
                            child: Text(
                              prevpreis.toStringAsFixed(2) + "€",
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: safeBlockHorizontal * 5.0,
                                  color: ThemeChanger.navBarColor),
                            ),
                          )
                        ],
                      ),
                      /*IconButton(
                           icon: (widget.callback.isFavorite(widget.id)
                               ? const Icon(Icons.favorite,
                               color: Colors.red)
                               : const Icon(Icons.favorite_border,
                               color: Colors.black)),
                           onPressed: _changeFavoriteState,
                         ),
                          */
                      ///IMAGE
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          //color: Colors.grey,
                            child: Image.network(
                              widget.image,
                              width: displayWidth * 0.6,
                              height: displayWidth * 0.6,
                              fit: BoxFit.contain,
                            )
                        ),
                      ),
                      SizedBox(height: blockSizeVertical * 1),

                      ///Categories
                      Container(
                        //alignment: Alignment.topLeft,// category
                        margin:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: ThemeChanger.lightBlue, //ProductApi.lightBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        //width: displayWidth,
                        //height: displayHeight / 4,
                        child: Text(
                          widget.category,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: ThemeChanger.textColor,
                              fontSize: safeBlockHorizontal * 3.3
                          ),
                        ),
                      ),


                      /// Description
                      Container(
                        //color: Colors.purple,
                        // description
                        margin:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        //width: displayWidth,
                        //height: displayHeight / 4,
                        child: Text(
                          widget.description,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: safeBlockHorizontal * 3,
                          color: ThemeChanger.reversetextColor,
                        ),
                      )
                        ),
                      ),

                      /*
                      blockSizeHorizontal = displayWidth / 100;
                      blockSizeVertical = displayHeight / 100;
                       */
                      SizedBox(height: blockSizeVertical * 0.5),
                      Container(
                          height: blockSizeVertical * 10,
                          width: blockSizeHorizontal * 100,
                          //color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: blockSizeHorizontal * 2),
                                width: blockSizeHorizontal * 81.5,
                                height: blockSizeVertical * 8,
                                child: TextButton(
                                    onPressed: _launchURL,
                                    child: Text(
                                      "Zum Angebot",
                                      style: TextStyle(
                                        fontSize: safeBlockHorizontal * 5,
                                        color: ThemeChanger.textColor,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      //fontWeight: FontWeight.bold,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: blockSizeHorizontal * 20, vertical: blockSizeVertical * 1),  //TODO: make it responsive
                                      backgroundColor: ThemeChanger.lightBlue,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: ThemeChanger.navBarColor,
                                              width: 2,
                                              style: BorderStyle.solid),
                                          borderRadius:
                                          BorderRadius.circular(5)),
                                    )

                                ),
                              ),
                              Container(
                                height: blockSizeVertical * 7.9,
                                //margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: ThemeChanger.navBarColor, width: 2, style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(5),

                                  color: ThemeChanger.lightBlue,
                                ),
                                child: IconButton(
                                  iconSize: safeBlockHorizontal * 7,
                                  icon: (FavFunctions.isFavorite(widget.id)
                                      ? const Icon(Icons.favorite,
                                      color: Colors.red)
                                      : const Icon(Icons.favorite_border,
                                      color: Colors.white)),
                                  onPressed: _changeFavoriteState,
                                ),
                              )
                            ],
                          ),
                        ),
                    ]
                )
            )
        )
    );
  }

  Future _changeFavoriteState() async {
    ArticleCard articleCard = ArticleCard(
      id: widget.id,
      title: widget.title,
      saving: widget.saving,
      category: widget.category,
      description: widget.description,
      image: widget.image,
      price: widget.price,
      callback: widget.callback,
    );

    FavFunctions.changeFavoriteState(articleCard, this);
    articleCard.callback.updateBrowser();
  }

  // creating specific URL and launching it from available browser apps
  _launchURL() async {
    String url = 'https://www.idealo.de/preisvergleich/OffersOfProduct/' +
        widget.id.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}