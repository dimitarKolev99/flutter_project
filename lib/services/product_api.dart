import 'dart:collection';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:penny_pincher/main.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:penny_pincher/services/json_functions.dart';

class ProductApi {
  // IDEALO Colors
  static const Color darkBlue = Color.fromRGBO(10, 55, 97, 1);
  static const Color lightBlue = Color.fromRGBO(55, 95, 134, 1);
  static const Color orange = Color.fromRGBO(255, 102, 0, 1);
  static const Color white = Color.fromRGBO(255, 255, 255, 1);


  // Map<ProduktkategorieName, ProduktID>
  // Blätter -> aus dieser Id können wir Artikel Returnen, BlattID -> in URL
  Map<String, int> produktKategorie = <String, int>{};


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
    "Sport & Outdoor" : 3626,
  };

  //fill the map with all product categories
  void fillMap(String name, int id) {
    produktKategorie[name] = id;
  }

  List<dynamic> bargains = [];
  int count = 0;
  String name = "";
  int id = 0;
  int resultID = 0;
  bool stop = true;

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
            });
          }
        });
      }

      Future<List<Product>> fetchProduct() async {
        print("call APi");

        final response =
        await rootBundle.loadString('lib/resources/cat_tree1.json');
        Map<String, dynamic> myMap =
        Map<String, dynamic>.from(json.decode(response));

        List<dynamic> resultList = myMap["result"];
        JsonFunctions testFunctions = JsonFunctions();
        // TODO: Test Call !

        testFunctions.getMapOfSubOrProductCategories(12052,  resultList);

        var categoryID = produktKategorie["Handys & Smartphones"];
        print("CATEGORYID: $categoryID");

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

