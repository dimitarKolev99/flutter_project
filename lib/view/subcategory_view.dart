import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:penny_pincher/models/preferences_searches.dart';
import 'package:penny_pincher/services/json_functions.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/view/theme.dart';
import 'package:penny_pincher/view/widget/app_bar_navigator.dart';
import 'package:penny_pincher/view/widget/subcat_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubcategoryView extends StatefulWidget {

  // Specific fields
  int categoryId;
  String categoryName;
  var startValue = 0;
  var endValue = 4900;
  int saving = 0;
  int minPrice = 0;
  int maxPrice = 0;

  // Discount options combined with a boolean for when chosen
  var discounts = [
    [10, false],
    [20, false],
    [30, false],
    [40, false],
    [50, false],
  ];


  //values for the left and right output of the slider
  late RangeValues currentSliderValuesPrice;



  // names and Ids have matching indexes for name and id of the category
  List<String> subCategoriesNames = [];
  List<int> subCategoriesIds = [];

  @observable
  ObservableList<SubcatButton> subCatButtons = new ObservableList();


  // boolean Variable used to hide the Price Slider and Discounts
  bool _hide = true;

  Map<String, int> subCategoriesMap = new Map();
  late final Stream<bool> stream;
  late final StreamController updateStream;
  final dynamic callback;
  ScrollController _scrollController = ScrollController();
  late var state;
  Map<String, dynamic> chosenCats = new Map();
  Map<String, dynamic> checkedButtons = new Map();

  SubcategoryView.fromSave(
      this.categoryId,
      this.categoryName,
      this.startValue,
      this.endValue,
      this.saving,
      this.minPrice,
      this.maxPrice,
      int dscnt,
      double rangeMin,
      double rangeMax,
      this.chosenCats,
      this.checkedButtons,
      this.stream,
      this.updateStream,
      this.callback)
  {
    if(dscnt!=0) this.discounts[dscnt][1] = true;
    currentSliderValuesPrice = RangeValues(rangeMin, rangeMax);
  }


  SubcategoryView(this.categoryId, this.categoryName, this.stream, this.updateStream, this.callback) {
    currentSliderValuesPrice = RangeValues(00, 70);
  }


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

  JsonFunctions json = JsonFunctions();

  @override
  void initState() {
    setState(() {});
    widget.state = this;
  }

  Future<void> listToButtons() async {
    if (widget.subCatButtons.isEmpty) {
      for (int i = 0; i < widget.subCategoriesNames.length; i++) {
          widget.subCatButtons.add(SubcatButton(
          widget.subCategoriesNames[i],
          widget.subCategoriesIds[i],
          widget.stream,
          widget.updateStream,
          widget.callback,
          widget,
          widget._scrollController,
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
    widget.state = this;
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
                            height: 40,
                            child: ListView.builder(
                                physics: ScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: 11,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {
                                        setState(() {
                                          //TODO: if Main category changed Producs of old selection still there
                                          widget.callback.numberOfProducts = 0;
                                          Map<String, int> mapReplacement = new Map();
                                          widget.callback.mapOfChosenCategories = mapReplacement;
                                          widget.categoryId = widget
                                              .callback.widget.mainCategoryIds[index];
                                          widget.callback.bargainsOfChosenCats.clear();
                                          //print(
                                            //  "lasdköjflöaksjf ${widget.callback.widget.mainCategoryIds[index]}");
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
                                            color: widget.callback.widget.mainCategoryNames[index] == widget.categoryName ? ThemeChanger.highlightedColor : ThemeChanger.articlecardbackground,
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
                      padding: EdgeInsets.symmetric(horizontal: blockSizeHorizontal * 2),
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
                                    values: widget.currentSliderValuesPrice,
                                    min: 0,
                                    max: 100,
                                    divisions: 100,
                                    onChanged: (RangeValues values) {
                                      setState(() {
                                        widget.currentSliderValuesPrice = values;
                                      // values change exponentially and not linear.
                                      widget.startValue = pow(widget.currentSliderValuesPrice.start, 2).round();
                                      widget.endValue = pow(widget.currentSliderValuesPrice.end, 2).round();
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
                                        List.generate(widget.discounts.length, (index) {
                                          return Container(
                                            alignment: Alignment.center,
                                            width: blockSizeHorizontal * 13,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              // When a discount circle is clicked
                                              color: (widget.discounts[index][1] == true)
                                                  ? ThemeChanger.highlightedColor
                                                  : ThemeChanger.lightBlue,
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                // When a discount circle is clicked
                                                setState(() {
                                                  if (widget.discounts[index][1] == false) {
                                                    // Only one discount can be selected
                                                    for (var discount in widget.discounts) {
                                                      discount[1] = false;
                                                    }
                                                    widget.discounts[index][1] = true;
                                                    widget.saving = widget.discounts[index][0] as int;
                                                  } else {
                                                    widget.discounts[index][1] = false;
                                                    widget.saving = 0;
                                                  }
                                                });


                                                setState(() {
                                                  widget.callback.setSaving(widget.saving);
                                                  widget.callback.changePrice();
                                                });
                                              },
                                              child: Text(
                                                ">" + widget.discounts[index][0].toString() + "%",
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
                          Divider(
                            color: Colors.black,
                          ),
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
                                  itemCount: widget.subCatButtons.length+1,
                                  itemBuilder: (context, index) {
                                    // print("length of categories : ${subCatButtons.length}");
                                    if(index<widget.subCatButtons.length) {
                                      return widget.subCatButtons[index];
                                    } else {
                                      return SizedBox(
                                        height: 50,

                                      );
                                    }
                                  });
                            })),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(right: 4),
                  child:Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: (){
                    setState(() {
                      // TODO: widget.callback.currentCategory should be a collection of all chosen Categories
                      // TODO: show products of all categories
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
                ),),
        Container(
          margin: EdgeInsets.only(left: 4),
          child: Align(
                  alignment: Alignment.bottomLeft,
                  child: TextButton(onPressed: () async {
                    TextEditingController _textFieldController = TextEditingController();

                    return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text('Suche Speichern'), Icon(Icons.bookmarks_outlined)],),
                          content: TextField(
                            controller: _textFieldController,
                            decoration: InputDecoration(hintText: "Gib einen Namen für deine Suche ein"),
                          ),
                          actions: <Widget>[

                              TextButton(
                                child: Text('Abbrechen', style: TextStyle(color: ThemeChanger.lightBlue),),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(

                                child: Text('OK', style: TextStyle(color: ThemeChanger.lightBlue),),
                                onPressed: () {

                                  PreferencesSearch prefs = new PreferencesSearch();
                                  prefs.addSearch(widget, _textFieldController.text, widget.callback.mapOfChosenCategories);

                                  clearUnCheckedButtons(widget.subCatButtons);


                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                      },
                    );
                  },
                      style: TextButton.styleFrom(backgroundColor: ThemeChanger.lightBlue),
                      child: Text("Suche Speichern",
                        style: TextStyle(color: Colors.white),)),
                ),),

              ],
            )
            // Everything shown in body
          );


  }
  void clearUnCheckedButtons(ObservableList<SubcatButton> buttons) {
    for(SubcatButton sub in buttons) {
      if(!sub.giveColor()) widget.checkedButtons.remove(sub.categoryName);
      clearUnCheckedButtons(sub.subCatButtons);
    }
  }
}
