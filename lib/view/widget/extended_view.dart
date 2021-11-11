import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'article_card.dart';

class ExtendedView extends StatefulWidget {
  final int id;
  final String title;
  final int saving;
  final double price;
  final String image;
  final String description;
  final String category;
  dynamic callback;

  ExtendedView({
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
  State<ExtendedView> createState() => _ExtendedViewState();
}

class _ExtendedViewState extends State<ExtendedView> {
  @override
  Widget build(BuildContext context) {
    double newprice = widget.price / 100;
    int x = 100 - widget.saving;
    double prevpreis = newprice / x * 100;
    final displayWidth = MediaQuery.of(context).size.width;
    final displayHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color.fromRGBO(23, 41, 111, 1),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Icon(Icons.restaurant_menu),
                Image.network(
                  "https://cdn.discordapp.com/attachments/899305939109302285/903270501781221426/photopenny.png",
                  width: 40,
                  height: 40,
                ),

                SizedBox(width: 10),
                Text('Penny Pincher')
              ],
            )),
        body: SingleChildScrollView(
            // this will make your body scrollable

            child: Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                width: displayWidth,
                //height: displayHeight,
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
                    ]),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      // Picture, % Badge , Fav Icon
                      Stack(children: [
                        Center(
                          child: Image.network(
                            widget.image,
                            width: displayWidth * 0.6,
                            height: displayWidth * 0.6,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Align(
                          child: Padding(
                            padding: EdgeInsets.only(right: 7),
                            child: IconButton(
                              icon: (widget.callback.isFavorite(widget.id)
                                  ? const Icon(Icons.favorite,
                                      color: Colors.red)
                                  : const Icon(Icons.favorite_border,
                                      color: Colors.black)),
                              onPressed: _changeFavoriteState,
                            ),
                          ),
                          alignment: Alignment.centerRight,
                        ),
                        SizedBox(height: 10),
                        Container(
                          // % Badge
                          padding: EdgeInsets.only(
                              top: 3, bottom: 3, left: 13, right: 10),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(220, 110, 30,
                                1), // const Color.fromRGBO(23, 41, 111, 0.8),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: Text(
                            "-" + widget.saving.toString() + "%",
                            style: TextStyle(
                              color: Color.fromRGBO(240, 240, 240, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ),
                      ]),
                      SizedBox(height: 5),
                      Container(
                        //alignment: Alignment.topLeft,// category
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(23, 41, 111, 0.8),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        //width: displayWidth,
                        //height: displayHeight / 4,
                        child: Text(
                          widget.category,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color.fromRGBO(240, 240, 240, 1),
                          ),
                        ),
                      ),
                      // title
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        //width: displayWidth,
                        //height: displayHeight / 4,
                        child: Text(
                          widget.title,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      Container(
                        // description
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        //width: displayWidth,
                        //height: displayHeight / 4,
                        child: Text(
                          widget.description,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),

                      SizedBox(height: 5),
                      // Price Button - Row
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                          color: Color.fromRGBO(23, 41, 111, 1),
                        ),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Price
                                    /*const Text(
                          "Current Price:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black),
                        ),

                         */
                                    Text(
                                      newprice.toStringAsFixed(2) + " €",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 35,
                                        color: Color.fromRGBO(220, 110, 30, 1),
                                      ),
                                    ),
                                    Text(
                                      //ToDO: add previous price
                                      "Previously " +
                                          prevpreis.toStringAsFixed(2) +
                                          "€",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color:
                                              Color.fromRGBO(240, 240, 240, 1)),
                                    ),
                                  ]),
                              Container(
                                // Pay
                                //margin:  EdgeInsets.symmetric(horizontal: 15, vertical: 5),

                                //width: displayWidth,
                                //height: displayHeight / 4,
                                child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "To Offer",
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: Color.fromRGBO(240, 240, 240, 1),
                                      ),
                                    ),

                                    //textAlign: TextAlign.left,
                                    style: TextButton.styleFrom(
                                      //fontWeight: FontWeight.bold,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 10),
                                      backgroundColor:
                                          Color.fromRGBO(23, 41, 111, 0.5),
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Color.fromRGBO(
                                                  240, 240, 240, 1),
                                              width: 2,
                                              style: BorderStyle.solid),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]))));
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

    if (widget.callback.isFavorite(widget.id)) {
      showAlertDialog();
    } else {
      await widget.callback.addFavorite(articleCard);
      if (mounted) {
        setState(() {});
      }
    }
  }

  showAlertDialog() {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Nein"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = TextButton(
      style: TextButton.styleFrom(
        primary: Colors.red,
      ),
      child: const Text("Ja"),
      onPressed: () async {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        await widget.callback.removeFavorite(widget.id, true);
        if (mounted) {
          setState(() {});
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Artikel entfernen?"),
      content: const Text(
          "Willst du diesen Artikel wirklich aus deinen Favorites entfernen?"),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
