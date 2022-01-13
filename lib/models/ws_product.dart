// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

ProductWS productFromJson(String str) => ProductWS.fromJson(json.decode(str));

String productToJson(ProductWS data) => json.encode(data.toJson());

class ProductWS {
  ProductWS({
    required this.productId,
    required this.siteId,
    required this.date,
    required this.currentPrice,
    required this.previousPrice,
    required this.dropPercentage,
    required this.dropAbsolute,
    required this.productName,
    required this.productImageUrl,
    required this.productPageUrl,
    required this.categoryId,
  });

  int productId;
  int siteId;
  DateTime date;
  String currentPrice;
  String previousPrice;
  String dropPercentage;
  String dropAbsolute;
  String productName;
  String productImageUrl;
  String productPageUrl;
  int categoryId;

  factory ProductWS.fromJson(Map<String, dynamic> json) => ProductWS(
    productId: json["productId"],
    siteId: json["siteId"],
    date: DateTime.parse(json["date"]),
    currentPrice: json["currentPrice"],
    previousPrice: json["previousPrice"],
    dropPercentage: json["dropPercentage"],
    dropAbsolute: json["dropAbsolute"],
    productName: json["productName"],
    productImageUrl: json["productImageUrl"],
    productPageUrl: json["productPageUrl"],
    categoryId: json["categoryId"],
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "siteId": siteId,
    "date": date.toIso8601String(),
    "currentPrice": currentPrice,
    "previousPrice": previousPrice,
    "dropPercentage": dropPercentage,
    "dropAbsolute": dropAbsolute,
    "productName": productName,
    "productImageUrl": productImageUrl,
    "productPageUrl": productPageUrl,
    "categoryId": categoryId,
  };


  bool equals(ProductWS p) {
    return this.productId == p.productId;
  }

}
