import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penny_pincher/models/ws_product.dart';
import 'package:penny_pincher/view/theme.dart';
import 'package:penny_pincher/view/widget/app_bar_navigator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ExtendenViewWebSocket extends StatefulWidget {
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
  final Stream<bool> stream;
  dynamic callback;
  ProductWS productWs;

  ExtendenViewWebSocket(this.productWs, this.stream, this.callback) {
    productId = productWs.productId;
    siteId = productWs.siteId;
    currentPrice = productWs.currentPrice;
    previousPrice = productWs.previousPrice;
    dropPercentage = productWs.dropPercentage;
    productName = productWs.productName;
    productImageUrl = productWs.productImageUrl;
    productPageUrl = productWs.productPageUrl;
    categoryId = productWs.categoryId;
  }

  @override
  State<ExtendenViewWebSocket> createState() => _ExtendenViewWebSocketState();
}

class _ExtendenViewWebSocketState extends State<ExtendenViewWebSocket> {



  @override
  void initState() {
    super.initState();
    widget.stream.listen((update) {
      updateExtendedViewWebSocket(update);
    });
  }





  updateExtendedViewWebSocket(bool update) {
    if (this.mounted) {
      setState(() {});
    }
  }



  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

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
                        margin: EdgeInsets.only(left: blockSizeHorizontal * 3, top: blockSizeVertical * 1),
                        child: Text(
                            widget.productName,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: safeBlockHorizontal * 6,
                                color: ThemeChanger.reversetextColor,
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
                              margin: EdgeInsets.only(left: blockSizeHorizontal * 3),
                              child: Text(
                                widget.currentPrice,
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
                                    "-" + widget.dropPercentage,
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
                              widget.previousPrice,
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
                              widget.productImageUrl,
                              width: displayWidth * 0.6,
                              height: displayWidth * 0.6,
                              fit: BoxFit.contain,
                            )
                        ),
                      ),
                      SizedBox(height: blockSizeVertical * 1),

                      /*
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
                        //alignment: Alignment.center,
                        margin:
                        EdgeInsets.symmetric(horizontal: blockSizeHorizontal * 2, vertical: blockSizeVertical* 2),
                        //width: displayWidth,
                        //height: displayHeight / 4,
                        child: Text(
                            widget.description,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: safeBlockHorizontal * 3,
                                color: ThemeChanger.reversetextColor,
                              ),
                            )
                        ),
                      ),

                       */

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
                                        horizontal: blockSizeHorizontal * 20, vertical: blockSizeVertical * 1),
                                    backgroundColor: ThemeChanger.lightBlue,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: ThemeChanger.navBarColor,
                                            width: 2,
                                            style: BorderStyle.solid),
                                        borderRadius:
                                        BorderRadius.circular(3)),
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
                                icon: (//ProductController.isFavorite(widget.id)
                                   // ? const Icon(Icons.favorite,
                                   // color: Colors.red)
                                    const Icon(Icons.favorite_border, //:
                                    color: Colors.white)),
                                onPressed: () {} //_changeFavoriteState,
                              ),
                            ),
                            SizedBox(height: blockSizeVertical * 0.5),
                          ],
                        ),
                      ),
                    ]
                )
            )
        )
    );
  }

  // creating specific URL and launching it from available browser apps
  _launchURL() async {
    String url = 'https://www.idealo.de/preisvergleich/OffersOfProduct/' +
        widget.productId.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
