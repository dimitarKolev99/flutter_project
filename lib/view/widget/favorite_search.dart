import 'dart:async';

import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'extended_view.dart';
import 'favorite_card.dart';

class FavoriteSearch extends SearchDelegate<String> {

  dynamic callback;
  StreamController<bool> streamController;

  FavoriteSearch(this.callback, this.streamController);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
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
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () =>
          close(context, ''), // Not sure if empty string is okay here, but it works
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildScaffold();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildScaffold();
  }

  @override
  Widget showResults(BuildContext context) {
    return buildScaffold();
  }

  void updateSuggestions() {
    query += " ";
    query = query.substring(0, query.length - 1);
  }

  Scaffold buildScaffold() {
    callback.query = query;

    final result = callback.filterFavorites(this);

    return Scaffold(
      body: result.isNotEmpty || query.isEmpty
          ? Align(
        alignment: Alignment.topCenter,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: result.length,
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExtendedView(
                              id: result[index].productId,
                              title: result[index].title,
                              saving: result[index].saving,
                              category:
                              result[index].categoryName,
                              description:
                              result[index].description,
                              image: result[index].image,
                              price: result[index].price,
                              stream: streamController.stream,
                              callback: callback)),
                    );
                    streamController.add(true);
                  },
                  child: FavoriteCard(
                    id: result[index].productId,
                    index: index,
                    title: result[index].title,
                    saving: result[index].saving,
                    category: result[index].categoryName,
                    description: result[index].description,
                    image: result[index].image,
                    price: result[index].price,
                    callback: callback,
                  ));
            }),
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, color: Colors.grey, size: 80),
            SizedBox(height: 30),
            Text("Keine Ergebnisse gefunden", style: TextStyle(fontSize: 18, color: Colors.black))
          ],
        ),
      ),
    );
  }
}



