import 'package:flutter/cupertino.dart';
import 'package:penny_pincher/models/preferences_articles.dart';
import 'package:penny_pincher/services/fav_functions.dart';
import 'package:penny_pincher/services/json_functions.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/view/theme.dart';
import 'package:penny_pincher/view/widget/article_card.dart';
import 'package:penny_pincher/view/widget/article_search.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:penny_pincher/view/widget/extended_view.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;


StreamController<bool> streamController = StreamController<bool>.broadcast();

class HomePage extends StatefulWidget {

  late final Stream<bool> stream;
  late final StreamController updateStream;

  HomePage(this.stream, this.updateStream);

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
        }
        else {
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
    _jsonFunctions.getListOfProdCatIDs()
        .then((value) => timerFunction(value));
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
    if (_isLoading) {
      return Scaffold(
        body: Container(
            color: ThemeChanger.lightBlue,
            alignment: Alignment.center,
            child: Icon(Icons.search, color: Colors.grey, size: 100)),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
            backgroundColor: ThemeChanger.navBarColor,
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
                  showSearch(context: context, delegate: ArticleSearch(true, this, streamController));
                },
              )
            ]
        ),

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
                          Navigator.push(context,
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
