import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:penny_pincher/models/preferences_articles.dart';
import 'package:penny_pincher/models/ws_product.dart';
import 'package:penny_pincher/services/product_controller.dart';
import 'package:penny_pincher/services/json_functions.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/services/product_controller_ws.dart';
import 'package:penny_pincher/view/extended_view_web_socket.dart';
import 'package:penny_pincher/view/theme.dart';
import 'package:penny_pincher/view/welcome_screen.dart';
import 'package:penny_pincher/view/widget/app_bar_navigator.dart';
import 'package:penny_pincher/view/widget/article_card.dart';
import 'package:penny_pincher/view/widget/article_search.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:penny_pincher/view/extended_view.dart';
import 'package:penny_pincher/view/widget/new_article_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:web_socket_channel/web_socket_channel.dart';

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
  Map<String, int> subCategoriesMap = Map();
  // names and Ids have matching indexes for name and id of the category
  List<String> subCategoriesNames = [];
  List<int> subCategoriesIds = [];
  late int categoryId;
  late String categoryName;
  List<int> productCategoryIDs = [];
  List<int> productIdList = [];
 // bool check = false;

  ///NEW WEBSOCKET
  List<ProductWS> filteredProducts = [];
  late int categoryIdWebSocket = 0;
  List<ProductWS> result = [];
  late int indexItemBuilder;


  //when map is empty then json funtions is called
  Future<void> getSubCategories() async{
    if(subCategoriesMap.isEmpty) {
      json.getJson().then((List<dynamic> result) {
        List<dynamic> resultList = [];
        resultList = result;
        subCategoriesMap = json.getMapOfSubOrProductCategories(categoryId, resultList);
      });
    }
    if(subCategoriesMap.isNotEmpty) {
      subCategoriesMap.clear();
      json.getJson().then((List<dynamic> result) {
        List<dynamic> resultList = [];
        resultList = result;
        subCategoriesMap = json.getMapOfSubOrProductCategories(categoryId, resultList);
      });
    }
  }


  //seperate the sub map into 2 lists 1 with names and 1 with ids
  Future<void> mapToLists() async {
    if(subCategoriesNames.isEmpty) {
     // print("mapToLists Is emtpy");
      subCategoriesMap.forEach((name, id) {
        subCategoriesNames.add(name);
        subCategoriesIds.add(id);
      //  print("added $name");
      });
    }
    if (subCategoriesNames.isNotEmpty) {
    //  print("mapToLists Its Not Empty");
      subCategoriesNames.clear();
      subCategoriesIds.clear();
        subCategoriesMap.forEach((name, id) {
        subCategoriesNames.add(name);
        subCategoriesIds.add(id);
      //  print("added $name");
     //   print("added $id");
      });
    }
  }



  StreamController<bool> streamController = StreamController<bool>.broadcast();


  late List<Product> _product;

  late List<ProductWS> newProduct;

  late final List _favoriteIds = [];
  late final List<Product> _products = [];
  late final List<ProductWS> newProducts = [];
  bool _isLoading = true;
  var count = 0;
  bool isScrolling = false;
  final ScrollController _scrollController = ScrollController();
  var x = 0.0;
  WelcomeStatus status = WelcomeStatus.loading;
  dynamic preferences;

  //var screenHeight = ;

  final _preferenceArticles = PreferencesArticles();
  final _jsonFunctions = JsonFunctions();
  var index = 0;
  var randomCategory = 0;
  bool loadingProducts = false;

  final List<int> _selectedItems = [];

  final channel = WebSocketChannel.connect(
    Uri.parse('wss://ika3taif23.execute-api.eu-central-1.amazonaws.com/prod'),
  );

  _onUpdateScroll() {
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
        ProductController.updateFavorites(this);
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

  @override
  void dispose() {
    super.dispose();
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

    displayHeight = x;

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
            child: Icon(Icons.search, color: Colors.grey, size: 100)),
      );
    } else {
      return Scaffold(
          appBar: HomeBrowserAppBar(this),
          body:
          //_isLoading ? Center(child: CircularProgressIndicator()) :
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  color: ThemeChanger.lightBlue,
                  height: 40,
                  width: displayWidth,
                  child: ListView.builder(
                      physics: ScrollPhysics(),
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
                          if (scrollNotification is ScrollUpdateNotification) {
                            _onUpdateScroll();
                          }
                          return true;
                        },
                        child: StreamBuilder(
                          stream: channel.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              animate();
                              search(listOfProdCat, productFromJson(snapshot.data.toString()));
                              ProductControllerWS.addProductsWS(newProducts);
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
                                                    ExtendenViewWebSocket(
                                                        newProducts[index],
                                                        //this,
                                                        streamController
                                                            .stream)),
                                          );
                                        },
                                        child:
                                        NewArticleCard(newProducts[index]));
                                  });
                            } else {
                              return const Text("no data");
                            }
                          },
                        ),

                      )),
                  Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.add, color: Colors.black)
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

  Future<void> selectCategory(index) async {
    mainCategories[index];
    categoryId = mainCategoryIds[index];
    //  print("categoryid = ${categoryId}");

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
      _jsonFunctions.getListOfProdCatIDs(mainCategoryIds.indexOf(categoryId))
          .then((value) {
        //timerFunction(value);
        //_jsonFunctions.count = 1;
        // print("AAAAAA $_jsonFunctions.count");
        listOfProdCat = value;
      });
    });

    //print("subCategoryMAP = ${subCategoriesMap}");
    //print("subCategoryID = ${subCategoriesIds}");
  }

  void closeWelcomeScreen() {
    setState(() {
      _isLoading = false;
      widget.callback.loadingFinished();
      status = WelcomeStatus.noFirstTime;
    });
  }

  void animate() {
    if (_scrollController.hasClients  && _scrollController.position.pixels < _scrollController.position.maxScrollExtent) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
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
   // print("categoryIdWebSocket ===> $categoryIdWebSocket");
  }

  void search(List<int> list, ProductWS product) {
    for (int i = 0; i < list.length; i++) {
        if (!productIdList.contains(product.productId) && list[i] == product.categoryId) {
          newProducts.add(product);
          productIdList.add(product.productId);
        }
    }
  }

}

enum WelcomeStatus { loading, firstTime, noFirstTime, finished }
