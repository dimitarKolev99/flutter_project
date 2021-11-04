import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExtendedView extends StatelessWidget {
  final String title;
  final String rating = "30";
  final double price;
  final String image;
  final String description;
  final String category;

  ExtendedView({
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
                //margin: EdgeInsets.symmetric(vertical: 10),
                width: displayWidth,
                height: displayHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: Image.network(
                          image,
                          width: displayWidth * 0.6,
                          //height: displayWidth / 3 - 30,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Container(
                            width: displayWidth / 2,
                            height: displayHeight / 4,
                            color: Colors.blue,
                            child: Text(
                              title,
                              textAlign: TextAlign.left,
                              style: TextStyle(),
                            ),
                          ),
                          Column(children: [
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
                              style:
                                  TextStyle(fontSize: 8, color: Colors.black),
                            ),
                          ]),
                        ],
                      )
                    ]))));
  }
}
