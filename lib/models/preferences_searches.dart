import 'dart:async';
import 'dart:convert';

import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/view/subcategory_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

// this class will store all the informations
class PreferencesSearch {
  dynamic preferences;

  Future addSearch(SubcategoryView search, String name, Map<String, dynamic> chosenCats) async {
    if (preferences == null) {
      await _fetchData();
    }

    final rawData = preferences.getString('searches');
    final jsonData = jsonDecode(rawData.toString());
    jsonData[name] = fromSearchToJson(search, chosenCats);
    await preferences.setString("searches", jsonEncode(jsonData));
  }

  Future removeSearch(String name) async {
    if (preferences == null) {
      await _fetchData();
    }

    final rawData = preferences.getString('searches');
    final jsonData = jsonDecode(rawData.toString());
    jsonData.remove(name);
    await preferences.setString("searches", jsonEncode(jsonData));
  }

  Future<Map<String,SubcategoryView>> getAllSearches(Stream<bool> stream, StreamController updateStream, dynamic callback) async {
    if (preferences == null) {
      await _fetchData();
    }

    var rawData = preferences.getString('searches');
    if (rawData == null) {
      await preferences.setString("searches", "{}");
      rawData = preferences.getString('searches');
    }
    final jsonData = jsonDecode(rawData.toString());
    Map<String, SubcategoryView> searches = new Map();
    jsonData.forEach((name, value) => searches[name] = fromJsonToSearch(name, value, stream, updateStream, callback));
    return searches;
  }

  Future _fetchData() async {
    preferences = await SharedPreferences.getInstance();
    //await preferences.setString("searches", "{}"); // einkommentieren zum favoriten löschen
  }


  Map<String, dynamic> fromSearchToJson(SubcategoryView view, Map<String, dynamic> chosenCats) {
    int dscnt = 0;

    // if no discount at all, then take 0
    for(int i = 1; i<=view.discounts.length; i++) {
      if(view.discounts[i-1][1] == true) {
        dscnt = i;
      }
    }

    return {
        'category_id': view.categoryId,
        'category_name': view.categoryName,
        'start_value': view.startValue,
        'end_value': view.endValue,
        'saving': view.saving,
        'min_price': view.minPrice,
        'max_price': view.maxPrice,
        'discount': dscnt,
        'range_min': view.currentSliderValuesPrice.start,
        'range_max': view.currentSliderValuesPrice.end,
        'chosenCats': JsonEncoder().convert(chosenCats),
      };
  }


  SubcategoryView fromJsonToSearch(String name, Map<String, dynamic> json, Stream<bool> stream, StreamController updateStream, dynamic callback) {
    return SubcategoryView.fromSave(
      json["category_id"].toInt(),
      json["category_name"],
      json["start_value"].toInt(),
      json["end_value"].toInt(),
      json["saving"].toInt(),
      json["min_price"].toInt(),
      json["max_price"].toInt(),
      json["discount"].toInt(),
      json["range_min"].toDouble(),
      json["range_max"].toDouble(),
      JsonDecoder().convert(json["chosenCats"]),
      stream,
      updateStream,
      callback
    );
  }
}