import 'dart:async';

import 'package:penny_pincher/models/preferences_articles.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/services/product_controller.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../browser_view.dart';
import 'article_card.dart';
import 'browser_article_card.dart';
import '../extended_view.dart';



class ArticleSearch extends SearchDelegate<String> {

  List<String> recentArticles = [];
  late List<Product> _products = [];
  final _preferenceArticles = PreferencesArticles();
  late final List _favoriteIds = [];
  bool fromFeed = true;
  StreamController<bool> streamController;
  dynamic callback;


  ArticleSearch (this.fromFeed, this.callback, this.streamController) {
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
      _products = await ProductApi().getProduct(3832, query);

      storeToRecent(query);

      List<Product> favorites = await _preferenceArticles.getAllFavorites();
      for (var i in favorites) {
        if (!_favoriteIds.contains(i.productId)) {
          _favoriteIds.add(i.productId);
        }
      }
      ProductController.addProducts(_products);
    }

    @override
    Widget buildResults(BuildContext context) {

      updateRecent();

      return FutureBuilder(
        future: getProducts(),
        builder: (context, snapshot) {
         // if (snapshot.connectionState == ConnectionState.done) {
            return createResult(context);
          //} else {
           // return CircularProgressIndicator(); // This was the reload causing line. // TODO: DO NOT DELETE COMMENTS HERE
         // }
        },
      );
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

  Widget createResult(BuildContext context) {
      if(fromFeed) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _products.length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => ExtendedView(_products[index], callback, streamController.stream)),
                  );
                },
                child: ArticleCard(_products[index], callback));
          });
      } else {
        return GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          children: List.generate(_products.length, (index) {
            return InkWell(
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => ExtendedView(_products[index], callback ,streamController.stream)),
                  );
                },
                child: BrowserArticleCard(_products[index], callback));
          }),
        );
      }
  }


}

    

