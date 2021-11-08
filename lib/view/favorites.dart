import 'dart:convert';
import 'package:penny_pincher/models/preferences_articles.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/view/widget/favorite_card.dart';
import 'package:penny_pincher/view/widget/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';



class FavoritePage extends StatefulWidget {
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  //late Product _product;

  late List<Product> _product;
  late final List<Product> _products = [];
  bool _isLoading = true;

  final _preferenceArticles = PreferencesArticles();

  @override
  void initState() {
    if(mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    super.initState();
    getProducts();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // displayName = prefs.getStringList('displayName');
    });
  }

  Future<void> getProducts() async {
    _product = await _preferenceArticles.getAllFavorites();
    if(mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    for (var i = 0; i < _product.length; i++) {
      _products.insert(i, _product[i]);
    }
  }

  void removeFavorite(int index) {
    if(mounted) {
      setState(() {
        _products.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              /*
            // Doesnt work yet
            Image.asset("pictures/logopenny.png"
            , width: 40,
              height: 40,
            ),
            */
              SizedBox(width: 10),
              Text('Penny Pincher')
            ],
          ),
          actions: [
          IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {

          },
        )
    ]),
      bottomNavigationBar: BottomNavBarGenerator(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _products.isNotEmpty ? Align(
        alignment: Alignment.topCenter,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: _products.length,
            itemBuilder: (context, index) {
              return FavoriteCard(
                id: _products[index].id,
                index: index,
                title: _products[index].title,
                category: _products[index].categoryName,
                description: _products[index].description,
                image: _products[index].image,
                price:  _products[index].price,
                callback: this,);
            }),
      ) :
      Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(Icons.edit_outlined, color: Colors.grey, size: 80),
          SizedBox(height: 30),
          RichText(
            textAlign: TextAlign.center,
            text:
            TextSpan(
              children: [
                TextSpan(
                    text: "Du hast noch keine Favorites gespeichert.\n \nDu kannst Favorites hinzufügen, indem du auf das ", style: TextStyle(fontSize: 18, color: Colors.black)
                ),
                WidgetSpan(
                  child: Icon(Icons.favorite, color: Colors.red, size: 20),
                ),
                TextSpan(
                    text: " klickst.", style: TextStyle(fontSize: 18, color: Colors.black)
                ),
              ],
            ),
          )
        ],
      ),
      ),);
  }
  // Text("Du hast noch keine Favoriten gespeichert.\n \nDu kannst Favoriten hinzufügen, indem du auf das ❤ klickst.",
  // textAlign: TextAlign.center,
  // style: TextStyle(fontSize: 18, color: Colors.black),
  // )

  showAlertDialog(BuildContext context, int index, int id) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("Nein"),
    onPressed:  () {Navigator.of(context).pop();},
  );
  Widget continueButton = TextButton(style: TextButton.styleFrom(
        primary: Colors.red,
  ),
  child: const Text("Ja"),
    onPressed:  () {
      Navigator.of(context).pop();
      _preferenceArticles.removeFavorite(id);
      removeFavorite(index);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Artikel entfernen?"),
    content: const Text("Willst du diesen Artikel wirklich aus deinen Favorites entfernen?"),
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
