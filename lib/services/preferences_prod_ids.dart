import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;

class PreferenceIDS {
  int id = 0;
  List<int> productCategoryIDs = [];
  List<int> intProductList = [];

  //fill the list with all product category ids
  void addToListOfIDs(int id)  {
    productCategoryIDs.add(id);
  }

  void translateTree(List<dynamic> resultList) {
    for (var element in resultList) {
      if (element.toString().substring(1, 14) == "subCategories") {

          List<dynamic> resultList2 = element["subCategories"];
          if (element["subCategories"] != null &&
              element["productCategories"] != null) {
            List<dynamic> productList = element["productCategories"];
            for (var element in productList) {
              id = element["id"];
              addToListOfIDs(id);
            }
          }
        translateTree(resultList2);
      }
      else if (element.toString().substring(1, 18) == "productCategories") {
        List<dynamic> resultList2 = element["productCategories"];
        for (var element in resultList2) {
          id = element["id"];
          addToListOfIDs(id);
        }
        translateTree(resultList2);
      }
    }
  }

  Future<List<dynamic>> getJson() async {
    final response = await rootBundle.loadString('lib/resources/cat_tree1.json');
    Map<String, dynamic> myMap =
    Map<String, dynamic>.from(json.decode(response));
    List<dynamic> resultList = myMap["result"];
    return resultList;
  }

  Future<List<int>> fillListOfIDsAndSaveIt() async{
    List<dynamic> resultList = await getJson();
    translateTree(resultList);
    saveInPref();
    return productCategoryIDs;
  }

  void saveInPref() async{
    List<String> strList = productCategoryIDs.map((i) => i.toString()).toList();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("productList", strList);
  }

  Future<List<int>> getFromPref(List<int> ids) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedStrList = prefs.getStringList("productList");
    if(savedStrList != null) {
      intProductList = savedStrList.map((i) => int.parse(i)).toList();
    }
    return intProductList;
  }

}