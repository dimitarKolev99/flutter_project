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

    final data = preferences.getString('favorites');
    final jsonData = jsonDecode(data.toString());
    jsonData[articleCard.id.toString()] = toJson(articleCard);
    await preferences.setString("favorites", jsonEncode(jsonData));
  }

  Future removeFavorite(int id) async {
    if (preferences == null) {
      await _fetchData();
    }

    final data = preferences.getString('favorites');
    final jsonData = jsonDecode(data.toString());
    jsonData.remove(id.toString());
    await preferences.setString("favorites", jsonEncode(jsonData));
  }

  Future<bool> isFavorite(int id) async {
    final preferences = await SharedPreferences.getInstance();
    final data = preferences.getString('favorites');
    final jsonData = jsonDecode(data.toString());
    return jsonData.containsKey(id.toString());
  }

  Future getAllFavorites() async {
    if (preferences == null) {
      await _fetchData();
    }

    var data = preferences.getString('favorites');
    if (data == null) {
      await preferences.setString("favorites", "{}");
      data = preferences.getString('favorites');
    }
    final jsonData = jsonDecode(data.toString());
    List<Product> cards = [];
    jsonData.forEach((id, value) => cards.add(fromJson(id, value))); 
    return cards;
  }

  Future _fetchData() async {
      preferences = await SharedPreferences.getInstance();
  }

  Map<String, dynamic> toJson(ArticleCard articleCard) => {
        'title': articleCard.title,
        'price': articleCard.price,
        'image': articleCard.image,
        'description': articleCard.description,
        'category': articleCard.category,
      };

  Product fromJson(String id, Map<String, dynamic> json) {
    return Product(
      id: int.parse(id),
      title: json['title'],
      price: json['price'],
      image: json['image'],
      description: json['description'],
      category: json['category'],);
  }

}