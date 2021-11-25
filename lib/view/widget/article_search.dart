import 'package:penny_pincher/models/preferences_articles.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../browser_view.dart';
import 'article_card.dart';
import 'extended_view.dart';



class ArticleSearch extends SearchDelegate<String> {

  List<String> recentArticles = [];
  late List<Product> _products = [];
  final _preferenceArticles = PreferencesArticles();
  late final List _favoriteIds = [];

  ArticleSearch () {
    updateRecent(); // reading out storage on opening searchBar
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context,
                ''); // Not sure if empty string is okay here, but it works
          } else {
            query = '';
          }
        },
      )
    ];
  }




    @override
    Widget? buildLeading(BuildContext context) {
      return Container (
        child: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () =>
            close(context,
                ''),// Not sure if empty string is okay here, but it works
          ),
        );
    }

    Future<void> getProducts() async {
      _products = await ProductApi().getProduct(18418, query);

      List<Product> favorites = await _preferenceArticles.getAllFavorites();
      for (var i in favorites) {
        if (!_favoriteIds.contains(i.productId)) {
          _favoriteIds.add(i.productId);
        }
      }
    }

    @override
    Widget buildResults(BuildContext context) {
      storeToRecent(query);
      updateRecent();

      getProducts();

      return ListView.builder(
          reverse: true,
          shrinkWrap: true,
          itemCount: _products.length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => ExtendedView(
                            id: _products[index].productId,
                            title: _products[index].title,
                            saving: _products[index].saving,
                            category: _products[index].categoryName,
                            description: _products[index].description,
                            image: _products[index].image,
                            price: _products[index].price,
                            stream: streamController.stream,
                            callback: this)),
                  );
                },
                child: ArticleCard(
                  id: _products[index].productId,
                  title: _products[index].title,
                  saving: _products[index].saving,
                  category: _products[index].categoryName,
                  description: _products[index].description,
                  image: _products[index].image,
                  price: _products[index].price,
                  callback: this,
                ));
          });
    }

    @override
    Widget buildSuggestions(BuildContext context) {
      updateRecent();
      final suggestions = query.isEmpty ? recentArticles : recentArticles.where((article) {
        final articleLower = article.toLowerCase();
        final queryLower = query.toLowerCase();

        return articleLower.startsWith(queryLower);
      }).toList();

      return buildSuggestionsSuccess(suggestions);
    }

    Widget buildSuggestionsSuccess(List<String> suggestions) => ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        final queryText = suggestion.substring(0, query.length);
        final remainingText = suggestion.substring(query.length);

        return ListTile(
          onTap: () {
            query = suggestion;

            showResults(context);
          },
          leading: const Icon(Icons.shop),
          // below: highlighted text for matching characters
          title: RichText(
            text: TextSpan(
              text: queryText,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: [
                TextSpan(
                  text: remainingText,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    void storeToRecent(String s) async {
      if(s == '' || s == ' ') return; // no need to store an empty query
      if(recentArticles.contains(s)) recentArticles.remove(s); // avoiding duplications
      recentArticles.insert(0, s); // storing in run-time variable

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList('recentArticles', recentArticles); // storing permanently

    }

    void updateRecent() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      recentArticles = prefs.getStringList('recentArticles') ?? []; // reading out permanent storage
    }

  bool isFavorite(int id) {
    return _favoriteIds.contains(id);
  }
}

    

