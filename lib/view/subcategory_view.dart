import 'dart:async';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:penny_pincher/services/json_functions.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/view/theme.dart';
import 'package:penny_pincher/view/widget/subcat_button.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class SubcategoryView extends StatefulWidget {
  int categoryId;
  String categoryName;
  late final Stream<bool> stream;
  late final StreamController updateStream;
  final dynamic callback;
  ScrollController _scrollController = ScrollController();


  SubcategoryView({
    required this.categoryId,
    required this.categoryName,
    required this.stream,
    required this.updateStream,
    required this.callback,
  });

  @override
  State<StatefulWidget> createState() => _SubcategoryViewState();
}

class _SubcategoryViewState extends State<SubcategoryView> {
  var minValue = 400;
  var maxValue = 2500;
  RangeValues _currentSliderValuesPrice = const RangeValues(20, 50);


  // Discount options combined with a boolean for when chosen
  var discounts = [
    [10, false],
    [20, false],
    [30, false],
    [40, false],
    [50, false]
  ];

  // boolean Variable used to hide the Price Slider and Discounts
  bool _hide = true;

  JsonFunctions json = JsonFunctions();

  Map<String, int> subCategoriesMap = new Map();

  // names and Ids have matching indexes for name and id of the category
  List<String> subCategoriesNames = [];
  List<int> subCategoriesIds = [];
  @observable
  ObservableList<SubcatButton> subCatButtons = new ObservableList();

  //List<SubcatButton> subCatButtons = [];

  Future<void> listToButtons() async {
    if (subCatButtons.isEmpty) {
      for (int i = 0; i < subCategoriesNames.length; i++) {
        subCatButtons.add(SubcatButton(
          categoryName: subCategoriesNames[i],
          categoryId: subCategoriesIds[i],
          stream: widget.stream,
          updateStream: widget.updateStream,
          callback: widget.callback,
          controller: widget._scrollController,
        ));
      }
    }
  }

  Future<void> mapToLists() async {
    if (subCategoriesNames.isEmpty) {
      subCategoriesMap.forEach((name, id) {
        subCategoriesNames.add(name);
        subCategoriesIds.add(id);
        // print("added $name addedID $id");
      });
    }
  }

  Future<void> getSubCategories() async {
    //print("category ID view!!! :_______   ${widget.categoryId}");
    if (subCategoriesMap.isEmpty) {
      json.getJson().then((List<dynamic> result) {
        List<dynamic> resultList = [];
        resultList = result;
        subCategoriesMap =
            json.getMapOfSubOrProductCategories(widget.categoryId, resultList);
      });
      // print("subCategoriesMap.lengthsubCategoriesMap.length ${subCategoriesMap.length}");
    }
  }

