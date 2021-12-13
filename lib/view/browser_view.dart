import 'package:penny_pincher/models/preferences_articles.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/view/theme.dart';
import 'package:penny_pincher/view/widget/article_card.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/view/widget/article_search.dart';
import 'dart:async';

import 'package:penny_pincher/view/widget/browser_article_card.dart';
import 'package:penny_pincher/view/widget/extended_view.dart';
import 'package:penny_pincher/view/subcategory_view.dart';
import 'package:provider/provider.dart';

import 'filter_view.dart';

StreamController<bool> streamController = StreamController<bool>.broadcast();

class BrowserPage extends StatefulWidget {

  late final Stream<bool> stream;
  late final StreamController updateStream;

  BrowserPage(this.stream, this.updateStream);

  @override
  State<BrowserPage> createState() => _BrowserPageState();

  Map<String, int> mainCategories = {
    "Elektroartikel" : 30311,
    "Drogerie & Gesundheit" : 3932,
    "Haus & Garten" :3686,
    "Mode & Accessoires" : 9908,
    "Tierbedarf" : 7032,
    "Gaming & Spielen" : 3326,
    "Essen & Trinken" : 12913,
    "Baby & Kind" : 4033,
    "Auto & Motorrad" : 2400,
    "Haushaltselektronik" : 1940,
    "Sport & Outdoor" : 3626,
  };

  List<String> mainCategoryNames = [
    "Elektroartikel",
    "Drogerie & Gesundheit",
    "Haus & Garten",
    "Mode & Accessoires",
    "Tierbedarf",
    "Gaming & Spielen",
    "Essen & Trinken",
    "Baby & Kind",
    "Auto & Motorrad",
    "Haushaltselektronik",
    "Sport & Outdoor"
  ];
  List<int> mainCategoryIds = [
    30311,//
    3932,
    3686,
    9908,
    7032,
    3326,
    12913,
    4033,
    2400,
    1940,
    3626,
  ];


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
    widget.stream.listen((update) {
      updateBrowser(update);
    });
    getProducts(3832); print("CALLED FROM BROWSER VIEW");
  }

  Future<void> getProducts(int categoryID) async {
    _product = await ProductApi().fetchProduct(categoryID);
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

  updateBrowser(bool update) {
    if (this.mounted) {
      updateFavorites();
    }
  }

  Future<void> updateFavorites() async {
    _favoriteIds.clear();
    List<Product> favorites = await _preferenceArticles.getAllFavorites();
    for (var i in favorites) {
      if (!_favoriteIds.contains(i.productId)) {
        _favoriteIds.add(i.productId);
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    MediaQueryData _mediaQueryData = MediaQuery.of(context);;
    double displayWidth = _mediaQueryData.size.width;
    double displayHeight = _mediaQueryData.size.height;
    double blockSizeHorizontal = displayWidth / 100; // screen width in 1%
    double blockSizeVertical = displayHeight / 100; // screen height in 1%
    return Scaffold(
        appBar: AppBar(
            backgroundColor: ThemeChanger.navBarColor,
            leading: IconButton(
              icon: Icon(Icons.category),
              onPressed: () {
                Navigator.push (
                    context,
                    MaterialPageRoute(
                        builder: (context) => FilterView())
                ); },
            ),
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
                            offset: Offset(0, -6))
                      ],
                      //fontFamily: '....',
                      fontSize: 21,
                      letterSpacing: 3,
                      color: Colors.transparent,
                      fontWeight: FontWeight.w900,
                      decoration:
                      TextDecoration.underline,
                      decorationColor: ThemeChanger.highlightedColor,
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
                  showSearch(context: context, delegate: ArticleSearch(false, this, streamController));
                },
              )
            ]
        ),

        body:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            //MainCategories to click to get to edit the filter categories / search
            Align(
              alignment: Alignment.topCenter,
              child:
              Container(
                color: ThemeChanger.lightBlue,
                height: 40,
                child:
                ListView.builder(
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: widget.mainCategories.length,
                    itemBuilder: (context,  index) {
                      return InkWell(

                        /*
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
                                      stream: streamController.stream,
                                      callback: this)),
                            );
                            streamController.add(true);
                          },
                           */
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SubcategoryView(categoryName: widget.mainCategoryNames[index] ,
                                        categoryId: widget.mainCategoryIds[index],
                                      ),
                                )
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: ThemeChanger.articlecardbackground,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(4),
                            //padding: EdgeInsets.all(4),
                            padding: EdgeInsets.symmetric( horizontal:  6),
                            height: 40,
                            child: Text(widget.mainCategoryNames[index],
                              style: TextStyle(
                                color: ThemeChanger.reversetextColor,
                              ),),
                          ));
                    }),

              ),
            ),


// This Grid View is supposed to show the main categories on top of the screen in the browser view
            Align(
                alignment: Alignment.center,
                child:
                Container(
                  height: displayHeight - 40 - 40 - 75 -41,
                  child:
                  GridView.count(
                    // Create a grid with 2 columns. If you change the scrollDirection to
                    // horizontal, this produces 2 rows.
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
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
                                      stream: streamController.stream,
                                      callback: this)),
                            );
                            streamController.add(true);
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
                )
            ),



          ],
        )

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
    widget.updateStream.add(true);
  }

  Future removeFavorite(int id, bool close) async {
    await _preferenceArticles.removeFavorite(id);
    if (mounted) {
      setState(() {
        _favoriteIds.remove(id);
      });
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
}
