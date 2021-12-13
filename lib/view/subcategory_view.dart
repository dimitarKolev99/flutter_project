import 'dart:async';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:penny_pincher/services/json_functions.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/view/theme.dart';
import 'package:penny_pincher/view/widget/subcat_button.dart';

class SubcategoryView extends StatefulWidget{
  int categoryId;
  String categoryName;


  SubcategoryView({
    required this.categoryId,
    required this.categoryName,
  });


  @override
  State<StatefulWidget> createState() => _SubcategoryViewState();


  }

class _SubcategoryViewState extends State<SubcategoryView>{
  JsonFunctions json = JsonFunctions();


  Map<String, int> subCategoriesMap = new Map();
  // names and Ids have matching indexes for name and id of the category
  List<String> subCategoriesNames = [];
  List<int> subCategoriesIds = [];
  @observable
  ObservableList<SubcatButton> subCatButtons = new ObservableList();
  //List<SubcatButton> subCatButtons = [];


  Future<void> listToButtons() async{
    if(subCatButtons.isEmpty) {
      for (int i = 0; i < subCategoriesNames.length; i++) {
        subCatButtons.add(
            SubcatButton(categoryName: subCategoriesNames[i], categoryId: subCategoriesIds[i]));
      }
    }
  }

  Future<void> mapToLists() async {
    if(subCategoriesNames.isEmpty) {
      subCategoriesMap.forEach((name, id) {
        subCategoriesNames.add(name);
        subCategoriesIds.add(id);
       // print("added $name addedID $id");
      });
    }
  }

  Future<void> getSubCategories() async{
    //print("category ID view!!! :_______   ${widget.categoryId}");
    if(subCategoriesMap.isEmpty) {
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
    Widget build (BuildContext context){

    // This method fills the List subCategories for the clicked main Categories -> To show subcategories on the first Category
    MediaQueryData _mediaQueryData;
    double displayWidth;
    double displayHeight;
    _mediaQueryData = MediaQuery.of(context);
    displayWidth = _mediaQueryData.size.width;
    displayHeight = _mediaQueryData.size.height;
    //print("button Created");


    return
      Scaffold(
          appBar: AppBar(
              backgroundColor: ThemeChanger.navBarColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 3),
                    child:
                    Text(
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
                        decoration:
                        TextDecoration.underline,
                        decorationColor: ThemeChanger.highlightedColor,
                        decorationThickness: 4,
                      ),
                    ),),
                ],
              )),
          body:
              // Waits for the lists of categories before it builds the widgets
              FutureBuilder(
                future: getCats(),
                builder: (context, snapshot){
                  return
                ListView.builder(
                    itemCount: subCatButtons.length,
                    itemBuilder: (context, index) {
                     // print("length of categories : ${subCatButtons.length}");
                      return subCatButtons[index];
                    });
                }
                )
              );
  }
}

