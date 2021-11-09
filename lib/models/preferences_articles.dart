import 'dart:convert';

import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/view/widget/article_card.dart';
import 'package:penny_pincher/view/widget/favorite_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

//this class will store all the informations
class PreferencesArticles {
  dynamic preferences;

  Future addFavorite(ArticleCard articleCard) async {
    if (preferences == null) {
      await _fetchData();
    }

    final rawData = preferences.getString('favorites');
    final jsonData = jsonDecode(rawData.toString());
    jsonData[articleCard.id.toString()] = fromCardToJson(articleCard);
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
    List<Product> cards = [];
    jsonData.forEach((id, value) => cards.add(fromJsonToProduct(id, value)));
    return cards;
  }

  Future _fetchData() async {
      SharedPreferences.setMockInitialValues({});
      preferences = await SharedPreferences.getInstance();
  }

  Map<String, dynamic> fromCardToJson(ArticleCard articleCard) => {
        'title': articleCard.title,
        'price': articleCard.price,
        'saving': articleCard.saving,
        'image': articleCard.image,
        'description': articleCard.description,
        'category': articleCard.category,
      };

  Product fromJsonToProduct(String id, Map<String, dynamic> json) {
    return Product(categoryId: json["category_id"],
      categoryName: json["category_name"],
      productId: json["product_id"],
      title: json["product_title"],
      price: json["price"].toDouble(),
      saving: json["saving"],
      description:json["description"],
      image: json["images"]["w120h100"][0],);
  }

}