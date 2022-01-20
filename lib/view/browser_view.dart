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
  int saving = 0;
  int maxPrice = 10000;
  int minPrice = 0;

  late SubcategoryView view;

  final _preferenceArticles = PreferencesArticles();

  // This map is necessary because we need to know the id and the name of the chosen Cats
  Map<String, int> mapOfChosenCategories = new Map();
  List<String> chosenCategories = [];// Map has int with the id of the chosen category, and a Li
//   st of bargains as value
  Map<int, Iterable<Product>> bargainsOfChosenCats = new Map();
  int numberOfProducts = 0;

  // Whenever a productcategory gets selected this function should add all Products of the category to the Map
  Future<void> addProductsOfChosenCategory(int categoryId)async {
    Iterable<Product> products = await ProductApi().getFilterProducts(categoryId, saving, minPrice, maxPrice);
    bargainsOfChosenCats[categoryId] = products;
    numberOfProducts += products.length;
    view.state.setState(() { });
  }

  Future<void> changePrice() async{
    bargainsOfChosenCats.forEach((key, value) async {
      numberOfProducts = 0;

      Iterable<Product> products = await ProductApi().getFilterProducts(key, saving, minPrice, maxPrice);
      bargainsOfChosenCats[key] = products;
      numberOfProducts += products.length;
      view.updateStream.add(true);
      view.state.setState(() { });
    });
  }

  // Whenever a productcategory gets unselcted this function should delete all Products of the category to the Map
  //TODO: Does this wotk with the ?.clear() to delete the products
  void deleteProductsOfChosenCategory(int categoryID){
    // call this if in browserView -> sets state of browserView instead of SubcatView
      Iterable<Product>? products = bargainsOfChosenCats[categoryID];
      if(products!=null){
      numberOfProducts -= products.length;
      bargainsOfChosenCats.remove(categoryID);
      setState(() { });
    }
  }

  void deleteProductsOfChosenCategoryFromView(int categoryID){
    // call this if in subcatView -> sets state of subcatView instead of browserView
    Iterable<Product>? products = bargainsOfChosenCats[categoryID];
    if(products!=null){
      numberOfProducts -= products.length;
      bargainsOfChosenCats.remove(categoryID);
      view.state.setState(() { });
    }
  }

  String getMainCategoryName(int i){
    return widget.mainCategoryNames[i];
  }

  int getMainCategoryId(int i){
    return widget.mainCategoryIds[i];
  }

  void addCategory(String s, int id){
    //chosenCategories.add(s);
    //TODO: change to propper working category List, this is juts to show only the last cat
    mapOfChosenCategories[s] = id;
    chosenCategories.add(s);
    //print(chosenCategories);

  }

  void removeOneCategory(String s){
    int index = chosenCategories.indexOf(s);
    chosenCategories.remove(chosenCategories[index]);
    int? id = mapOfChosenCategories[s];
    if(id != null) {
      //print("works");
      deleteProductsOfChosenCategory(id);
    }
    mapOfChosenCategories.remove(s);
    //print(chosenCategories);
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
    // iterate map for each value of map add All
    bargainsOfChosenCats.forEach((key, value) {
      _products.addAll(value);
    });
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
                height: 40,
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      if(chosenCategories.isEmpty) {
                                        view = SubcategoryView(
                                          widget.mainCategoryIds[index],
                                          widget.mainCategoryNames[index],
                                          widget.stream,
                                          widget.updateStream,
                                          this,
                                          );
                                        numberOfProducts = 0;
                                      }
                                      return view;
                                      },
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
                                      color: chosenCategories.isEmpty? ThemeChanger.catTextColor : ThemeChanger.textColor,
                                      fontWeight:  FontWeight.w400,
                                    ),
                                  ),

                                chosenCategories.isEmpty? SizedBox(width: 0,):
                                IconButton(
                                  alignment: Alignment.centerRight,
                                    constraints: const BoxConstraints(),
                                    padding : const EdgeInsets.only(top: 1.3),
                                    onPressed: (){
                                      print("x clicked");
                                      print(chosenCategories.isNotEmpty);
                                      if(chosenCategories.isNotEmpty) {
                                      setState((){
                                          //TODO: Reload Products
                                          print(chosenCategories[index]);
                                          view.removeFromBrowser(chosenCategories[index]);
                                          removeOneCategory(chosenCategories[index]);
                                          updateBrowserblabla(currentCategory);

                                        }
                                      );}
                                  },
                                icon: Icon(Icons.clear, size: 18, color: ThemeChanger.textColor,) )

                              ],
                            ),
                           ));


                    }),
              ),
            ),


            // If no Products are in the chosen categories or no category is chosen
            //TODO: Better Layout Design!
            _products.isEmpty?
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    Center(
                      child:
                      Text("Für deine ausgewählten Kategorien gibt es keine aktuell keine Schnäppchen. "
                          "Bitte wähle eine oder mehrere der zur Verfügung stehenden Kategorien",
                        style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16 ),
                          textAlign: TextAlign.center)

                    )




                  ],
                )


            :
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

  void setSaving(int saving){
    this.saving = saving;
  }

  void setPriceRange(int minPrice, int maxPrice){
    //print("PRICESPRICERANGE-------------------------------$minPrice, $maxPrice");
    this.minPrice = minPrice;
    this.maxPrice = maxPrice;
  }
}
