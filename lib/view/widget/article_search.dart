import 'package:penny_pincher/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../browser_view.dart';
import '../filter_view.dart';


class ArticleSearch extends SearchDelegate<String> {

  List<String> recentArticles = [];
  late final List<Product> _products = [];

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

    @override
    Widget buildResults(BuildContext context) {
      storeToRecent(query);
      updateRecent();

      return Center( //TODO: just a placeholder site yet. Have to call a rearrangement of the article stream
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shop, size: 120),
            const SizedBox(height: 48),
            Text(
              query,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
}

    

