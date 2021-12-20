import 'package:flutter/gestures.dart';
import 'package:penny_pincher/models/preferences_articles.dart';
import 'package:penny_pincher/services/product_controller.dart';
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

class BrowserPage extends StatefulWidget {
  late final Stream<bool> stream;
  late final StreamController updateStream;
  int _currentProductId;



  BrowserPage(this.stream, this.updateStream, this._currentProductId);

  @override
  State<BrowserPage> createState() => _BrowserPageState();

  Map<String, int> mainCategories = {
    "Elektroartikel": 30311,
    "Drogerie & Gesundheit": 3932,
    "Haus & Garten": 3686,
    "Mode & Accessoires": 9908,
    "Tierbedarf": 7032,
    "Gaming & Spielen": 3326,
    "Essen & Trinken": 12913,
    "Baby & Kind": 4033,
    "Auto & Motorrad": 2400,
    "Haushaltselektronik": 1940,
    "Sport & Outdoor": 3626,
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
    30311, //
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
  int currentCategory = 0;
  StreamController<bool> streamController = StreamController<bool>.broadcast();
  late List<Product> _product;
  late final List _favoriteIds = [];
  late final List<Product> _products = [];
  bool _isLoading = true;
  var count = 0;
  Timer? _timer;

  final _preferenceArticles = PreferencesArticles();

  List<String> chosenCategories = [];

  String getMainCategoryName(int i){
    return widget.mainCategoryNames[i];
  }

  int getMainCategoryId(int i){
    return widget.mainCategoryIds[i];
  }

  void addCategory(String s){
    //chosenCategories.add(s);
    //TODO: change to propper working category List, this is juts to show only the last cat
    chosenCategories.add(s);
  }

  void removeOneCategory(String s ){
    int index = chosenCategories.indexOf(s);
    chosenCategories.remove(chosenCategories[index]);
  }

  void deleteCategory(String s){
    int index = chosenCategories.indexOf(s);
    for(int i = chosenCategories.length-1; i >= index ; i--){
      chosenCategories.remove(chosenCategories[i]);
    }
  }


  @override
  void initState() {
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    super.initState();
    widget.stream.listen((update) {
      if (this.mounted) {
        ProductController.updateFavorites(this);
      }
    });
    getProducts(widget._currentProductId);
    print("CALLED FROM BROWSER VIEW");
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
    ProductController.addProducts(_products);
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    print("got the new categorie : ${widget._currentProductId}");
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    MediaQueryData _mediaQueryData = MediaQuery.of(context);
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
              child: Container(
                color: ThemeChanger.lightBlue,
                height: 35,
                width: displayWidth,
                //TODO:ListView Bulider to show the route of the categories, works only for choosing 1 Prod. Cat.

                child: ListView.builder(
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: chosenCategories.isEmpty? widget.mainCategories.length : chosenCategories.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            chosenCategories = [];
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SubcategoryView(
                                    categoryName:
                                        widget.mainCategoryNames[index],
                                    categoryId: widget.mainCategoryIds[index],
                                    stream: widget.stream,
                                    updateStream: widget.updateStream,
                                    callback: this,
                                  ),
                                ));
                          },
                          child:
                              Container(
                              decoration: BoxDecoration(
                              color: chosenCategories.isEmpty? ThemeChanger.articlecardbackground : ThemeChanger.navBarColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.all(4),
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              mainAxisAlignment : MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                              chosenCategories.isEmpty? widget.mainCategoryNames[index] : chosenCategories[index],
                              style: TextStyle(
                                color: chosenCategories.isEmpty? ThemeChanger.navBarColor : ThemeChanger.articlecardbackground,
                                //fontWeight:  !chosenCategories.isEmpty && index == chosenCategories.length-1?  FontWeight.w600 :FontWeight.normal,
                                fontWeight:  FontWeight.w400,
                              ),
                              ),
                                chosenCategories.isEmpty?
                                SizedBox(width: 0,):
                                IconButton(
                                  alignment: Alignment.centerRight,
                                    constraints: const BoxConstraints(),
                                    padding : const EdgeInsets.only(top: 1.3),
                                    onPressed: (){
                                  setState((){
                                    if(!chosenCategories.isEmpty) {
                                      //TODO: Reload Products
                                      removeOneCategory(chosenCategories[index]);
                                      updateBrowserblabla(currentCategory);
                                    }
                                  });},
                                icon: Icon(Icons.clear, size: 18, color: ThemeChanger.articlecardbackground,) )
                              ],
                            ),



                          ));


                    }),
              ),
            ),





            // This Grid View is supposed to show the main categories on top of the screen in the browser view
            Expanded(
              child: GridView.count(
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
                              builder: (context) => ExtendedView(_products[index], this, streamController.stream)),
                        );
                        streamController.add(true);
                      },
                      child: BrowserArticleCard(_products[index], this));
                }),
              ),
            )
          ],
        ));
  }
  void updateBrowserblabla(int catID){
    _products.clear();
    widget._currentProductId = catID;
    getProducts(widget._currentProductId);
    setState(() {});
  }
}
