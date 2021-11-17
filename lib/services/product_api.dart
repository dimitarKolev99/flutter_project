import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
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
  Map<String, int> produktKategorie = new Map<String, int>();
  // Map<SubkategorieName, ProduktID>
  // Äste
  Map<String, int> subKategorie = new Map<String, int>();

  List<dynamic> bargains = [];

  int count = 0;
  String name = "";
  int id = 0;
  int resultID = 0;
  bool stop = false;

  int translateTree(String category, List<dynamic> resultList){
      resultList.forEach((element) {

         if (element.toString().substring(1, 14) == "subCategories") {
          print("subCategorie");
          List<dynamic> resultList2 = element["subCategories"];

          if(element["subCategories"] != null && element["productCategories"] != null) {
            List<dynamic> productList = element["productCategories"];
            productList.forEach((element) {

              name = element["name"];
              id = element["id"];
              //print("count =  $count");
              print("Prod + $name");
              print("Prod + $id");
              if (category == name) resultID = id;
              print("result: $resultID");
            });

          }

          resultList2.forEach((element) {
            if(element["name"] != null) {
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
        }
        else if (element.toString().substring(1, 18) == "productCategories") {
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
     }
     else {
       return 0;
     }
    }

     findBargains(List<dynamic> fromUri ){
      String name = "";
      int id = 0;

      fromUri.forEach((element) {
        //print(element);
        if(element.toString().substring(1,14) == "subCategories") {
          print("subCategorie");
          List<dynamic> resultList2 = element["subCategories"];
          //name = element["subCategories"][0]["name"];
          id = element["subCategories"][0]["id"];
          findBargains(resultList2);
        }
        else if(element.toString().substring(1,18) == "productCategories"){
          List<dynamic> resultList2 = element["productCategories"];
          print("productCategorie");

          resultList2.forEach((element) {
            name = element["name"];
            id = element["id"];
            element["bargains"] = bargains;
            print(element);
            //categories.putIfAbsent(name, () => id);
          });
          //findBargains(fromUri);
        }
      });
  }


  Future<List<Product>> fetchProduct() async {
    //List<dynamic> list = <String>[];
    print("call APi");

    final response = await rootBundle.loadString('lib/resources/cat_tree1.json');
    Map<String, dynamic> myMap = Map<String, dynamic>.from(json.decode(response));


    //Map<String, int> categories = new Map<String, int>(); //new Map<String, int>();
    //print(myMap["result"][0]["subCategories"][0]["subCategories"][0]["subCategories"][0]["productCategories"][10]);


    //List<dynamic> elementsOfCategories = myMap["result"][0]["subCategories"][0]["subCategories"][0]["subCategories"][0]["productCategories"];
    //print(myMap["result"][0]);
    List<dynamic> resultList = myMap["result"];

    //print("xsxx = ${myMap["result"][0]["subCategories"][0].toString().substring(1,14) == "subCategories"}");
    int i = 0;

    int categoryID = translateTree("RC-Ladegeräte", resultList);
    print("CATEGORYID: $categoryID");

    final response2 = await http.get(
        Uri.parse(
            "https://usjm35yny3.execute-api.eu-central-1.amazonaws.com/dev/pp-bargains?maxItems=20&minSaving=5&categoryIds=$categoryID"
        ));

    Map<String, dynamic> map = Map<String, dynamic>.from(json.decode(response2.body));
    List<dynamic> fromUri = map["result"]; //TODO: InternalLinkedHashMap Error from here
    findBargains(fromUri);
    //List<dynamic> bargains = findBargains(fromUri);


      final products = <Product>[];

      for(var bargain in bargains) {
        products.add(Product.fromJson(bargain));
      }

      return products;
    } /* else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw NullThrownError();
    }
  }*/
}


