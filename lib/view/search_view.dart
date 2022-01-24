import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/models/preferences_searches.dart';
import 'package:penny_pincher/view/subcategory_view.dart';
import 'package:penny_pincher/view/widget/saved_search_card.dart';

class SearchView extends StatefulWidget {

  dynamic callback;

  late Map<String, SubcategoryView> searches;
  late List<String> names;

  PreferencesSearch prefs = PreferencesSearch();

  SearchView(this.callback);



  @override
  State<StatefulWidget> createState() => _SearchViewState();


}

class _SearchViewState extends State<SearchView> {

  Future<void> init() async {
    widget.searches = await widget.prefs.getAllSearches(widget.callback.widget.stream, widget.callback.widget.updateStream, widget.callback);
    widget.names = await getAllNames();
  }


  List<String> getAllNames() {
    List<String> names = [];

    widget.searches.forEach((key, value) {
      names.add(key);
    });
    return names;
  }



  @override
  Widget build(BuildContext context) {
  init();


    return FutureBuilder(future: init(),builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {

        return ListView.builder(
          itemCount: widget.names.length,
          itemBuilder: (context, index) {
            return SavedSearchCard(this, widget.names[index]);
        },);
      } else return CircularProgressIndicator();
    });


  }


}