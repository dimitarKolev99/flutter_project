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
    final displayWidth = MediaQuery.of(context).size.width;
    final displayHeight = MediaQuery.of(context).size.height;
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
                    margin: EdgeInsets.only(top: 10),
                    child: Image.network(
                      image,
                      width: displayWidth / 3,
                      height: displayHeight / 6,
                      fit: BoxFit.contain,
                    ),
                    alignment: Alignment.topCenter,
                  ),
                  // %Badge
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 5),
                    //padding: EdgeInsets.only(top: 3, bottom: 3, left: 10, right: 17),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(220, 110, 30, 1), // const Color.fromRGBO(23, 41, 111, 0.8),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Text(
                      " -" + rating + "% ",
                      style: TextStyle(
                        color: Color.fromRGBO(240, 240, 240, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  //Favorite icon
                  Container(
                    margin: EdgeInsets.only(top: 5, right: 5),
                    child: Align(
                      child: Icon(
                        Icons.favorite_border,
                        size: 32.0,
                      ),
                      alignment: Alignment.topRight,
                    ),
                  ),
                ],
              ),
              // title
              Container(
                margin: EdgeInsets.only(top: 5),
                width: displayWidth / 2.5,
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
            ]),
            //price
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Column(children: [
                Text(
                  //ToDO: add previous price
                  "Previously  1" + price.toString() + "€",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                Text(
                  price.toString() + "€",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color.fromRGBO(220, 110, 30, 1),
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
}