import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                      " -" + saving.toString() + "% ",
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
                  "Previously  " + price.toString() + "€",
                  style: TextStyle(fontSize: 11, color: Colors.black),
                ),
                Text(
                  newprice.toStringAsFixed(2) + "€",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
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