import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

class Product {
  List<Map<String, dynamic>> bargains = [];
  Product({
    required this.categoryId,
    required this.categoryName,
    required this.productId,
    required this.title,
    required this.price,
    required this.saving,
    required this.description,
    required this.smallImage,
    required this.bigImage,
    required this.productPageUrl,
    required this.previousPrice
  });



  int categoryId;
  String categoryName;
  int productId;
  String title;
  String saving;
  String price;
  String previousPrice;
  String description;
  String smallImage;
  String bigImage;
  String productPageUrl;

  final startIndex = 0;

  factory Product.fromJson(Map<String, dynamic> json) {

    return Product(
      categoryId: json["category_id"] != null ? json["category_id"] : json["categoryId"],
      categoryName: json["category_name"] != null ? json["category_name"] : "",
      productId: json["product_id"] != null ? json["product_id"] : json["productId"],
      title: json["product_title"] != null ? json["product_title"] : json["productName"],
      price: json["price"] != null ? json["price"].toString() : json["currentPrice"],
      previousPrice: json["previousPrice"] != null ? json["previousPrice"] : "",
      saving: json["saving"] != null ? json["saving"].toString() : json["dropPercentage"],
      description:json["description"] != null ? json["description"] : "",
      smallImage: json["images"] != null ? json["images"]["w168h140"][0].toString() : json["productImageUrl"].toString(),
      bigImage: json["images"] != null ? json["images"]["w600h600"][0].toString() : json["productImageUrl"].toString(),
      productPageUrl: json["productPageUrl"] != null ? json["productPageUrl"] : "",
    );
  }

   @override
  String toString(){
    return 'Product {title: $title, image: $smallImage, description: $description}';
  }

  bool equals(Product p) {
    return this.productId == p.productId;
  }
}

