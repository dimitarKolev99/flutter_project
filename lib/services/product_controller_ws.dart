import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/models/preference_articles_ws.dart';
import 'package:penny_pincher/models/ws_product.dart';
import 'package:penny_pincher/view/widget/new_article_card.dart';

class ProductControllerWS {

  static final _preferenceArticlesWS = PreferenceArticlesWS();
  static late List<ProductWS> favoriteProductsWS = [];
  static late List<ProductWS> _productsWS = [];

  static Future<void> updateFavoritesWS(callback) async {
    favoriteProductsWS.clear();
    List<ProductWS> favorites = await _preferenceArticlesWS.getAllFavorites();
    favoriteProductsWS.addAll(favorites.toSet());
    for(ProductWS pWS in favorites) {
      favoriteProductsWS.removeWhere((element) => element.equals(pWS));
      favoriteProductsWS.add(pWS);
    }
    callback.setState(() {});
    callback.streamController.add(true); // note: was not called for browser view before refactoring
  }

  static void addProductsWS(List<ProductWS> products) {
    for(ProductWS pWS in products) {
      if(!_productsWS.contains(pWS)) _productsWS.add(pWS);
    }
  }

  static bool isFavoriteWS(int id) {
    for(ProductWS favWS in favoriteProductsWS) {
      if(favWS.productId == id) return true;
    }
    return false;
  }

  static Future changeFavoriteStateWS(NewArticleCard cardWS, dynamic callback) async {
    print("WE ARE IN changeFavoriteStateWS");
    if (isFavoriteWS(cardWS.productId)) {
      showAlertDialog(callback.context, cardWS.productId, callback);
    } else {
      await addFavoriteWS(cardWS, callback);
    }
  }

  static Future addFavoriteWS(NewArticleCard cardWS, callback) async {
    print("WE ARE IN addFavoriteWS");
    print("NewArticleCard cardWS =====> $cardWS");
    print("_productsWS ------> $_productsWS");
    final product = _productsWS.where((pWS) =>
    pWS.productId == cardWS.productId).toList()[0];

    print("LIST OF PRODUCTS ====> ${product}");
    await _preferenceArticlesWS.addFavorite(product);
    // if (callback.mounted) {
    callback.setState(() {
      favoriteProductsWS.add(cardWS.productWS);
      print("CARD ADDED !!!!!");
      print("$favoriteProductsWS");

    });
 // }
    callback.widget.updateStream.add(true);
  }

  static Future removeFavoriteWS(int id, bool close, callback) async {
    await _preferenceArticlesWS.removeFavorite(id);
    if (callback.mounted) {
      callback.setState(() {
        for(ProductWS pWS in favoriteProductsWS) {
          if(pWS.productId == id) favoriteProductsWS.remove(id);
          print("CARD REMOVED !!!!");
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
        await removeFavoriteWS(id, false, callback);
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