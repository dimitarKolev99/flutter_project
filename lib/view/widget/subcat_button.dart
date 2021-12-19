import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:penny_pincher/services/json_functions.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/view/theme.dart';
import 'package:penny_pincher/view/widget/tab_navigator.dart';

import '../browser_view.dart';

class SubcatButton extends StatefulWidget {
  final String categoryName;
  final int categoryId;
  bool show = false;
  bool _isProdCat = false;
  late final Stream<bool> stream;
  late final StreamController updateStream;
  final dynamic callback;


  SubcatButton({
    required this.categoryName,
    required this.categoryId,
    required this.stream,
    required this.updateStream,
    required this.callback,
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
            callback: widget.callback,));
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
        subCategoriesMap =
            json.getMapOfSubOrProductCategories(widget.categoryId, resultList);
      });
    }
  }

  getCats() {
    getSubCategories();
    mapToLists();
    listToButtons();
  }
  Color subCatcolor = Colors.blue;
  Color prodCatColor = Colors.blue;
  @override
  Widget build(BuildContext context) {

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
                if(prodCatColor == Colors.blue){
                  widget.callback.addCategory(widget.categoryName);
                  prodCatColor = Colors.red;
                  // function needed that leads to browser and shows results
                  widget.callback.updateBrowserblabla(widget.categoryId);
                  Navigator.pop(
                    context
                  );
                }
                else{
                  prodCatColor = Colors.blue;
                  widget.callback.deleteCategory(widget.categoryName);
                }
              }
              // Subcategories
              else if(subCatcolor == Colors.blue){ // blue = unselected
                widget.callback.addCategory(widget.categoryName);
                widget.show = !widget.show;
                subCatcolor = Colors.green;
              }
              else{  // selected
                widget.callback.deleteCategory(widget.categoryName);
                widget.show = !widget.show;
                subCatcolor = Colors.blue;
              }
             }
            );
          },
          child: Container(
            color: widget._isProdCat ? prodCatColor : subCatcolor,
            height: 50,
            margin: EdgeInsets.all(4),
            child: Text(widget.categoryName),
          )
        ),

              Visibility(
                visible: widget.show,
                child: Container(
                  height: 300,
                  margin: EdgeInsets.only(left: 5),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: ThemeChanger.articlecardbackground,
                    border: Border(
                      bottom: BorderSide(
                        color: ThemeChanger.highlightedColor,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child:
     FutureBuilder(
                 future: getCats(),
                 builder: (context, snapshot) {
    return
    ListView.builder(
    itemCount: subCatButtons.length,
    itemBuilder: (context, index) {
   // print("length of categories : ${subCatButtons.length}");
    return subCatButtons[index];
    },
    );}
    )))]);
    }








      }

