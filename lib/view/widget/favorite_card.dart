import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/view/widget/article_card.dart';

import '../favorites.dart';

class FavoriteCard extends StatelessWidget {
  final int id;
  final int index;
  final String title;
  final int saving;
  final String rating = "30";
  final double price;
  final String image;
  final String description;
  final String category;
  dynamic callback;

  FavoriteCard({
    required this.id,
    required this.index,
    required this.saving,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
    required this.callback,
  });
  @override
  Widget build(BuildContext context) {
    final displayWidth = MediaQuery.of(context).size.width;
    final displayHeight = MediaQuery.of(context).size.height;
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        width: displayWidth,
        height: displayHeight / 5 - 1,
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
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Picture + Rating / Discount%
            Align(
              child:
                  // Product Image
                  Container(
                width: displayWidth / 3 - 20,
                margin: EdgeInsets.only(left: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    image,
                    width: displayWidth / 3 - 30,
                    height: displayWidth / 3 - 30,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              alignment: Alignment.centerLeft,
            ),

            Container(
              // title
              margin: EdgeInsets.only(left: 4, right: 4, top: 20),
              width: displayWidth / 3,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
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
                width: displayWidth / 3 - 35,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Favourite Icon
                    Align(
                      child: Padding(
                        padding: EdgeInsets.only(right: 7),
                        child: IconButton(
                          icon: Icon(Icons.favorite, color: Colors.red),
                          onPressed: _changeFavoriteState,
                        ),
                      ),
                      alignment: Alignment.centerRight,
                    ),
                    Container(
                      // % Badge
                      padding: EdgeInsets.only(
                          top: 3, bottom: 3, left: 10, right: 17),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(220, 110, 30,
                            1), // const Color.fromRGBO(23, 41, 111, 0.8),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Text(
                        "-" + rating + "%",
                        style: TextStyle(
                          color: Color.fromRGBO(240, 240, 240, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    // current Price...
                    Container(
                      margin: EdgeInsets.only(right: 10, bottom: 0),
                      child: Column(children: [
                        const Text(
                          "Current Price:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.black),
                        ),
                        Text(
                          price.toString() + " €",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromRGBO(220, 110, 30, 1),
                          ),
                        ),
                        const Text(
                          //ToDO: add previous price
                          "Previously 9.99€",
                          style: TextStyle(fontSize: 8, color: Colors.black),
                        ),
                      ]),
                    ),
                  ],
                )),
          ],
        ));
  }

  Future _changeFavoriteState() async {
    ArticleCard articleCard = ArticleCard(
      id: id,
      title: title,
      saving: saving,
      category: category,
      description: description,
      image: image,
      price: price,
      callback: callback,
    );
    await callback.changeFavoriteState(articleCard);
  }
}
