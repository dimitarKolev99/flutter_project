import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrowserArticleCard extends StatelessWidget {
  final String title;
  final String rating = "40";
  final double price;
  final String image;
  final String description;
  final String category;

  BrowserArticleCard({
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
  });
  @override
  Widget build(BuildContext context) {
    final displayWidth =  MediaQuery.of(context).size.width;
    final displayHeight =  MediaQuery.of(context).size.height;
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [ // Picture + Rating / Discount%
            Align(
              child: // Product Image
              Container(
                margin: EdgeInsets.only(top: 5),
                child:
                ClipRRect(
                  child:
                  Image.network(
                    image,
                    width: displayWidth/4,
                    height: displayWidth/4,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              alignment: Alignment.topCenter,
            ),
            Container( // title
              margin: EdgeInsets.only(bottom: 40),
              width: displayWidth/3,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              alignment: Alignment.topCenter,
            ),
            Container(
                //margin: EdgeInsets.only(bottom: 20),
                //padding: EdgeInsets.only(bottom: 20),
                width: displayWidth/2.5,
                child:
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Favourite Icon
                    Container(
                      child:
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child:
                        //TODO: adjust to clickable Icon
                        Icon(Icons.favorite_border),
                      ),
                      alignment: Alignment.centerRight,
                    ),
                    // % Badge
                    Container(
                      //margin: EdgeInsets.only(bottom: 100),
                      //padding: EdgeInsets.only(top: 3, bottom: 3, left: 10, right: 17),
                      decoration: BoxDecoration(color: Color.fromRGBO(220, 110, 30, 1),  // const Color.fromRGBO(23, 41, 111, 0.8),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child:
                      Text("-" + rating+ "%",
                        style: TextStyle(
                          color: Color.fromRGBO(240, 240, 240, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    // current Price...
                    Container(
                      //margin: EdgeInsets.only(right: 10, bottom: 0),
                      child:
                      Column(
                          children: [
                            const Text(
                              "Current Price:",
                              style: TextStyle(
                                  fontWeight: FontWeight
                                      .bold,
                                  fontSize: 10,
                                  color: Colors
                                      .black),
                            ),
                            Text(
                              price.toString() + " €",
                              style: const TextStyle(
                                fontWeight: FontWeight
                                    .bold,
                                fontSize: 20,
                                color: Color
                                    .fromRGBO(
                                    220, 110, 30,
                                    1),),
                            ),
                            const Text(
                              //ToDO: add previous price
                              "Previously 9.99€",
                              style: TextStyle(
                                  fontSize: 8,
                                  color: Colors
                                      .black),
                            ),
                          ]
                      ),
                    ),
                  ],
                )
            ),
          ],
        )
    );
  }
}