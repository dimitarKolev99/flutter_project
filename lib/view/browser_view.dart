import 'package:penny_pincher/models/preferences_articles.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/view/widget/article_card.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:penny_pincher/view/widget/browser_article_card.dart';
import 'package:penny_pincher/view/widget/extended_view.dart';

class BrowserPage extends StatefulWidget {
  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  late List<Product> _product;
  late final List _favoriteIds = [];
  late final List<Product> _products = [];
  bool _isLoading = true;
  var count = 0;
  Timer? _timer;

  final _preferenceArticles = PreferencesArticles();

  @override
  void initState() {
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    super.initState();
    getProducts();
  }

  Future<void> getProducts() async {
    _product = await ProductApi.fetchProduct();
    List<Product> favorites = await _preferenceArticles.getAllFavorites();
    for (var i in favorites) {
      if (!_favoriteIds.contains(i.productId)) {
        _favoriteIds.add(i.productId);
      }
    }

    if (this.mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    _products.addAll(_product);
    //count++;
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData = MediaQuery.of(context);;
    double displayWidth = _mediaQueryData.size.width;
    double displayHeight = _mediaQueryData.size.height;
    double blockSizeHorizontal = displayWidth / 100; // bildschirmbreite in 1%
    double blockSizeVertical = displayHeight / 100; // bildschirmhöhe in 1%
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
          )),


      body: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        children: List.generate(_products.length, (index) {
          return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExtendedView(
                          id: _products[index].productId,
                          title: _products[index].title,
                          saving: _products[index].saving,
                          category: _products[index].categoryName,
                          description: _products[index].description,
                          image: _products[index].image,
                          price: _products[index].price,
                          callback: this)),
                );
              },
              child: BrowserArticleCard(
                  id: _products[index].productId,
                  title: _products[index].title,
                  saving: _products[index].saving,
                  category: _products[index].categoryName,
                  description: _products[index].description,
                  image: _products[index].image,
                  price: _products[index].price,
                  callback: this));
        }),
      ),
    );
  }

  bool isFavorite(int id) {
    return _favoriteIds.contains(id);
  }

  Future changeFavoriteState(ArticleCard card) async {
    if (isFavorite(card.id)) {
      showAlertDialog(context, card.id);
    } else {
      await addFavorite(card);
    }
  }

  Future addFavorite(ArticleCard card) async {
    final product = _products.where((p) => p.productId == card.id).toList()[0];
    await _preferenceArticles.addFavorite(product);
    if (mounted) {
      setState(() {
        _favoriteIds.add(card.id);
      });
    }
  }

  Future removeFavorite(int id, bool close) async {
    await _preferenceArticles.removeFavorite(id);
    if (mounted) {
      setState(() {
        _favoriteIds.remove(id);
      });
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
}
