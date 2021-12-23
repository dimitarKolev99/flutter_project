import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;


class JsonFunctions{
  int id = 0;
  int count = 1;
  List<int> productCategoryIDs = [];
  Map<String, int> ret = new Map();
  Map<String, int> mainCategories1 = {
    "Elektroartikel" : 30311,
    "Drogerie & Gesundheit" : 3932,
    "Haus & Garten" :3686,
    "Mode & Accessoires" : 9908,
    "Tierbedarf" : 7032,
    "Gaming & Spielen" : 3326,
    "Essen & Trinken" : 12913,
    "Baby & Kind" : 4033,
    "Auto & Motorrad" : 2400,
    "Haushaltselektronik" : 1940,
  };

  Map<String, int> getMainCategories(){
    return mainCategories1;
  }
  //TODO: check if nullable is a Problem !
  int? getMainId(String name){
    return mainCategories1[name];
  }


  // this method should return all subcategories -> Method is called after finding the id inside the tree
  Map<String, int> getSubOrProductCategories(List<dynamic> category){
    Map<String, int>  categories = new Map();
    for (var element in category) {
      categories[element["name"]] = element["id"];
    }
    // print("Map1: $categories");
    return categories;
  }
  // this method returns all product and Subcategories, in case the id has both in the list
  Map<String, int> getSubAndProdCategories(List<dynamic> category, List<dynamic> category2){
    Map<String, int>  categories = new Map();
    for (var element in category) {
      //  print("subCategories = ${element["name"]} = ${element["id"]} ");
      categories[element["name"]] = element["id"];
    }
    for (var element in category2) {
      // print("prodCategories = ${element["name"]} = ${element["id"]} ");
      categories[element["name"]] = element["id"];
    }
    //print("Map2: $categories");
    return categories;
  }

  //this method should locate the right location inside the category tree and call getSubCategories to get all subcategories in a Map
  Map<String, int> getMapOfSubOrProductCategories(int id, List<dynamic> resultList){
    for (var element in resultList) {
      //print("element = ${element[id]}");
      int elementId = element["id"];
      if (elementId == id) {
        //print("id found");
        // if we reached a subcategory which matches the id we're looking for, call the method getSubCategories
        // if (element.toString().substring(1, 14) == "subCategories") {
        if(element["productCategories"] != null && element["subCategories"] != null ){
          //  print("there are prod & sub cats");
          List<dynamic> resultList2 = element["subCategories"];
          List<dynamic> resultList3 = element["productCategories"];
          ret.addAll(getSubAndProdCategories(resultList2, resultList3));
          //print("ret = $ret");
          //return ret;
        }
        if(element["subCategories"] != null ){
          //  print(" were in sub Categories");
          List<dynamic> resultList2 = element["subCategories"];
          ret.addAll(getSubOrProductCategories(resultList2));
          //print("ret = $ret");
          // return ret;
        }
        if(element["productCategories"] != null ){
          //   print(" were in prod Categories");
          List<dynamic> resultList2 = element["productCategories"];
          ret.addAll(getSubOrProductCategories(resultList2));
          //print("ret = $ret");
          //return ret;
        }
      }
      // if the id couldn't be found call function again from the right spot
      else {
        //TODO: maybe unnecessary if ?
        if (element.toString().substring(1, 14) == "subCategories") {
          List<dynamic> resultList3 = element["subCategories"];
          getMapOfSubOrProductCategories(id, resultList3);
        }
      }
    }
    // Map<String, int> x = new Map();
    // x["Not Found"] = 2342;
    //print("RET FINAL = $ret");
    return ret;
  }

  int getRandomInt(int count) {
    var random = Random();
    return random.nextInt(count);
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
            productCategoryIDs.add(id);
            count++;
          }
        }
        translateTree(resultList2);
      }
      else if (element.toString().substring(1, 18) == "productCategories") {
        List<dynamic> resultList2 = element["productCategories"];
        for (var element in resultList2) {
          id = element["id"];
          productCategoryIDs.add(id);
          count++;
        }
        translateTree(resultList2);
      }
    }
  }

  void translateTreeOneMain(List<dynamic> resultList) {
    for (var element in resultList) {
      if (element.toString().substring(1, 14) == "subCategories") {

        List<dynamic> resultList2 = element["subCategories"];
        if (element["subCategories"] != null &&
            element["productCategories"] != null) {
          List<dynamic> productList = element["productCategories"];
          for (var element in productList) {
            id = element["id"];
            productCategoryIDs.add(id);
          }
        }
        translateTree(resultList2);
      }
      else if (element.toString().substring(1, 18) == "productCategories") {
        List<dynamic> resultList2 = element["productCategories"];
        for (var element in resultList2) {
          id = element["id"];
          productCategoryIDs.add(id);
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

  Future<List<dynamic>> getJsonOneMain(int id) async {
    List<dynamic> resultList = [];
    final response = await rootBundle.loadString('lib/resources/cat_tree1.json');
    Map<String, dynamic> myMap =
    Map<String, dynamic>.from(json.decode(response));
    List<dynamic> resultList0 = myMap["result"][id]["subCategories"]; //TODO: Anstatt index [0] ein Parameter übergeben
    //TODO: Problem: Manchmal kommt derselbe Artikel nochmal,
    //TODO: da die RandomInt Funcktion dieselbe ID generieren kann
    //TODO: try catch the Unhandled Exception: NoSuchMethodError: The method '[]' was called on null. and make the app continue to run
    if (myMap["result"][id]["productCategories"] != null) {
      List<dynamic> resultList1 = myMap["result"][id]["subCategories"];
      resultList = resultList0 + resultList1;
      return resultList;
    } else {
      resultList = resultList0;
      return resultList;
    }
  }


  Future<List<int>> getListOfProdCatIDs(int id) async{
    List<dynamic> resultList = await getJsonOneMain(id);
    translateTree(resultList);
    print(count);
    return productCategoryIDs;
  }



}