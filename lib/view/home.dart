import 'package:flutter/cupertino.dart';
import 'package:penny_pincher/models/preferences_articles.dart';
import 'package:penny_pincher/services/fav_functions.dart';
import 'package:penny_pincher/services/json_functions.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/view/theme.dart';
import 'package:penny_pincher/view/widget/app_bar_navigator.dart';
import 'package:penny_pincher/view/widget/article_card.dart';
import 'package:penny_pincher/view/widget/article_search.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:penny_pincher/view/extended_view.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

StreamController<bool> streamController = StreamController<bool>.broadcast();

class HomePage extends StatefulWidget {
  late final Stream<bool> stream;
  late final StreamController updateStream;
  final dynamic callback;
  var height;
  HomePage(this.stream, this.updateStream, this.callback, {this.height});

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
  bool isScrolling = false;
  ScrollController _scrollController = ScrollController();

  //var screenHeight = ;

  final _preferenceArticles = PreferencesArticles();
  final _jsonFunctions = JsonFunctions();
  var index = 0;
  var randomCategory = 0;

  _onUpdateScroll() {
    if (this.mounted) {
      setState(() {
        if (_scrollController.offset <
            _scrollController.position.maxScrollExtent) {
          isScrolling = true;
        } else {
          isScrolling = false;
        }
      });
    }
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
    widget.callback.loadingFinished();
    if (count < _product.length) {
      _products.insert(count, _product[count]);
      count++;
    }

    FavFunctions.addProducts(_products);
  }

  updateHome(bool update) {
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
    streamController.add(true);
  }

  void initListOfIDs() {
    _jsonFunctions.getListOfProdCatIDs().then((value) => timerFunction(value));
  }

  timerFunction(List<int> ids) {
    // every 2 seconds get a random category id, call the api with it, load the product and animate it
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      index = _jsonFunctions.getRandomInt();
      randomCategory = ids[index];
      getProducts(randomCategory);
      if (_scrollController.hasClients && !isScrolling) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
    });
  }

  @override
  void initState() {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    super.initState();
    widget.stream.listen((update) {
      updateHome(update);
    });
    initListOfIDs();

    tz.initializeTimeZones();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    //var displayHeight = MediaQuery.of(context).size.height;
   // screenHeight = displayHeight;

    if (_isLoading) {
      return Scaffold(
        body: Container(
            color: ThemeChanger.lightBlue,
            alignment: Alignment.center,
            child: Icon(Icons.search, color: Colors.grey, size: 100)),
      );
    } else {
      return Scaffold(
        appBar: HomeBrowserAppBar(this),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Align(
                alignment: Alignment.topCenter,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollUpdateNotification) {
                      _onUpdateScroll();
                    }
                    return true;
                  },
                  child: ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
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
                                        description:
                                            _products[index].description,
                                        image: _products[index].image,
                                        price: _products[index].price,
                                        stream: streamController.stream,
                                        callback: this)),
                              );
                            },
                            child: ArticleCard(
                              id: _products[index].productId,
                              title: _products[index].title,
                              saving: _products[index].saving,
                              category: _products[index].categoryName,
                              description: _products[index].description,
                              image: _products[index].image,
                              price: _products[index].price,
                              callback: this,
                            ));
                      }),
                )),
      );
    }
  }

  bool getLoading() {
    return _isLoading;
  }

  void setLoading(bool b) {
    _isLoading = b;
  }
}
