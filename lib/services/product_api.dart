import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:penny_pincher/models/ws_product.dart';
import 'package:penny_pincher/services/json_functions.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ProductApi {


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

  List<dynamic> bargains = [];
  int count = 0;
  String name = "";
  int id = 0;
  int resultID = 0;
  bool stop = true;

  List<ProductWS> products = [];

  findBargains(List<dynamic> fromUri) {
        String name = "";
        int id = 0;
        fromUri.forEach((element) {
          if (element.toString().substring(1, 14) == "subCategories") {
            List<dynamic> resultList2 = element["subCategories"];
            //name = element["subCategories"][0]["name"];
            id = element["subCategories"][0]["id"];
            findBargains(resultList2);
          } else
          if (element.toString().substring(1, 18) == "productCategories") {
            List<dynamic> resultList2 = element["productCategories"];

            resultList2.forEach((element) {
              name = element["name"];
              id = element["id"];
              bargains = element["bargains"];
            });

          }
        });
  }

  fetchProductWebSocket()  {
    print("API called");

    final channel = WebSocketChannel.connect(
      Uri.parse('wss://ika3taif23.execute-api.eu-central-1.amazonaws.com/prod'),
    );

    /*
        Map<String, dynamic> map = Map<String, dynamic>.from(json.decode(response2.body));
        List<dynamic> fromUri = map["result"]; //TODO: InternalLinkedHashMap Error from here
        findBargains(fromUri);

        */
    channel.stream.listen(
        (data) {
          products.add(productFromJson(data));
        },
      onError: (error) => print(error),
    );

    return products;
  }

      Future<List<Product>> fetchProduct(int categoryID) async {
        final response = await rootBundle.loadString('lib/resources/cat_tree1.json');
        Map<String, dynamic> myMap = Map<String, dynamic>.from(json.decode(response));

        List<dynamic> resultList = myMap["result"];
        JsonFunctions testFunctions = JsonFunctions();
        final response2 = await http.get(Uri.parse(
            "https://usjm35yny3.execute-api.eu-central-1.amazonaws.com/dev/pp-bargains?maxItems=20&minSaving=1&categoryIds=$categoryID"));

        Map<String, dynamic> map = Map<String, dynamic>.from(json.decode(response2.body));
        List<dynamic> fromUri = map["result"]; //TODO: InternalLinkedHashMap Error from here
        findBargains(fromUri);
        return bargains.map((data) => Product.fromJson(data)).toList();
      }

      Future<List<Product>> getProduct(int categoryID, String query) async {
       // print("call APi");

        final response = await rootBundle.loadString('lib/resources/cat_tree1.json');
        Map<String, dynamic> myMap = Map<String, dynamic>.from(json.decode(response));

        List<dynamic> resultList = myMap["result"];
        JsonFunctions testFunctions = JsonFunctions();
        // TODO: Test Call !

        //testFunctions.getMapOfSubOrProductCategories(1760, resultList);


       // print("CATEGORYID: $categoryID");

        final response2 = await http.get(Uri.parse(
            "https://usjm35yny3.execute-api.eu-central-1.amazonaws.com/dev/pp-bargains?maxItems=20&minSaving=5&categoryIds=$categoryID"));

        Map<String, dynamic> map = Map<String, dynamic>.from(json.decode(response2.body));
        List<dynamic> fromUri = map["result"]; //TODO: InternalLinkedHashMap Error from here
        findBargains(fromUri);
        //List<dynamic> bargains = findBargains(fromUri);

    
        return bargains.map((data) => Product.fromJson(data)).where((bargains){
        final productTitle = bargains.title.toLowerCase();
        final searchLower = query.toLowerCase();

        return productTitle.contains(searchLower);
        }).toList();
      }

      Future<List<Product>> getFilterProducts(int categoryID, int saving) async {
       // print("call APi");

        final response = await rootBundle.loadString('lib/resources/cat_tree1.json');
        Map<String, dynamic> myMap = Map<String, dynamic>.from(json.decode(response));

        List<dynamic> resultList = myMap["result"];
        JsonFunctions testFunctions = JsonFunctions();
        // TODO: Test Call !

        //testFunctions.getMapOfSubOrProductCategories(1760, resultList);


       // print("CATEGORYID: $categoryID");

        final response2 = await http.get(Uri.parse(
            "https://usjm35yny3.execute-api.eu-central-1.amazonaws.com/dev/pp-bargains?maxItems=20&minSaving=5&categoryIds=$categoryID"));

        Map<String, dynamic> map = Map<String, dynamic>.from(json.decode(response2.body));
        List<dynamic> fromUri = map["result"]; //TODO: InternalLinkedHashMap Error from here
        findBargains(fromUri);
        //List<dynamic> bargains = findBargains(fromUri);

    
        return bargains.map((data) => Product.fromJson(data)).where((bargains){
        final productPrice = bargains.price;
        final productSaving = bargains.saving;
        
        return productSaving >= saving;
        }).toList();
      }
}

