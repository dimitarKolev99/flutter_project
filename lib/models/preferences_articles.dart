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
      preferences = await SharedPreferences.getInstance();
  }

  Map<String, dynamic> fromCardToJson(ArticleCard articleCard) => {
        'title': articleCard.title,
        'price': articleCard.price,
        'image': articleCard.image,
        'description': articleCard.description,
        'category': articleCard.category,
      };

  Product fromJsonToProduct(String id, Map<String, dynamic> json) {
    return Product(
      id: int.parse(id),
      title: json['title'],
      price: json['price'],
      image: json['image'],
      description: json['description'],
      category: json['category'],);
  }

}