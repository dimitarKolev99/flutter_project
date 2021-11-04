import 'dart:convert';

import 'package:penny_pincher/view/widget/article_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

//this class will store all the informations
class PreferencesArticles {


  Future saveData(ArticleCard articleCard) async {
    final preferences = await SharedPreferences.getInstance();
    final data = preferences.getString('favorites');
    final jsonData = jsonDecode(data.toString());
    jsonData[articleCard.id.toString()] = toJson(articleCard);
    await preferences.setString("favorites", jsonEncode(jsonData));
  }

  Future getAllFavorites() async {
    final preferences = await SharedPreferences.getInstance();
    final data = preferences.getString('favorites');
    final jsonData = jsonDecode(data.toString());

    //List<ArticleCard> cards;
    //jsonData.forEach((id, value) => cards.add(fromJson(id, value))); 
    //print(cards[0].title);
  }

  Map<String, dynamic> toJson(ArticleCard articleCard) => {
        'title': articleCard.title,
        'price': articleCard.price,
        'image': articleCard.image,
        'description': articleCard.description,
        'category': articleCard.category,
      };

  ArticleCard fromJson(int id, Map<String, dynamic> json) {
    return ArticleCard(
      id: id,
      title: json['title'],
        price: json['price'],
        image: json['image'],
        description: json['description'],
        category: json['category']);
  }
  
}