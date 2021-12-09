import 'package:flutter/material.dart';
import 'package:penny_pincher/models/preferences_articles.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/view/widget/article_card.dart';

class FavFunctions {

  static final _preferenceArticles = PreferencesArticles();
  static late List _favoriteIds = [];
  static late List<Product> _products = [];


  static void setFavs(List<Product> favs) {
    for(Product p in favs) {
      _favoriteIds.add(p.productId);
    }
  }

  static void addProducts(List<Product> products) {
    _products.addAll(products);
    print(_favoriteIds.length);
  }

  static bool isFavorite(int id) {
    return _favoriteIds.contains(id);
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
          _favoriteIds.add(card.id);
        });
      }
      callback.widget.updateStream.add(true);
  }

  static Future removeFavorite(int id, bool close, callback) async {
    await _preferenceArticles.removeFavorite(id);
    if (callback.mounted) {
      callback.setState(() {
        _favoriteIds.remove(id);
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