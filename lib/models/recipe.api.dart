import 'dart:convert';
import 'package:penny_pincher/models/recipe.dart';
import 'package:http/http.dart' as http;

class RecipeApi{
//   var req = unirest("GET", "https://yummly2.p.rapidapi.com/feeds/list");

// req.query({
	// "limit": "18",
	// "start": "0",
	// "tag": "list.recipe.popular"
// });

// req.headers({
	// "x-rapidapi-host": "yummly2.p.rapidapi.com",
	// "x-rapidapi-key": "a91d2f81f9msha01d6888b6f6eb8p1ec52fjsn074c2c899db2",
	// "useQueryString": true
// });
  static Future<List<Recipe>> getRecipes() async {
    var uri = Uri.https('yummly2.p.rapidapi.com', '/feeds/list', {	"limit": "18",
	  "start": "0",
	  "tag": "list.recipe.popular"});
    final response = await http.get(uri, headers: {	"x-rapidapi-host": "yummly2.p.rapidapi.com",
	  "x-rapidapi-key": "a91d2f81f9msha01d6888b6f6eb8p1ec52fjsn074c2c899db2",
	  "useQueryString": "true"
  });
    
    Map data = jsonDecode(response.body);
    List _temp = [];

    for(var i in data ['feed']){
      _temp.add(i['content']['details']);
    }

    return Recipe.recipesFromSnapshot(_temp);
  }
}