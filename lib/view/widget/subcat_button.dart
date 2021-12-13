import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:penny_pincher/services/json_functions.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/view/theme.dart';

class SubcatButton extends StatefulWidget {
  final String categoryName;
  final int categoryId;
  bool show = false;

  SubcatButton({
    required this.categoryName,
    required this.categoryId,
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
            SubcatButton(categoryName: subCategoriesNames[i], categoryId: subCategoriesIds[i],));
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
   // print("category ID !!! :_______   ${widget.categoryId}");

    if(subCategoriesMap.isEmpty) {
      json.getJson().then((List<dynamic> result) {
        List<dynamic> resultList = [];
        resultList = result;
        subCategoriesMap =
            json.getMapOfSubOrProductCategories(widget.categoryId, resultList);
       // print("s____________________________________>>>>>>>>>>>>${json.getMapOfSubOrProductCategories(widget.categoryId, resultList)}");
      });
     // print("subCategoriesMap.lengthsubCategoriesMap.length ${subCategoriesMap.length}");
    }
  }

  getCats() {
    getSubCategories();
    mapToLists();
    listToButtons();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          InkWell(
          onTap: (){
            setState(() {
              getCats();
             widget.show = !widget.show;
             print("${widget.show}");
            });
          },
          child: Container(
            color: Colors.orange,
            height: 50,
            margin: EdgeInsets.all(4),
            child: Text(widget.categoryName),
          )
        ),

              Visibility(
                visible: widget.show,
                child: Container(
                  height: 300,
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

