import 'dart:convert';
import 'package:penny_pincher/models/preferences_articles.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/view/widget/article_card.dart';
import 'package:penny_pincher/view/widget/extended_view.dart';
import 'package:penny_pincher/view/widget/favorite_card.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/view/widget/favorite_search.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

StreamController<bool> streamController = StreamController<bool>.broadcast();

class FavoritePage extends StatefulWidget {

  late final Stream<bool> stream;
  late final StreamController updateStream;

  FavoritePage(this.stream, this.updateStream);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  //late Product _product;

  late List<Product> _product;
  late final List<Product> favoriteIds = [];
  bool _isLoading = true;
  bool _isClosed = false;
  String query = '';

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
    favoriteIds.clear();
    _product = await _preferenceArticles.getAllFavorites();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    for (var i = 0; i < _product.length; i++) {
      favoriteIds.insert(i, _product[i]);
    }
  }

  updateFavorites(bool update) {
    if (this.mounted) {
      setState(() {
        getProducts();
      });
    }
    if (_isClosed) {
      _isClosed = false;
      Navigator.maybePop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: ProductApi.darkBlue,
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
              Padding(
                padding: EdgeInsets.only(top: 3),
                child:
                Text(
                  'Penny Pincher',
                  style: TextStyle(
                    // Shaddow is used to get Distance to the underline -> TextColor itself is transparent
                    shadows: [
                      Shadow(
                          color: Color.fromRGBO(240, 240, 240, 1),
                          offset: Offset(0, -5))
                    ],
                    //fontFamily: '....',
                    fontSize: 21,
                    letterSpacing: 3,
                    color: Colors.transparent,
                    fontWeight: FontWeight.w900,
                    decoration:
                    TextDecoration.underline,
                    decorationColor: Color.fromRGBO(220, 110, 30, 1),
                    decorationThickness: 4,
                  ),
                ), ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                final results =
                showSearch(context: context, delegate: FavoriteSearch(this, streamController));
              },
            )
          ]),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : favoriteIds.isNotEmpty
              ? Align(
                  alignment: Alignment.topCenter,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: favoriteIds.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExtendedView(
                                        id: favoriteIds[index].productId,
                                        title: favoriteIds[index].title,
                                        saving: favoriteIds[index].saving,
                                        category:
                                        favoriteIds[index].categoryName,
                                        description:
                                        favoriteIds[index].description,
                                        image: favoriteIds[index].image,
                                        price: favoriteIds[index].price,
                                        stream: streamController.stream,
                                        callback: this)),
                              );
                              streamController.add(true);
                              _isClosed = true;
                            },
                            child: FavoriteCard(
                              id: favoriteIds[index].productId,
                              index: index,
                              title: favoriteIds[index].title,
                              saving: favoriteIds[index].saving,
                              category: favoriteIds[index].categoryName,
                              description: favoriteIds[index].description,
                              image: favoriteIds[index].image,
                              price: favoriteIds[index].price,
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
    return favoriteIds.where((p) => p.productId == id).toList().isNotEmpty;
  }

  Future changeFavoriteState(ArticleCard card) async {
    if (isFavorite(card.id)) {
      showAlertDialog(context, card.id);
    }
  }

  Future removeFavorite(int id, bool close) async {
    final product = favoriteIds.where((p) => p.productId == id).toList()[0];
    await _preferenceArticles.removeFavorite(id);
    if (mounted) {
      setState(() {
        favoriteIds.remove(product);
      });
    }
    if (close) {
      Navigator.pop(context);
    }
    widget.updateStream.add(true);
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
        Navigator.of(context, rootNavigator: true).pop('dialog');
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

  List<Product> filterFavorites() {
    List<Product> result = [];
    for (var i = 0; i < favoriteIds.length; i++) {
      if (favoriteIds[i].title.toLowerCase().contains(query.toLowerCase())) {
        result.add(favoriteIds[i]);
      }
    }
    return result;
  }
}
