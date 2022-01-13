import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:penny_pincher/services/json_functions.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/view/theme.dart';
import 'package:penny_pincher/view/widget/tab_navigator.dart';
import 'package:provider/provider.dart';

import '../browser_view.dart';

class SubcatButton extends StatefulWidget {
  final String categoryName;
  final int categoryId;
  bool show = false;
  bool _isProdCat = false;
  bool _isChosen = false;
  late final Stream<bool> stream;
  late final StreamController updateStream;
  final dynamic callback;
  final dynamic cBackToView;
  final ScrollController controller;


  SubcatButton({
    required this.categoryName,
    required this.categoryId,
    required this.stream,
    required this.updateStream,
    required this.callback,
    required this.cBackToView,
    required this.controller,
    //required this.isProdCat,
  });

  @override
  State<StatefulWidget> createState() => _SubcatButtonState();

}

class _SubcatButtonState extends State<SubcatButton> {
  Map<String, int> subCategoriesMap = new Map();
  // names and Ids have matching indexes for name and id of the category
  List<String> subCategoriesNames = [];
  List<int> subCategoriesIds = [];
  JsonFunctions json = JsonFunctions();
  @observable
  ObservableList<SubcatButton> subCatButtons = new ObservableList();

  Future<void> listToButtons() async{
    if(subCatButtons.isEmpty) {
      for (int i = 0; i < subCategoriesNames.length; i++) {
        subCatButtons.add(
            SubcatButton(categoryName: subCategoriesNames[i],
              categoryId: subCategoriesIds[i],
              stream: widget.stream,
              updateStream: widget.updateStream,
            callback: widget.callback,
            cBackToView: widget.cBackToView,
            controller: widget.controller));
      }
    }
  }

  Future<void> mapToLists() async {
    if(subCategoriesNames.isEmpty) {
      subCategoriesMap.forEach((name, id) {
        subCategoriesNames.add(name);
        subCategoriesIds.add(id);
       // print("added $name");
      });
    }
  }

  Future<void> getSubCategories() async{
    if(subCategoriesMap.isEmpty) {
      json.getJson().then((List<dynamic> result) {
        List<dynamic> resultList = [];
        resultList = result;
        subCategoriesMap = json.getMapOfSubOrProductCategories(widget.categoryId, resultList);
      });
    }
  }

  getCats() {
    getSubCategories();
    mapToLists();
    listToButtons();
  }
  late Color subCatcolor = widget._isChosen ? ThemeChanger.lightBlue : ThemeChanger.articlecardbackground;
  late Color prodCatColor = widget._isChosen ? ThemeChanger.highlightedColor : ThemeChanger.articlecardbackground;
  late Color textColor = widget._isChosen ? ThemeChanger.articlecardbackground : ThemeChanger.catTextColor;
  @override
  Widget build(BuildContext context) {

    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[

          InkWell(
          onTap: (){
            setState(() {
               getCats();
                // if empty chosen category = Productcategory
                if(subCatButtons.isEmpty){
                  widget._isProdCat = true;
                  if(widget._isChosen == false){ //unselected
                    widget._isChosen = !widget._isChosen;
                    widget.callback.addCategory(widget.categoryName, widget.categoryId);
                    prodCatColor = ThemeChanger.highlightedColor;
                    textColor = ThemeChanger.textColor;
                    // function needed that leads to browser and shows results
                    // TODO: Add CategoryIDs to a Collection ,
                    // TODO: Call Json Function to updayte the resultList and Update Button Text
                    widget.callback.currentCategory = widget.categoryId;
                    widget.callback.addProductsOfChosenCategory(widget.categoryId);
                    widget.cBackToView.setState(() {});

                  }
                  else{
                    widget._isChosen = !widget._isChosen;
                    //print("try to remove : ! ${widget.categoryName}");
                    widget.callback.removeOneCategory(widget.categoryName);
                    prodCatColor = ThemeChanger.articlecardbackground;
                    textColor = ThemeChanger.catTextColor;
                    widget.callback.deleteProductsOfChosenCategory(widget.categoryId);
                  }
                }
                // Subcategories
                else {
                  if(widget._isChosen == false){ // unselected
                    //widget.callback.addCategory(widget.categoryName);
                    widget._isChosen = !widget._isChosen;
                    widget.show = !widget.show;
                    subCatcolor = ThemeChanger.lightBlue;
                    textColor = ThemeChanger.textColor;
                  }
                  else{  // selected
                    widget._isChosen = !widget._isChosen;
                    subCatcolor = ThemeChanger.articlecardbackground;
                    widget.show = !widget.show;
                    textColor = ThemeChanger.catTextColor;
                   // widget.callback.removeOneCategory(widget.categoryName);
                  }
                }
            }
            );
          },
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(5),

            width: MediaQuery.of(context).size.width,
            height: 30,
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: widget._isProdCat ? prodCatColor : subCatcolor,
              border: Border.all(
                  color: Colors.blueGrey,
                  width: 1,
              ),
            ),
            child: Text(widget.categoryName, style:
              TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: textColor,
              ),
            textAlign: TextAlign.left,
            ),
          )
        ),

              Visibility(
                visible: widget.show,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  margin: EdgeInsets.only(left: 5),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: ThemeChanger.articlecardbackground,
                    border: Border(
                      bottom: BorderSide(
                        color: ThemeChanger.highlightedColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child:
     FutureBuilder(
                 future: getCats(),
                 builder: (context, snapshot) {
    return
    ListView.builder(
      controller: widget.controller,
      itemCount: subCatButtons.length,
      itemBuilder: (context, index) {
      return subCatButtons[index];
    },
    );}
    )))]);
    }








      }

