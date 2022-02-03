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
  bool isProdCat = false;
  bool isChosen = false;
  late final Stream<bool> stream;
  late final StreamController updateStream;
  final dynamic callback;
  final dynamic cBackToView;
  final ScrollController controller;
  List<String> subCategoriesNames = [];
  List<int> subCategoriesIds = [];

  late Color subCatcolor;
  late Color prodCatColor;
  late Color textColor;
  @observable
  ObservableList<SubcatButton> subCatButtons = new ObservableList();

  SubcatButton(
    this.categoryName,
    this.categoryId,
    this.stream,
    this.updateStream,
    this.callback,
    this.cBackToView,
    this.controller,
    //required this.isProdCat,
      ){
    if(cBackToView.chosenCats.containsValue(categoryId) || cBackToView.checkedButtons.containsValue(categoryId)) isChosen = true;
    isProdCat = cBackToView.chosenCats.containsValue(categoryId);

    subCatcolor = isChosen ? ThemeChanger.lightBlue : ThemeChanger.articlecardbackground;
    prodCatColor = isChosen ? ThemeChanger.highlightedColor : ThemeChanger.articlecardbackground;
    textColor = isChosen ? ThemeChanger.articlecardbackground : ThemeChanger.catTextColor;

  }

  @override
  State<StatefulWidget> createState() => _SubcatButtonState();

  removeFromBrowser(String name) {
    for (var element in subCatButtons) {
      if(element.categoryName == name) {
        element.isChosen = false;
        return;
      }
      element.removeFromBrowser(name);
    }
  }

  bool giveColor() {

    for (var element in subCatButtons) {
      if (element.isChosen && element.isProdCat) {
        return true;
      } else {
        if(element.giveColor()) return true;
      }
    }

    return false;
  }

}

class _SubcatButtonState extends State<SubcatButton> {
  Map<String, int> subCategoriesMap = new Map();
  // names and Ids have matching indexes for name and id of the category

  JsonFunctions json = JsonFunctions();


  Future<void> listToButtons() async{
    if(widget.subCatButtons.isEmpty) {
      for (int i = 0; i < widget.subCategoriesNames.length; i++) {
        widget.subCatButtons.add(
            SubcatButton(widget.subCategoriesNames[i],
              widget.subCategoriesIds[i],
              widget.stream,
              widget.updateStream,
            widget.callback,
            widget.cBackToView,
            widget.controller));
      }
    }
  }

  Future<void> mapToLists() async {
    if(widget.subCategoriesNames.isEmpty) {
      subCategoriesMap.forEach((name, id) {
        widget.subCategoriesNames.add(name);
        widget.subCategoriesIds.add(id);
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



  @override
  Widget build(BuildContext context) {

    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[

          InkWell(
          onTap: (){
            getCats();
            setState(() {
                // if empty chosen category = Productcategory
                if(widget.subCatButtons.isEmpty){
                  widget.isProdCat = true;
                  if(widget.isChosen == false){ //unselected
                    widget.isChosen = !widget.isChosen;
                    widget.callback.addCategory(widget.categoryName, widget.categoryId);
                    widget.prodCatColor = ThemeChanger.highlightedColor;
                    widget.textColor = ThemeChanger.textColor;
                    // function needed that leads to browser and shows results
                    // TODO: Add CategoryIDs to a Collection ,
                    // TODO: Call Json Function to updayte the resultList and Update Button Text
                    widget.callback.currentCategory = widget.categoryId;
                    widget.callback.addProductsOfChosenCategory(widget.categoryId);
                  }
                  else{
                    widget.isChosen = !widget.isChosen;
                    //print("try to remove : ! ${widget.categoryName}");
                    widget.callback.removeOneCategory(widget.categoryName);
                    widget.prodCatColor = ThemeChanger.articlecardbackground;
                    widget.textColor = ThemeChanger.catTextColor;
                    widget.callback.deleteProductsOfChosenCategoryFromView(widget.categoryId);
                  }


                }
                // Subcategories
                else {
                  if(widget.show == false){ // unselected
                    //widget.callback.addCategory(widget.categoryName);
                    widget.isChosen = !widget.isChosen;
                    widget.show = !widget.show;
                    widget.subCatcolor = ThemeChanger.lightBlue;
                    widget.textColor = ThemeChanger.textColor;
                    widget.cBackToView.checkedButtons[widget.categoryName] = widget.categoryId;
                    print(widget.cBackToView.checkedButtons[widget.categoryName]);
                  }
                  else{  // selected
                    widget.isChosen = !widget.isChosen;
                    widget.subCatcolor = widget.giveColor() ? ThemeChanger.lightBlue : ThemeChanger.articlecardbackground;
                    widget.show = !widget.show;
                    widget.textColor = widget.giveColor() ? ThemeChanger.textColor : ThemeChanger.catTextColor;
                    if(!widget.giveColor()) widget.cBackToView.chosenCats.remove(widget.categoryName);
                   // widget.callback.removeOneCategory(widget.categoryName);
                  }
                }
               widget.cBackToView.state.setState(() { });
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
              color: widget.isProdCat ? widget.prodCatColor : widget.subCatcolor,
              border: Border.all(
                  color: Colors.blueGrey,
                  width: 1,
              ),
            ),
            child: Row(
              children: [Text(widget.categoryName, style:
              TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: widget.textColor,
              ),
            textAlign: TextAlign.left,
            ),
              if(widget.show) Icon(Icons.arrow_drop_up, size: 25),
              ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      itemCount: widget.subCatButtons.length,
      itemBuilder: (context, index) {
      return widget.subCatButtons[index];
    },
    );}
    )))]);
    }








      }

