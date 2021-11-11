import 'dart:convert';

import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/view/widget/article_card.dart';
import 'package:penny_pincher/view/widget/favorite_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

//this class will store all the informations
class PreferencesArticles {
  dynamic preferences;

  Future addFavorite(Product product) async {
    if (preferences == null) {
      await _fetchData();
    }

    final rawData = preferences.getString('favorites');
    final jsonData = jsonDecode(rawData.toString());
    jsonData[product.productId.toString()] = fromCardToJson(product);
    await preferences.setString("favorites", jsonEncode(jsonData));
  }

  Future removeFavorite(int id) async {
    if (preferences == null) {
      await _fetchData();
    }

    final rawData = preferences.getString('favorites');
    final jsonData = jsonDecode(rawData.toString());
    jsonData.remove(id.toString());
    await preferences.setString("favorites", jsonEncode(jsonData));
  }

  Future getAllFavorites() async {
    if (preferences == null) {
      await _fetchData();
    }

    var rawData = preferences.getString('favorites');
    if (rawData == null) {
      await preferences.setString("favorites", "{}");
      rawData = preferences.getString('favorites');
    }
    final jsonData = jsonDecode(rawData.toString());
    List<Product> products = [];
    jsonData.forEach((id, value) => products.add(fromJsonToProduct(id, value)));
    return products;
  }

  Future _fetchData() async {
      preferences = await SharedPreferences.getInstance();
  }

  Map<String, dynamic> fromCardToJson(Product product) => {
        'category_id': product.categoryId,
        'category_name': product.categoryName,
        'productId': product.productId,
        'title': product.title,
        'price': product.price,
        'saving': product.saving,
        'description': product.description,
        'image': product.image,
      };

  Product fromJsonToProduct(String id, Map<String, dynamic> json) {
    return Product(categoryId: json["category_id"],
      categoryName: json["category_name"],
      productId: int.parse(id),
      title: json["title"],
      price: json["price"].toDouble(),
      saving: json["saving"],
      description:json["description"],
      image: json["image"],);
  }
}