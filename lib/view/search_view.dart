import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/models/preferences_searches.dart';
import 'package:penny_pincher/view/subcategory_view.dart';
import 'package:penny_pincher/view/theme.dart';
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
        if(widget.searches.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit_outlined, color: Colors.grey, size: 80),
                SizedBox(height: 30),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text:
                          "Du hast noch keine Suchen gespeichert.\n \nDu kommst zurück zum Browser, indem du auf das ",
                          style: TextStyle(
                              fontSize: 18, color: ThemeChanger.reversetextColor)),
                      WidgetSpan(
                        child: Icon(Icons.bookmarks_outlined,
                            color: ThemeChanger.lightBlue, size: 20),
                      ),
                      TextSpan(
                          text: " klickst.",
                          style: TextStyle(
                              fontSize: 18, color: ThemeChanger.reversetextColor)),
                    ],
                  ),
                )
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: widget.names.length,
          itemBuilder: (context, index) {
            return SavedSearchCard(this, widget.names[index]);
        },);
      } else return CircularProgressIndicator();
    });


  }


}