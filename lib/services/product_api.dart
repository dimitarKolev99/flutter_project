import 'dart:collection';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class ProductApi {
  // IDEALO Colors
  static const Color darkBlue = Color.fromRGBO(10, 55, 97, 1);
  static const Color lightBlue = Color.fromRGBO(55, 95, 134, 1);
  static const Color orange = Color.fromRGBO(255, 102, 0, 1);
  static const Color white = Color.fromRGBO(255, 255, 255, 1);


  // Map<ProduktkategorieName, ProduktID>
  // Blätter -> aus dieser Id können wir Artikel Returnen, BlattID -> in URL
  Map<String, int> produktKategorie = <String, int>{};

  //fill the map with all product categories
  void fillMap(String name, int id) {
    produktKategorie[name] = id;
  }

  // Map<SubkategorieName, ProduktID>
  // Äste
  Map<String, int> mainCategories = new Map<String, int>();
  Map<String, int> subCategories1 = new Map<String, int>();

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
// List K
  List<dynamic> allSubCategories = [];
  int currentCategory = 0;
  // given an Main Category ID this method returns all subcategories
  void findSubCategories(int id, List<dynamic> resultList){
    for (var element in resultList) {
      if(element["id"] == id) {
        // after finding ID of main Category ->
          currentCategory = element["id"];
          print("current Cat :  $currentCategory");
          getSubCategories(element);
        }
      }
    }

    Map <int, List<int>> categoriesAndSubcategories = new Map();
    //MAP key = currentCategory = 3326, value = List of subcategories and Productcategories
    List<int> subCatIds = [];
    Map <int, List<int>> CategoriesAndProductcategories = new Map();

    //TODO: Der plan war die Subcategories der jeweiligen currentCategory in einer Liste
  // zu speichern. Die dann in einer Map über den Key current Category aufgerufen werden kann
  // ? passen currentCategoryID und zugehörige SubCategories zusammen? Was ist mit Produktkategories

  getSubCategories(dynamic element){

    if (element.toString().substring(1, 14) == "subCategories") {
      for (var element2 in element["subCategories"]) {
        currentCategory = element["id"];
        print("id = $currentCategory  = element ${element2["name"]}");
        categoriesAndSubcategories[currentCategory] =
        getSubCategories(element2);
      }

    }
    if((element.toString().substring(1, 18) == "productCategories")){
      for (var element3 in element["productCategories"]) {
        //print(element3["name"]);
       // map.add[currentCategory] = element3["id"];
        getSubCategories(element3);
      }
    }
    // add Map to List
    // recall Method 1 step deeper with resultlist2
  }






  List<dynamic> bargains = [];

  int count = 0;
  String name = "";
  int id = 0;
  int resultID = 0;
  bool stop = true;

  //translateTree working function
  /*
  int translateTree(String category, List<dynamic> resultList) {
    resultList.forEach((element) {
      if (element.toString().substring(1, 14) == "subCategories") {
        print("subCategorie");
        List<dynamic> resultList2 = element["subCategories"];

        if (element["subCategories"] != null &&
            element["productCategories"] != null) {
          List<dynamic> productList = element["productCategories"];
          productList.forEach((element) {
            name = element["name"];
            id = element["id"];
            //print("count =  $count");
            print("Prod + $name");
            print("Prod + $id");
            if (category == name) resultID = id;
            stop = false;
            print("result: $resultID");
          });
        }

        resultList2.forEach((element) {
          if (element["name"] != null) {
            name = element["name"];
          }
          id = element["id"];
          //print("count =  $count");
          print("subCat + $name");
          print("subCat + $id");
        });

        //count++;
        //print(count);
        translateTree(category, resultList2);
      } else if (element.toString().substring(1, 18) == "productCategories") {
        List<dynamic> resultList2 = element["productCategories"];
        print("productCategorie");
        resultList2.forEach((element) {
          name = element["name"];
          id = element["id"];
          //print("count =  $count");
          print("Prod + $name");
          print("Prod + $id");
          if (category == name) resultID = id;
          print("result: $resultID");
        });

        //count = 0;
        translateTree(category, resultList2);
      }
    });

    if (resultID != 0) {
      return resultID;
    } else {
      return 0;
    }
  }
*/



  void findMainCategories (List<dynamic> resultList) {
    for (var element in resultList) {
      if (element.toString().substring(1, 14) == "subCategories") {
        //print("${element["name"]}");
        if (element["name"] != null && element["id"] != null) {
          name = element["name"];
          id = element["id"];
          mainCategories[name] = id;
         // print("${mainCategories[name]}");
        }
        else {
          print("idididididididid ------   ${element["id"]}");
        }
        List<dynamic> resultList2 = element["subCategories"];
        findMainCategories(resultList2);
      }
    }
  }



      int translateTree(String category, List<dynamic> resultList) {
        for (var element in resultList) {
          if (element.toString().substring(1, 14) == "subCategories") {
            print("${element["name"]}");
            if (element["name"] != null && element["id"] != null) {
              name = element["name"];
              id = element["id"];
              mainCategories[name] = id;
              print("${mainCategories[name]}");
            }
            List<dynamic> resultList2 = element["subCategories"];
            if (false) {
              List<dynamic> resultList2 = element["subCategories"];
              // name = resultList2["name"];
              if (element["subCategories"] != null &&
                  element["productCategories"] != null) {
                List<dynamic> productList = element["productCategories"];
                for (var element in productList) {
                  name = element["name"];
                  id = element["id"];
                  //print("count =  $count");
                  //print("Prod + $name");
                  //print("Prod + $id");
                  fillMap(name, id);
                  if (category == name) {
                    resultID = id;
                    //print("result: $resultID");
                    return resultID;
                  }
                }
              }

              resultList2.forEach((element) {
                if (element["name"] != null) {
                  name = element["name"];
                }
                id = element["id"];
                //print("count =  $count");
                //print("subCat + $name");
                //print("subCat + $id");
              });
            }
            //count++;
            //print(count);
            translateTree(category, resultList2);
          } else
          if (element.toString().substring(1, 18) == "productCategories") {
            List<dynamic> resultList2 = element["productCategories"];
            //print("productCategorie");
            for (var element in resultList2) {
              name = element["name"];
              id = element["id"];
              //print("count =  $count");
              // print("Prod + $name");
              // print("Prod + $id");
              fillMap(name, id);
              if (category == name) {
                resultID = id;
                return resultID;
                print("result: $resultID");
              }
            }
            //count = 0;
            translateTree(category, resultList2);
          }
        }
        return resultID;
      }

      findBargains(List<dynamic> fromUri) {
        String name = "";
        int id = 0;

        fromUri.forEach((element) {
          if (element.toString().substring(1, 14) == "subCategories") {
            print("subCategorie");
            List<dynamic> resultList2 = element["subCategories"];
            //name = element["subCategories"][0]["name"];
            id = element["subCategories"][0]["id"];
            findBargains(resultList2);
          } else
          if (element.toString().substring(1, 18) == "productCategories") {
            List<dynamic> resultList2 = element["productCategories"];
            print("productCategorie");

            resultList2.forEach((element) {
              name = element["name"];
              id = element["id"];
              bargains = element["bargains"];
              //categories.putIfAbsent(name, () => id);
            });
          }
        });
      }

      Future<List<Product>> fetchProduct() async {
        //List<dynamic> list = <String>[];
        print("call APi");

        final response =
        await rootBundle.loadString('lib/resources/cat_tree1.json');
        Map<String, dynamic> myMap =
        Map<String, dynamic>.from(json.decode(response));

        //Map<String, int> categories = new Map<String, int>(); //new Map<String, int>();
        //print(myMap["result"][0]["subCategories"][0]["subCategories"][0]["subCategories"][0]["productCategories"][10]);

        //List<dynamic> elementsOfCategories = myMap["result"][0]["subCategories"][0]["subCategories"][0]["subCategories"][0]["productCategories"];
        //print(myMap["result"][0]);
        List<dynamic> resultList = myMap["result"];

        //print("xsxx = ${myMap["result"][0]["subCategories"][0].toString().substring(1,14) == "subCategories"}");
        int i = 0;

        //translateTree("", resultList);
        findMainCategories(resultList);
        // 9908 MAin categorie
        findSubCategories(3326, resultList);

        print("length                .::::     ${mainCategories.length}");
        var categoryID = produktKategorie["Handys & Smartphones"];
        print("CATEGORYID: $categoryID");

        var sizeOfMap = produktKategorie.length;
        print("MAP: $produktKategorie");
        print("SIZE OF MAP: $sizeOfMap");

        final response2 = await http.get(Uri.parse(
            "https://usjm35yny3.execute-api.eu-central-1.amazonaws.com/dev/pp-bargains?maxItems=20&minSaving=5&categoryIds=$categoryID"));

        Map<String, dynamic> map =
        Map<String, dynamic>.from(json.decode(response2.body));
        List<dynamic> fromUri =
        map["result"]; //TODO: InternalLinkedHashMap Error from here
        findBargains(fromUri);
        //List<dynamic> bargains = findBargains(fromUri);

        final products = <Product>[];

        for (var bargain in bargains) {
          products.add(Product.fromJson(bargain));
        }

        return products;
      }
/* else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw NullThrownError();
    }
  }*/
    }

