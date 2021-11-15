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


  static Future<List<Product>> fetchProduct() async {
    List<dynamic> list = <String>[];
    print("call APi");

    final response = await rootBundle.loadString(
        'lib/resources/cat_tree1.json');
    print("resonse exists");
    //print(response);
    Map<String, dynamic> myMap = new Map<String, dynamic>.from(
        json.decode(response));


    Map<String, int> categories = new Map<String, int>(); //new Map<String, int>();
    //print(myMap["result"][0]["subCategories"][0]["subCategories"][0]["subCategories"][0]["productCategories"][10]);


    List<dynamic> elementsOfCategories = myMap["result"][0]["subCategories"][0]["subCategories"][0]["subCategories"][0]["productCategories"];

    elementsOfCategories.forEach((element) {
      String name = element["name"];
      int id = element["id"];
      print(name);
      print(id);

      categories.putIfAbsent(name, () => id);
    });
    //String name = myMap["result"][0]["subCategories"][0]["subCategories"][0]["subCategories"][0]["productCategories"][pos]["name"];
    //int id = myMap["result"][0]["subCategories"][0]["subCategories"][0]["subCategories"][0]["productCategories"][pos]["id"];
    //categories.putIfAbsent(name, () => id);


    print(categories);


/*
    print(myMap["result"][0]["subCategories"][0]["subCategories"][0]["subCategories"][0]["productCategories"][0]["name"]);
    List<Map> nameData = myMap["result"][0]["subCategories"][0]["subCategories"][0]["subCategories"][0]["productCategories"][0]["name"];
    List<String> idData = myMap["result"][0]["subCategories"][0]["subCategories"][0]["subCategories"][0]["productCategories"][0]["id"];
    //print(myMap);
    print('$nameData');
    print('$idData');



    for (int i = 0; i < (myMap["result"].length); i++) {
      print(" i = $i");
      var currObj = myMap["result"][i];

      while (currObj.containsKey('subCategories')) {
        // move to last subCategory
      }
      if (currObj.containsKey('subCategories').containsKey(
          'productCategories')) {
        var currObjSubCategoryList =
        currObj['subCategories'] as List<Map<String, Object>>;
        for (int j = 0; j < currObjSubCategoryList.length; j++) {
          var listItem = currObjSubCategoryList[j];
          var typeList = listItem['name']! as List<Map<String, Object>>;
          for (int k = 0; k < typeList.length; k++) {
            var temp = typeList[k];
            var currDishName = temp['name'];
            var currDishPrice = temp['id'];
            print("Name: " +
                currDishName.toString() +
                "\n" +
                " id :" +
                currDishPrice.toString());
          }
        }
      }
    }
  }

*/


/*
    Map<String, dynamic> myMap = json.decode(response);
    print("Map:  ${myMap.toString()}");
    List<dynamic> list = myMap["result" ][0]["name"];
    list.forEach((entitlement) {

      (entitlement as Map<String, dynamic>).forEach((key, value) {
        print(key);

        (value as Map<String, dynamic>).forEach((key2, value2) {
          print(key2);
          print(value2);
        });
      });
    });
*/

      //Map<String, dynamic> map = new Map<String, dynamic>.from(json.decode(response.body));
      //List<dynamic> data = map["result"][0]["subCategories"][0]["productCategories"][0]["bargains"];

      // Array mit
      final products = <Product>[];

      for(var bargain in list) {
        products.add(Product.fromJson(bargain));
      }
      //List _data = json.decode(response.body)
      //return data.map((data) => Product.fromJson(data)).toList();
      return products;
    } /* else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw NullThrownError();
    }
  }*/
}