  Future<void> getCats() async {
    await getSubCategories();
    await mapToLists();
    await listToButtons();
  }

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
    safeBlockHorizontal = (displayWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (displayHeight - _safeAreaVertical) / 100;
    ScrollController _scrollController = ScrollController();
    return Scaffold(
        appBar: AppBar(
            backgroundColor: ThemeChanger.navBarColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Text(
                    'Categories',
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
                      decoration: TextDecoration.underline,
                      decorationColor: ThemeChanger.highlightedColor,
                      decorationThickness: 4,
                    ),
                  ),
                ),
              ],
            )),
        body:
            Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Main Categories
                    Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                            color: ThemeChanger.lightBlue,
                            height: 40,
                            child: ListView.builder(
                                physics: ScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: 10,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {
                                        setState(() {
                                          widget.categoryId = widget
                                              .callback.widget.mainCategoryIds[index];
                                          print(
                                              "lasdköjflöaksjf ${widget.callback.widget.mainCategoryIds[index]}");
                                          widget.callback.chosenCategories.clear();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => SubcategoryView(
                                                  categoryName: widget.callback.widget
                                                      .mainCategoryNames[index],
                                                  categoryId: widget.callback.widget
                                                      .mainCategoryIds[index],
                                                  stream: widget.stream,
                                                  updateStream: widget.updateStream,
                                                  callback: widget.callback,
                                                ),
                                              ));
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: ThemeChanger.articlecardbackground,
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                        alignment: Alignment.centerRight,
                                        margin: EdgeInsets.all(4),
                                        //padding: EdgeInsets.all(4),
                                        padding: EdgeInsets.symmetric(horizontal: 6),
                                        height: 40,
                                        child: Text(
                                          widget
                                              .callback.widget.mainCategoryNames[index],
                                          style: TextStyle(
                                            color: ThemeChanger.reversetextColor,
                                          ),
                                        ),
                                      ));
                                }))),

                    // Price and Discount
                    Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: blockSizeHorizontal * 2),
                      child: Column(
                        children: [
                          RangeSlider(
                            activeColor: ThemeChanger.navBarColor,
                            //inactiveColor: ProductApi.orange,
                            values: _currentSliderValuesPrice,
                            min: 0,
                            max: 100,
                            divisions: 100,
                            onChanged: (RangeValues values) {
                              setState(() {
                                _currentSliderValuesPrice = values;
                                minValue = pow(_currentSliderValuesPrice.start, 2).round();
                                maxValue = pow(_currentSliderValuesPrice.end, 2).round();
                              });
                            },
                          ),

                          // Output of Price-Slider
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // Linke Output
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: blockSizeVertical * 2),
                                padding: EdgeInsets.only(
                                    top: blockSizeVertical * 1,
                                    bottom: blockSizeVertical * 1,
                                    left: blockSizeHorizontal * 3,
                                    right: blockSizeHorizontal * 3),
                                decoration: BoxDecoration(
                                  color: ThemeChanger.lightBlue,
                                  borderRadius: BorderRadius.circular(
                                      blockSizeHorizontal * 3),
                                ),
                                child: Text(minValue.toString() + " €",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: safeBlockHorizontal * 4.8,
                                    color: ThemeChanger.textColor,
                                    //backgroundColor: ProductApi.lightBlue,
                                  ),
                                ),
                              ]),

                              // Rechte Output
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: blockSizeVertical * 2),
                                padding: EdgeInsets.only(
                                    top: blockSizeVertical * 1,
                                    bottom: blockSizeVertical * 1,
                                    left: blockSizeHorizontal * 3,
                                    right: blockSizeHorizontal * 3),
                                decoration: BoxDecoration(
                                  color: ThemeChanger.lightBlue,
                                  borderRadius: BorderRadius.circular(
                                      blockSizeHorizontal * 3),
                                ),
                                child: Text(maxValue.toString() + " €",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: safeBlockHorizontal * 4.8,
                                    color: ThemeChanger.textColor,
                                    //backgroundColor: ProductApi.lightBlue,
                                  ),

                                  // Output of Price-Slider
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      // Linke Output
                                      Container(
                                        margin: EdgeInsets.only(
                                            bottom: blockSizeVertical * 2),
                                        padding: EdgeInsets.only(
                                            top: blockSizeVertical * 1,
                                            bottom: blockSizeVertical * 1,
                                            left: blockSizeHorizontal * 3,
                                            right: blockSizeHorizontal * 3),
                                        decoration: BoxDecoration(
                                          color: ThemeChanger.lightBlue,
                                          borderRadius: BorderRadius.circular(
                                              blockSizeHorizontal * 3),
                                        ),
                                        child: Text(
                                          _currentSliderValuesPrice.start
                                              .round()
                                              .toString() +
                                              " €",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: safeBlockHorizontal * 4.8,
                                            color: ThemeChanger.textColor,
                                            //backgroundColor: ProductApi.lightBlue,
                                          ),
                                        ),
                                      ),

                                      // Rechte Output
                                      Container(
                                        margin: EdgeInsets.only(
                                            bottom: blockSizeVertical * 2),
                                        padding: EdgeInsets.only(
                                            top: blockSizeVertical * 1,
                                            bottom: blockSizeVertical * 1,
                                            left: blockSizeHorizontal * 3,
                                            right: blockSizeHorizontal * 3),
                                        decoration: BoxDecoration(
                                          color: ThemeChanger.lightBlue,
                                          borderRadius: BorderRadius.circular(
                                              blockSizeHorizontal * 3),
                                        ),
                                        child: Text(
                                          _currentSliderValuesPrice.end
                                              .round()
                                              .toString() +
                                              " €",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: safeBlockHorizontal * 4.8,
                                            color: ThemeChanger.textColor,
                                            //backgroundColor: ProductApi.lightBlue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Title for Discount Options
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Rabatte",
                                          style: TextStyle(
                                            color: ThemeChanger.navBarColor,
                                            //fontWeight: FontWeight.bold,
                                            fontSize: safeBlockHorizontal * 5,
                                          )),
                                    ],
                                  ),

                                  // Discount Options
                                  Container(
                                    height: blockSizeVertical * 10,
                                    //color: Colors.amberAccent,
                                    child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children:
                                        List.generate(discounts.length, (index) {
                                          return Container(
                                            alignment: Alignment.center,
                                            width: blockSizeHorizontal * 12,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              // When a discount circle is clicked
                                              color: (discounts[index][1] == true)
                                                  ? ThemeChanger.highlightedColor
                                                  : ThemeChanger.lightBlue,
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                // When a discount circle is clicked
                                                setState(() {
                                                  if (discounts[index][1] == false) {
                                                    // Only one discount can be selected
                                                    for (var discount in discounts) {
                                                      discount[1] = false;
                                                    }
                                                    discounts[index][1] = true;
                                                  } else {
                                                    discounts[index][1] = false;
                                                  }
                                                });
                                              },
                                              child: Text(
                                                discounts[index][0].toString() + "%",
                                                style: TextStyle(
                                                  color: ThemeChanger
                                                      .articlecardbackground,
                                                  fontSize: safeBlockHorizontal * 3.9,
                                                ),
                                              ),
                                            ),
                                          );
                                        })),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),

                    //Kategorien Titel
                    Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: blockSizeHorizontal * 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Kategorien",
                              style: TextStyle(
                                color: ThemeChanger.navBarColor,
                                //fontWeight: FontWeight.bold,
                                fontSize: safeBlockHorizontal * 5,
                              )),
                          Text(
                            "31754 Produkte",
                            style: TextStyle(
                                color: ThemeChanger.navBarColor,
                                //fontWeight: FontWeight.bold,
                                fontSize: safeBlockHorizontal * 3),
                          ),
                        ],
                      ),
                    ),

                    // Waits for the lists of categories before it builds the widgets
                    Expanded(
                        child: FutureBuilder(
                            future: getCats(),
                            builder: (context, snapshot) {
                              return ListView.builder(
                                  controller: _scrollController,
                                  itemCount: subCatButtons.length,
                                  itemBuilder: (context, index) {
                                    // print("length of categories : ${subCatButtons.length}");
                                    return subCatButtons[index];
                                  });
                            })),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(onPressed: (){
                    setState(() {
                      // TODO: widget.callback.currentCategory should be a collection of all chosen Categories
                      // TODO: show products of all categories
                      print(widget.callback.currentCategory);
                      widget.callback.updateBrowserblabla(widget.callback.currentCategory);
                      Navigator.pop(
                          context
                      );
                    });

                  },
                      style: TextButton.styleFrom(backgroundColor: ThemeChanger.lightBlue),
                      child: Text("Zeige (10) Produkte",
                  style: TextStyle(color: Colors.white),)),
                )

              ],
            )
            // Everything shown in body
          );
  }
}
