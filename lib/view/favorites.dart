import 'dart:convert';
import 'package:penny_pincher/models/preferences_articles.dart';
import 'package:penny_pincher/services/product_controller.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/view/theme.dart';
import 'package:penny_pincher/view/widget/app_bar_navigator.dart';
import 'package:penny_pincher/view/widget/article_card.dart';
import 'package:penny_pincher/view/extended_view.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/view/widget/favorite_search.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';



class FavoritePage extends StatefulWidget {

  late final Stream<bool> stream;
  late final StreamController updateStream;

  FavoritePage(this.stream, this.updateStream);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  //late Product _product;
  StreamController<bool> streamController = StreamController<bool>.broadcast();
  late List<Product> _product;
  List<Product> favoriteProducts = [];
  bool _isClosed = false;
  String query = '';
  dynamic search;

  final _preferenceArticles = PreferencesArticles();

  @override
  void initState() {
    favoriteProducts = ProductController.favoriteProducts;
    super.initState();
    widget.stream.listen((update) {
      updateScreen(update);
    });
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // displayName = prefs.getStringList('displayName');
    });
  }
/* //TODO DO NOT DELETE TEMPLATE FOR FURTHER REAFCTORING
  Future <void> getProducts() async {
    favoriteProducts.clear();
    _product = await _preferenceArticles.getAllFavorites();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    for (var i = 0; i < _product.length; i++) {
      favoriteProducts.insert(i, _product[i]);
    }
    ProductController.setFavs(favoriteProducts);
    ProductController.addProducts(favoriteProducts);
  }
*/
  updateScreen(bool update) {
    if (this.mounted) {
      ProductController.updateFavorites(this);
    }
    if (_isClosed) {
      _isClosed = false;
      Navigator.maybePop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: FavoriteAppBar(this),
      body: favoriteProducts.isNotEmpty
          ? Align(
        alignment: Alignment.topCenter,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: favoriteProducts.length,
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ExtendedView(favoriteProducts[index], this, streamController.stream)),
                    );
                    streamController.add(true);
                    _isClosed = true;
                  },
                  child: ArticleCard(favoriteProducts[index], this));
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
                          fontSize: 18, color: ThemeChanger.reversetextColor)),
                  WidgetSpan(
                    child: Icon(Icons.favorite,
                        color: Colors.red, size: 20),
                  ),
                  TextSpan(
                      text: " klickst.",
                      style: TextStyle(
                          fontSize: 18, color: ThemeChanger.reversetextColor)),
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

  Future changeFavoriteState(ArticleCard card) async {
    ProductController.changeFavoriteState(card, this);
  }

  List<Product> filterFavorites(search) {
    this.search = search;

    List<Product> result = [];
    for (var i = 0; i < favoriteProducts.length; i++) {
      if (favoriteProducts[i].title.toLowerCase().contains(query.toLowerCase())) {
        result.add(favoriteProducts[i]);
      }
    }
    return result;
  }
}
