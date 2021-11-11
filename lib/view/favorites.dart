import 'dart:convert';
import 'package:penny_pincher/models/preferences_articles.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/view/widget/article_card.dart';
import 'package:penny_pincher/view/widget/extended_view.dart';
import 'package:penny_pincher/view/widget/favorite_card.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritePage extends StatefulWidget {

  late final Stream<bool> stream;

  FavoritePage(this.stream);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  //late Product _product;

  late List<Product> _product;
  late final List<Product> _favoriteIds = [];
  bool _isLoading = true;

  final _preferenceArticles = PreferencesArticles();

  @override
  void initState() {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    super.initState();
    widget.stream.listen((update) {
      updateFavorites(update);
    });
    getProducts();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // displayName = prefs.getStringList('displayName');
    });
  }

  Future <void> getProducts() async {
    print("2");
    _favoriteIds.clear();
    _product = await _preferenceArticles.getAllFavorites();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    for (var i = 0; i < _product.length; i++) {
      _favoriteIds.insert(i, _product[i]);
    }
  }

  updateFavorites(bool update) {
    if (this.mounted) {
      setState(() {
        getProducts();
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _favoriteIds.isNotEmpty
              ? Align(
                  alignment: Alignment.topCenter,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _favoriteIds.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExtendedView(
                                        id: _favoriteIds[index].productId,
                                        title: _favoriteIds[index].title,
                                        saving: _favoriteIds[index].saving,
                                        category:
                                            _favoriteIds[index].categoryName,
                                        description:
                                            _favoriteIds[index].description,
                                        image: _favoriteIds[index].image,
                                        price: _favoriteIds[index].price,
                                        callback: this)),
                              );
                            },
                            child: FavoriteCard(
                              id: _favoriteIds[index].productId,
                              index: index,
                              title: _favoriteIds[index].title,
                              saving: _favoriteIds[index].saving,
                              category: _favoriteIds[index].categoryName,
                              description: _favoriteIds[index].description,
                              image: _favoriteIds[index].image,
                              price: _favoriteIds[index].price,
                              callback: this,
                            ));
                      }),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit_outlined, color: Colors.grey, size: 80),
                      SizedBox(height: 30),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text:
                                    "Du hast noch keine Favorites gespeichert.\n \nDu kannst Favorites hinzufügen, indem du auf das ",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black)),
                            WidgetSpan(
                              child: Icon(Icons.favorite,
                                  color: Colors.red, size: 20),
                            ),
                            TextSpan(
                                text: " klickst.",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
  // Text("Du hast noch keine Favoriten gespeichert.\n \nDu kannst Favoriten hinzufügen, indem du auf das ❤ klickst.",
  // textAlign: TextAlign.center,
  // style: TextStyle(fontSize: 18, color: Colors.black),
  // )

  bool isFavorite(int id) {
    return _favoriteIds.where((p) => p.productId == id).toList().isNotEmpty;
  }

  Future changeFavoriteState(ArticleCard card) async {
    if (isFavorite(card.id)) {
      showAlertDialog(context, card.id);
    }
  }

  Future removeFavorite(int id, bool close) async {
    final product = _favoriteIds.where((p) => p.productId == id).toList()[0];
    Navigator.of(context, rootNavigator: true).pop('dialog');
    await _preferenceArticles.removeFavorite(id);
    if (mounted) {
      setState(() {
        _favoriteIds.remove(product);
      });
    }
    if (close) {
      Navigator.pop(context);
    }
  }

  showAlertDialog(BuildContext context, int id) {
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
        await removeFavorite(id, false);
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
