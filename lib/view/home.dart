import 'package:flutter/cupertino.dart';
import 'package:penny_pincher/models/ws_product.dart';
import 'package:penny_pincher/services/product_controller.dart';
import 'package:penny_pincher/services/json_functions.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/services/product_controller_ws.dart';
import 'package:penny_pincher/view/theme.dart';
import 'package:penny_pincher/view/welcome_screen.dart';
import 'package:penny_pincher/view/widget/app_bar_navigator.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/view/widget/article_card.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'extended_view.dart';

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
    30311,
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

  JsonFunctions json = JsonFunctions();
  late int categoryId;
  late String categoryName;
  List<int> productCategoryIDs = [];
  List<int> productIdList = [];

  ///NEW WEBSOCKET
  List<ProductWS> filteredProducts = [];
  late int categoryIdWebSocket = 0;
  List<ProductWS> result = [];
  late int indexItemBuilder;

  StreamController<bool> streamController = StreamController<bool>.broadcast();

  late List<ProductWS> newProduct;

  late final List<Product> newProducts = [];

  bool _isLoading = true;
  var count = 0;
  bool isScrolling = false;
  final ScrollController _scrollController = ScrollController();
  WelcomeStatus status = WelcomeStatus.loading;
  dynamic preferences;


  final _jsonFunctions = JsonFunctions();
  var index = 0;

  bool loadingProducts = false;

  bool show = false;

  final List<int> _selectedItems = [];

  final channel = WebSocketChannel.connect(
    Uri.parse('wss://ika3taif23.execute-api.eu-central-1.amazonaws.com/prod'),
  );

  _onUpdateScroll() {
    /*
    if (mounted) {
      setState(() {
        if (_scrollController.offset <
            _scrollController.position.maxScrollExtent) {
          isScrolling = true;
        } else {
          isScrolling = false;
        }
      });
    }

     */
    //print(_scrollController.offset);

    int a = (_scrollController.position.maxScrollExtent - _scrollController.position.pixels).toInt();
    if (a == 157 ||
        a == 0 ||
        a == 69 ||
    a == 314) {
      isScrolling = false;
    } else {
      print("HERE");
      isScrolling = true;
      setState(() {
        show = true;
      });
    }

  }

  var displayHeight = 0.0;

   void check()  {
    Future.delayed(const Duration(seconds: 7), () {
      show = true;
    });
  }


  void getProducts() {
    if (mounted) {
      setState(() {
        if (status == WelcomeStatus.noFirstTime) {
          _isLoading = false;
        }
      });
    }
    if (status == WelcomeStatus.noFirstTime) {
      widget.callback.loadingFinished();
      status = WelcomeStatus.finished;
    }
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
      if (mounted) {
        setState(() {
          ProductController.updateFavorites(this);
        });
       }
    });
    firstAppStart();
    tz.initializeTimeZones();

    disableSplashScreen();
  }

  Future<void> disableSplashScreen() async {
    await Future.delayed(const Duration(seconds: 2), (){});
    getProducts();
  }

  List<int> listOfProdCat = [];

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    MediaQueryData _mediaQueryData;
    double displayWidth;
    double displayHeight;
    double blockSizeHorizontal;
    double blockSizeVertical;

    double _safeAreaHorizontal;
    double _safeAreaVertical;

    double _safeAreaBottomPadding;
    double safeBlockBottom;

    double safeBlockHorizontal;
    double safeBlockVertical;

    _mediaQueryData = MediaQuery.of(context);
    displayWidth = _mediaQueryData.size.width;
    displayHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = displayWidth / 100;
    blockSizeVertical = displayHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;

    _safeAreaBottomPadding = _mediaQueryData.padding.bottom;
    safeBlockBottom = (displayWidth - _safeAreaBottomPadding) / 100;

    safeBlockHorizontal = (displayWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (displayHeight - _safeAreaVertical) / 100;

    if (status == WelcomeStatus.firstTime) {
      return WelcomePage(this);
    }
    if (_isLoading || status == WelcomeStatus.loading) {
      return Scaffold(
        body: Container(
            color: ThemeChanger.lightBlue,
            alignment: Alignment.center,
            child: const Icon(Icons.search, color: Colors.grey, size: 100)),
      );
    } else {
      return Scaffold(
          appBar: HomeBrowserAppBar(this),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  color: ThemeChanger.lightBlue,
                  height: 40,
                  width: displayWidth,
                  child: ListView.builder(
                      physics: const ScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: mainCategories.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () async {
                              selectCategory(index);
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: (_selectedItems
                                      .contains(mainCategoryIds[index]))
                                      ? ThemeChanger.highlightedColor
                                      : ThemeChanger.articlecardbackground,
                                  //_selectedItem != null && _selectedItem == index ? ThemeChanger.highlightedColor : ThemeChanger.articlecardbackground,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                alignment: Alignment.centerRight,
                                margin: const EdgeInsets.all(4),
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  mainCategoryNames[index],
                                  style: TextStyle(
                                    color: ThemeChanger.catTextColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )));
                      }),
                ),
              ),
              Expanded(
                child:
                Stack(children: [
                  Align(
                      alignment: Alignment.topCenter,
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollStartNotification) {
                          print("NOTIFICATION");
                          //print("${_scrollController.position.pixels}" +  " " + "${_scrollController.position.maxScrollExtent}");
                          print(_scrollController.position.maxScrollExtent - _scrollController.position.pixels);
                          //_scrollController.position.pixels < _scrollController.position.maxScrollExtent ? animate() : null;
                            _onUpdateScroll();
                          }
                          return true;
                        },
                        child: StreamBuilder(
                          stream: channel.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              search(listOfProdCat, productFromJson(snapshot.data.toString()));
                              ProductController.addProducts(newProducts);
                              !isScrolling ? animate() : null;
                              return ListView.builder(
                                  reverse: true,
                                  shrinkWrap: true,
                                  controller: _scrollController,
                                  itemCount: newProducts.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ExtendedView(newProducts[index], this, streamController.stream,)
                                            ),
                                          );
                                        },
                                        child: ArticleCard(newProducts[index], this));
                                  });
                            } else {
                              return const Align(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator());
                            }
                          },
                        ),

                      )
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: show ? FloatingActionButton(
                          onPressed: () {
                            animate();
                            setState(() {
                              show = false;
                            });
                            //check();
                          },
                          child: const Icon(Icons.arrow_upward),
                          backgroundColor: ThemeChanger.lightBlue,
                        ) : null
                      ),
                  ),
              ]
                      ),
                  ),

              ]
          ),
      );
    }
  }

  selectCategory(index) async {
    mainCategories[index];
    categoryId = mainCategoryIds[index];

    if(!_selectedItems.contains(mainCategoryIds[index])) {
      setState(() {
        _selectedItems.add(categoryId);
      });
    } else {
      setState(() {
        _selectedItems.removeWhere((element) => element == categoryId);
      });
    }
    List<String> categoriesList = [];
    for (int i = 0; i < mainCategoryIds.length; i++) {
      if (_selectedItems.contains(mainCategoryIds[i])) {
        categoriesList.add(i.toString());
      }
    }
    await preferences.setStringList("categories", categoriesList);

        setState(() {
          _jsonFunctions.getListOfProdCatIDs(_selectedItems)
              .then((value) {
            listOfProdCat = value;
          });
        });

  }

  void closeWelcomeScreen() {
    setState(() {
      _isLoading = false;
      widget.callback.loadingFinished();
      status = WelcomeStatus.noFirstTime;
    });
  }

  void animate() {
    isScrolling = false;
    if (_scrollController.hasClients  && _scrollController.position.pixels < _scrollController.position.maxScrollExtent) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 150),
      );
    }
  }

  firstAppStart() async {
    preferences = await SharedPreferences.getInstance();
    // await preferences.setBool("nofirstTime", false); // run welcome screen everytime

    var nofirstTime = preferences.getBool('nofirstTime');
    if (nofirstTime == null) {
      nofirstTime = false;
    }

    if (!nofirstTime) {
      await preferences.setBool("nofirstTime", true);
    } else {
      var categoriesList = preferences.getStringList("categories");
      if (categoriesList == null) {
        categoriesList = [];
      }
      for (int i = 0; i < categoriesList.length; i++) {
        selectCategory(int.parse(categoriesList[i]));
      }
    }
    setState(() {
      if (nofirstTime) {
        status = WelcomeStatus.noFirstTime;
      } else {
        status = WelcomeStatus.firstTime;
      }
    });
  }

  bool getLoading() {
    return _isLoading;
  }

  void setLoading(bool b) {
    _isLoading = b;
  }

  void currentCatId(indexItemBuilder) {
    categoryIdWebSocket = mainCategoryIds[indexItemBuilder];
  }

  void search(List<int> list, Product product) {
    for (int i = 0; i < list.length; i++) {
        if (!productIdList.contains(product.productId) && list[i] == product.categoryId) {
          newProducts.add(product);
          productIdList.add(product.productId);
        }
    }
  }

}

enum WelcomeStatus { loading, firstTime, noFirstTime, finished }
