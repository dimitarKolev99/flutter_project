import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:penny_pincher/services/json_functions.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/view/theme.dart';
import 'package:penny_pincher/view/widget/app_bar_navigator.dart';
import 'package:penny_pincher/view/widget/subcat_button.dart';
import 'package:provider/provider.dart';

class SubcategoryView extends StatefulWidget {
  int categoryId;
  String categoryName;
  late final Stream<bool> stream;
  late final StreamController updateStream;
  final dynamic callback;
  ScrollController _scrollController = ScrollController();
  late var state;
  var startValue = 0;
  var endValue = 4900;
  int saving = 0;
  int minPrice = 0;
  int maxPrice = 0;
  bool _hide = true;
  Map<String, int> subCategoriesMap = new Map();


  // names and Ids have matching indexes for name and id of the category
  List<String> subCategoriesNames = [];
  List<int> subCategoriesIds = [];
  @observable
  ObservableList<SubcatButton> subCatButtons = new ObservableList();

  RangeValues _currentSliderValuesPrice = const RangeValues(00, 70);

  SubcategoryView(this.categoryId, this.categoryName, this.stream, this.updateStream, this.callback);


  @override
  State<StatefulWidget> createState() => _SubcategoryViewState();


  removeFromBrowser(String name) {
    for (var element in subCatButtons) {
      if(element.categoryName == name) {
        element.isChosen = false;
        return;
      }
      element.removeFromBrowser(name);
    }
  }
}

class _SubcategoryViewState extends State<SubcategoryView> {
  //values for the left and right output of the slider


  // Discount options combined with a boolean for when chosen
  var discounts = [
    [10, false],
    [20, false],
    [30, false],
    [40, false],
    [50, false]
  ];

  // boolean Variable used to hide the Price Slider and Discounts


  JsonFunctions json = JsonFunctions();

  //List<SubcatButton> subCatButtons = [];

  void initState() {
    setState(() {});
    widget.state = this;
  }

  Future<void> listToButtons() async {
    if (widget.subCatButtons.isEmpty) {
      for (int i = 0; i < widget.subCategoriesNames.length; i++) {
          widget.subCatButtons.add(SubcatButton(
          categoryName: widget.subCategoriesNames[i],
          categoryId: widget.subCategoriesIds[i],
          stream: widget.stream,
          updateStream: widget.updateStream,
          callback: widget.callback,
          cBackToView: widget,
          controller: widget._scrollController,
        ));
      }
    }
  }

  Future<void> mapToLists() async {
    if (widget.subCategoriesNames.isEmpty) {
      widget.subCategoriesMap.forEach((name, id) {
        widget.subCategoriesNames.add(name);
        widget.subCategoriesIds.add(id);
        // print("added $name addedID $id");
      });
    }
  }

