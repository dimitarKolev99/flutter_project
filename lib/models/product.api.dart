import 'dart:convert';
import 'package:penny_pincher/models/product.dart';
import 'package:http/http.dart' as http;

class ProductApi{
  
  static Future<List<Product>> fetchProduct() async {
    final response = await http.get(Uri.parse("https://fakestoreapi.com/products"));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      
      List _data = json.decode(response.body);
      return _data.map((data) =>Product.fromJson(data)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw NullThrownError();
    }
  }
}

