import 'package:penny_pincher/view/widget/article_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

//this class will store all the informations
class PreferencesArticles {


  Future saveData(ArticleCard articleCard) async {
    final preferences = await SharedPreferences.getInstance();

    var test = toJson(articleCard);
    print(test);
    var test2 = fromJson(test);
    print(test2.title);
    

    await preferences.setDouble('price', articleCard.price);
    await preferences.setString('title', articleCard.title);
    await preferences.setString('image', articleCard.image);
    await preferences.setString('description', articleCard.description);
    await preferences.setString('category', articleCard.category);

    print('Saved Articel Card');
    print("------------------");
  }

  Map<String, dynamic> toJson(ArticleCard articleCard) => {
        'title': articleCard.title,
        'price': articleCard.price,
        'image': articleCard.image,
        'description': articleCard.description,
        'category': articleCard.category,
      };

  ArticleCard fromJson(Map<String, dynamic> json) {
    return ArticleCard(
      title: json['title'],
        price: json['price'],
        image: json['image'],
        description: json['description'],
        category: json['category']);
  }

    Future<ArticleCard> getArticleCard() async {  //
    final preferences = await SharedPreferences.getInstance();

    final price = preferences.getDouble('price');
    final title = preferences.getString('title');
    final image = preferences.getString('image');
    final description = preferences.getString('description');
    final category = preferences.getString('category');

    if (price == null || title == null || image == null || description == null || category == null) {
      throw UnimplementedError();
    } else {
      return ArticleCard(
          title: title,
          price: price,
          image: image,
          description: description,
          category: category,
          );
    }

    /*
    return ArticleCard(
        title: title,
        price: price,
        image: image,
        description: description,
        category: category);

     */
  }
}