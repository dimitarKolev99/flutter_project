import 'dart:convert';

import 'package:penny_pincher/models/ws_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceArticlesWS {
  dynamic preferencesWS;

  Future addFavorite(ProductWS product) async {
    if (preferencesWS == null) {
      await _fetchData();
    }

    final rawData = preferencesWS.getString('favoritesWS');
    final jsonData = jsonDecode(rawData.toString());
    jsonData[product.productId.toString()] = fromCardToJson(product);
    await preferencesWS.setString("favoritesWS", jsonEncode(jsonData));
  }

  Future removeFavorite(int id) async {
    if (preferencesWS == null) {
      await _fetchData();
    }

    final rawData = preferencesWS.getString('favoritesWS');
    final jsonData = jsonDecode(rawData.toString());
    jsonData.remove(id.toString());
    await preferencesWS.setString("favoritesWS", jsonEncode(jsonData));
  }

  Future<List<ProductWS>> getAllFavorites() async {
    if (preferencesWS == null) {
      await _fetchData();
    }

    var rawData = preferencesWS.getString('favoritesWS');
    if (rawData == null) {
      await preferencesWS.setString("favoritesWS", "{}");
      rawData = preferencesWS.getString('favoritesWS');
    }
    final jsonData = jsonDecode(rawData.toString());
    List<ProductWS> products = [];
    jsonData.forEach((id, value) => products.add(fromJsonToProduct(id, value)));
    return products;
  }

  Future _fetchData() async {
    preferencesWS = await SharedPreferences.getInstance();
    // await preferencesWS.setString("favoritesWS", "{}"); // einkommentieren zum favoriten löschen
  }

  Map<String, dynamic> fromCardToJson(ProductWS product) => {
    'product_id': product.productId,
    'site_id': product.siteId,
    'date': product.date.toIso8601String(),
    'currentPrice': product.currentPrice,
    'previousPrice': product.previousPrice,
    'dropPercentage': product.dropPercentage,
    'dropAbsolute': product.dropAbsolute,
    'productName': product.productName,
    'productImageUrl': product.productImageUrl,
    'productPageUrl': product.productPageUrl,
    'category_id': product.categoryId,
  };

  ProductWS fromJsonToProduct(String id, Map<String, dynamic> json) {
    return ProductWS(
      productId: int.parse(id),
      siteId: json["site_id"],
      date: DateTime.parse(json["date"]),
      currentPrice: json["currentPrice"],
      previousPrice: json["previousPrice"],
      dropPercentage: json["dropPercentage"],
      dropAbsolute: json["dropAbsolute"],
      productName:json["productName"],
      productImageUrl: json["productImageUrl"],
      productPageUrl: json["productPageUrl"],
      categoryId: json["category_id"],
     );
  }
}