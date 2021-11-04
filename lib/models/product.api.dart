import 'dart:convert';
import 'dart:developer';
import 'package:penny_pincher/models/product.dart';
import 'package:http/http.dart' as http;

class ProductApi{
  static Future<List<Product>> fetchProduct() async {
    final response = await http.get(Uri.parse("https://usjm35yny3.execute-api.eu-central-1.amazonaws.com/dev/pp-bargains?maxItems=1&minSaving=20&categoryIds=18817"));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      
      Map<String, dynamic> map = new Map<String, dynamic>.from(json.decode(response.body));
      List<dynamic> data = map["result"];

      //List _data = json.decode(response.body)
      print(data[0]["subCategories"][0]["productCategories"][0]["bargains"][0]["images"]["w120h100"][0]);
      return data.map((data) => Product.fromJson(data)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw NullThrownError();
    }
  }
}

