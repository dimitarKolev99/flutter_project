import 'package:penny_pincher/models/preferences_articles.dart';
import 'package:penny_pincher/services/fav_functions.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/view/theme.dart';
import 'package:penny_pincher/view/widget/app_bar_navigator.dart';
import 'package:penny_pincher/view/widget/article_card.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/view/widget/article_search.dart';
import 'dart:async';

import 'package:penny_pincher/view/widget/browser_article_card.dart';
import 'package:penny_pincher/view/extended_view.dart';
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
      updateBrowser();
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
    FavFunctions.addProducts(_products);
  }

  updateBrowser() {
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
        appBar: HomeBrowserAppBar(this),
        body: Column(
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
}
