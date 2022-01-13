import 'package:flutter/material.dart';
import 'package:penny_pincher/models/preferences_articles.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/view/widget/article_card.dart';

class ProductController {

  static final _preferenceArticles = PreferencesArticles();
  static late List<Product> favoriteProducts = []; // all favorites IDs as cache
  static late List<Product> _products = []; // all products cached

/* TODO DO NOT DELETE YET
  static void setFavs(List<Product> favs) {
    for(Product p in favs) {
       if(!favoriteProducts.contains(p)) favoriteProducts.add(p);
    }
  }*/

  static Future<void> updateFavorites(callback) async {
    favoriteProducts.clear();
    List<Product> favorites = await _preferenceArticles.getAllFavorites();
    favoriteProducts.addAll(favorites.toSet());
    for(Product p in favorites) {
      favoriteProducts.removeWhere((element) => element.equals(p));
      favoriteProducts.add(p);
    }
    callback.setState(() {});
    callback.streamController.add(true); // note: was not called for browser view before refactoring
  }

  static void addProducts(List<Product> products) {
    for(Product p in products) {
      if(!_products.contains(p)) _products.add(p);
    }
  }

  static bool isFavorite(int id) {
    for(Product fav in favoriteProducts) {
      if(fav.productId == id) return true;
    }
    return false;
  }

  static Future changeFavoriteState(ArticleCard card, dynamic callback) async {

    if (isFavorite(card.id)) {
      showAlertDialog(callback.context, card.id, callback);
    } else {
      await addFavorite(card, callback);
    }
  }

  static Future addFavorite(ArticleCard card, callback) async {
    final product = _products.where((p) => p.productId == card.id).toList()[0];

    await _preferenceArticles.addFavorite(product);
    if (callback.mounted) {
      callback.setState(() {
        favoriteProducts.add(card.product);
      });
    }
    callback.widget.updateStream.add(true);
  }

  static Future removeFavorite(int id, bool close, callback) async {
    await _preferenceArticles.removeFavorite(id);
    if (callback.mounted) {
      callback.setState(() {
        for(Product p in favoriteProducts) {
          if(p.productId == id) favoriteProducts.remove(id);
        }
      });
    }
    callback.widget.updateStream.add(true);
  }

  static showAlertDialog(BuildContext context, int id, callback) {
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
        await removeFavorite(id, false, callback);
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