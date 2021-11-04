import 'package:penny_pincher/models/preferences_articles.dart';
import 'package:penny_pincher/models/product.api.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/view/widget/article_card.dart';
import 'package:penny_pincher/view/widget/article_search.dart';
import 'package:penny_pincher/view/widget/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      getProducts();
      if (count >= _product.length - 1) {
        dispose();
      }
    });

    getProducts();
  }

  Future<void> getProducts() async {
    _product = await ProductApi.fetchProduct();
    List<Product> favorites = await _preferenceArticles.getAllFavorites();
    for (var i in favorites) {
      if (!_favoriteIds.contains(i.id)) {
        _favoriteIds.add(i.id);
      }
    }

    if (this.mounted) {
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
              icon: Icon(Icons.search),
              onPressed: () {
                final results = showSearch(
                    context: context, delegate: ArticleSearch());
              },
            )
          ]
      ),
      bottomNavigationBar: BottomNavBarGenerator(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Align(
        alignment: Alignment.topCenter,
        child: ListView.builder(
            reverse: true,
            shrinkWrap: true,
            itemCount: _products.length,
            itemBuilder: (context, index) {
              return ArticleCard(
                  id: _products[index].id,
                  title: _products[index].title,
                  category: _products[index].category,
                  description: _products[index].description,
                  image: _products[index].image,
                  price: _products[index].price,
                  callback: this,);
            }),
      ),
    );
  }

  bool isFavorite(int id) {
    return _favoriteIds.contains(id);
  }

  Future changeFavoriteState(ArticleCard articleCard) async {
    if (isFavorite(articleCard.id)) {
      showAlertDialog(context, articleCard.id);
    } else {
      await _preferenceArticles.addFavorite(articleCard);
      if (mounted) {
        setState(() {
          _favoriteIds.add(articleCard.id);});
        }
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
        Navigator.of(context).pop();
        await _preferenceArticles.removeFavorite(id);
        if (mounted) {
          setState(() {
            _favoriteIds.remove(id);
          });
        }
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
