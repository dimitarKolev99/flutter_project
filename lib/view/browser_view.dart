import 'package:penny_pincher/models/preferences_articles.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/view/widget/article_card.dart';
import 'package:penny_pincher/view/widget/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:penny_pincher/view/widget/browser_article_card.dart';

class BrowserPage extends StatefulWidget {
  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  //late Product _product;
  late List<Product> _product;
  late final List<Product> _products = [];
  bool _isLoading = true;
  var count = 0;
  Timer? _timer;

  @override
  void initState() {
    if(this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      getProducts();
      if(count>=_product.length - 1){
        dispose();
      }
    });
  }

  Future<void> getProducts() async {
    _product = await ProductApi.fetchProduct();
    if(this.mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    _products.insert(count, _product[count]);
    count++;
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color.fromRGBO(23, 41, 111, 1),
            title: Row(
              mainAxisAlignment:  MainAxisAlignment.center,
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
            )
        ),
        bottomNavigationBar: BottomNavBarGenerator(),
      body: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        childAspectRatio : 0.8,
        children: List.generate(_products.length, (index) {
           return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExtendedView(
                    id: _products[index].productId,
                    title: _products[index].title,
                    category: _products[index].categoryName,
                    description: _products[index].description,
                    image: _products[index].image,
                    price:  _products[index].price,
                    callback: this)),
                );
              },
              child: BrowserArticleCard(
                id: _products[index].productId,
                title: _products[index].title,
                category: _products[index].categoryName,
                description: _products[index].description,
                image: _products[index].image,
                price:  _products[index].price,
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
    await _preferenceArticles.addFavorite(card);
    if (mounted) {
      setState(() {
        _favoriteIds.add(card.id);});
    }
  }

  Future removeFavorite(int id) async {
    Navigator.of(context).pop();
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
      onPressed:  () {Navigator.of(context).pop();},
    );
    Widget continueButton = TextButton(style: TextButton.styleFrom(
      primary: Colors.red,
    ),
      child: const Text("Ja"),
      onPressed:  () async {
        await removeFavorite(id);
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