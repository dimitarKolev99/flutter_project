import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExtendedView extends StatelessWidget {
  final String title;
  final String rating = "30";
  final double price;
  final String image;
  final String description;
  final String category;
  //final String pay = "toOffer";

  ExtendedView({
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
    //required this.pay,
  });

  @override
  Widget build(BuildContext context) {
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
                margin:  EdgeInsets.symmetric(horizontal: 14, vertical: 5),
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
                  ]
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                                                                                // Picture, % Badge , Fav Icon
                      Stack(
                        children: [
                          Center(
                            child: Image.network(
                              image,
                              width: displayWidth * 0.6,
                              height: displayWidth * 0.6,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Align(
                            child: Padding(
                              padding: EdgeInsets.only(right: 7),
                              child:
                              //TODO: adjust to clickable Icon
                              Icon(Icons.favorite_border,
                              size: 33,),
                            ),
                            alignment: Alignment.centerRight,
                          ),
                          SizedBox(height: 10),

                          Container(                                                      // % Badge
                            padding: EdgeInsets.only(top: 3, bottom: 3, left: 13, right: 10),
                            decoration: BoxDecoration(color: Color.fromRGBO(220, 110, 30, 1),  // const Color.fromRGBO(23, 41, 111, 0.8),
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child:
                            Text("-" + rating+ "%",
                              style: TextStyle(
                                color: Color.fromRGBO(240, 240, 240, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                letterSpacing: 1.4,
                              ),
                            ),
                          ),


                        ]
                      ),
                      SizedBox(height: 5),
                      Container(
                        //alignment: Alignment.topLeft,// category
                        margin:  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: const Color.fromRGBO(23, 41, 111, 0.8),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        //width: displayWidth,
                        //height: displayHeight / 4,
                        child: Text(
                          category,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color.fromRGBO(240, 240, 240, 1),
                          ),
                        ),
                      ),
                                                                                                  // title
                      Container(
                        margin:  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        //width: displayWidth,
                        //height: displayHeight / 4,
                        child: Text(
                          title,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      Container(                                                                  // description
                        margin:  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        //width: displayWidth,
                        //height: displayHeight / 4,
                        child: Text(
                          description,
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
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                      color: Color.fromRGBO(23, 41, 111, 1),
                    ),
                  child:
                  Container(
                  margin:  EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child:
                    Row(
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
                                price.toString() + " €",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35,
                                  color: Color.fromRGBO(220, 110, 30, 1),
                                ),
                              ),
                              const Text(
                                //ToDO: add previous price
                                "Previously 9.99€",
                                style:
                                TextStyle(fontSize: 15, color: Color.fromRGBO(240, 240, 240, 1)),
                              ),
                            ]),

                        Container(                                                                  // Pay
                          //margin:  EdgeInsets.symmetric(horizontal: 15, vertical: 5),

                          //width: displayWidth,
                          //height: displayHeight / 4,
                          child: TextButton(

                            onPressed:() {},
                            child: Text("To Offer", style: TextStyle(fontSize: 25, color: Color.fromRGBO(240, 240, 240, 1),),),

                            //textAlign: TextAlign.left,
                            style: TextButton.styleFrom(
                              //fontWeight: FontWeight.bold,
                                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                backgroundColor: Color.fromRGBO(23, 41, 111, 0.5),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                color: Color.fromRGBO(240, 240, 240, 1),
                                width: 2,
                                    style: BorderStyle.solid
                                ), borderRadius: BorderRadius.circular(15)),
                                )
                            ),
                          ),
                      ],
                    ),
                  ),

                ),


                    ]))));
  }
}