  Future<void> getSubCategories() async {
    //print("category ID view!!! :_______   ${widget.categoryId}");
    if (widget.subCategoriesMap.isEmpty) {
      json.getJson().then((List<dynamic> result) {
        List<dynamic> resultList = [];
        resultList = result;
        widget.subCategoriesMap =
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
        appBar: CategorieViewAppBar(),
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
                            height: 35,
                            child: ListView.builder(
                                physics: ScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: 11,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {
                                        setState(() {
                                          widget.callback.numberOfProducts = 0;
                                          Map<String, int> mapReplacement = new Map();
                                          widget.callback.mapOfChosenCategories = mapReplacement;
                                          widget.categoryId = widget
                                              .callback.widget.mainCategoryIds[index];
                                          print(
                                              "lasdköjflöaksjf ${widget.callback.widget.mainCategoryIds[index]}");
                                          widget.callback.chosenCategories.clear();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                    widget.callback.view = SubcategoryView(
                                                      widget.callback.widget.mainCategoryIds[index],
                                                      widget.callback.widget.mainCategoryNames[index],
                                                      widget.stream,
                                                      widget.updateStream,
                                                      widget.callback,
                                                    );
                                                    widget.callback.numberOfProducts = 0;
                                                  return widget.callback.view;
                                                },
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
                                        child: Text(
                                          widget
                                              .callback.widget.mainCategoryNames[index],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: ThemeChanger.catTextColor,
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
                          // Title for Price-Slider
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //Headline: Price
                              children: [
                                Text("Preisklasse",
                                    style: TextStyle(
                                      color: ThemeChanger.catTextColor,
                                      //fontWeight: FontWeight.bold,
                                      fontSize: safeBlockHorizontal * 5,
                                    )),

                                    // Collapse-Unfold Icon
                                    IconButton(
                                      icon: Icon(widget._hide
                                          ? Icons.arrow_drop_down
                                          : Icons.arrow_drop_up,
                                      ),
                                      iconSize: blockSizeHorizontal * 10,
                                      tooltip: "Einklappen/Ausklappen",
                                      onPressed: () {
                                        setState(() {
                                          widget._hide = !widget._hide;
                                        });
                                      },
                                    ),
                              ]),

                          // PriceSlider
                          Visibility(
                              visible: !widget._hide,
                              child: Column(
                                children: [
                                  RangeSlider(
                                    inactiveColor: ThemeChanger.lightBlue,
                                    activeColor: ThemeChanger.catTextColor,
                                    values: widget._currentSliderValuesPrice,
                                    min: 0,
                                    max: 100,
                                    divisions: 100,
                                    onChanged: (RangeValues values) {
                                      setState(() {
                                        widget._currentSliderValuesPrice = values;
                                      // values change exponentially and not linear.
                                      widget.startValue = pow(widget._currentSliderValuesPrice.start, 2).round();
                                      widget.endValue = pow(widget._currentSliderValuesPrice.end, 2).round();
                                      //print("$startValue, $endValue" );
                                    });},
                                    onChangeEnd: (RangeValues values) {

                                      setState(() {
                                        widget.callback.setPriceRange(widget.startValue * 100, widget.endValue * 100);
                                        widget.callback.changePrice();
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
                                        child: Text(
                                          widget.startValue
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
                                          widget.endValue
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
                                            color: ThemeChanger.catTextColor,
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
                                            width: blockSizeHorizontal * 13,
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
                                                    widget.saving = discounts[index][0] as int;
                                                  } else {
                                                    discounts[index][1] = false;
                                                    widget.saving = 0;
                                                  }
                                                });


                                                setState(() {
                                                  widget.callback.setSaving(widget.saving);
                                                  widget.callback.changePrice();
                                                });
                                              },
                                              child: Text(
                                                ">" + discounts[index][0].toString() + "%",
                                                style: TextStyle(
                                                  color: ThemeChanger
                                                      .textColor,
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
                                color: ThemeChanger.catTextColor,
                                //fontWeight: FontWeight.bold,
                                fontSize: safeBlockHorizontal * 5,
                              )),
                          Text(
                            "31754 Produkte",
                            style: TextStyle(
                                color: ThemeChanger.catTextColor,
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
                                  itemCount: widget.subCatButtons.length,
                                  itemBuilder: (context, index) {
                                    // print("length of categories : ${subCatButtons.length}");
                                    return widget.subCatButtons[index];
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
                      //widget.callback.setPriceRange(startValue * 100, endValue * 100);
                      //widget.callback.setSaving(saving);
                      widget.callback.updateBrowserblabla(widget.callback.currentCategory);
                      Navigator.pop(
                          context
                      );
                    });

                  },
                      style: TextButton.styleFrom(backgroundColor: ThemeChanger.lightBlue),
                      child: Text("Zeige ${widget.callback.numberOfProducts} Produkte",
                  style: TextStyle(color: Colors.white),)),
                )

              ],
            )
            // Everything shown in body
          );
  }
}
