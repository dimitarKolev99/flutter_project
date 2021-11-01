import 'package:flutter/material.dart';

class ArticleSearch extends SearchDelegate<String> {
  final articles = [ //TODO: Just sample articles. Needs actual data
    'iPhone',
    'Jeans',
    'macBook',
    'bag',
    'T-shirt',
    'charger',
  ];

  final recentArticles = [ //TODO: Just sample articles. Needs actual data
    'macBook',
    'charger',
    'Jeans',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        if (query.isEmpty) {
          close(context, ''); // Not sure if empty string is okay here, but it works
        } else {
          query = '';
        }
      },
    )
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, ''), // Not sure if empty string is okay here, but it works
  );

  @override
  Widget buildResults(BuildContext context) => Center( //TODO: just a placeholder site yet. Have to call a rearrangement of the article stream
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

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty ? recentArticles : articles.where((article) {
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
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
    

}