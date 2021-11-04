import 'dart:convert';

class Product {
  Product({
    required this.subCategoryId,
    required this.categoryId,
    required this.categoryName,
    required this.productId,
    required this.title,
    required this.price,
    required this.saving,
    required this.description,
    required this.image,
  });

  int subCategoryId;
  int categoryId;
  String categoryName;
  int productId;
  String title;
  int saving;
  double price;
  String description;
  String image;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    subCategoryId: json["id"],
    categoryId: json["subCategories"][0]["productCategories"][0]["bargains"][0]["category_id"],
    categoryName: json["subCategories"][0]["productCategories"][0]["bargains"][0]["category_name"],
    productId: json["subCategories"][0]["productCategories"][0]["bargains"][0]["product_id"],
    title: json["subCategories"][0]["productCategories"][0]["bargains"][0]["product_title"],
    price: json["subCategories"][0]["productCategories"][0]["bargains"][0]["price"].toDouble(),
    saving: json["subCategories"][0]["productCategories"][0]["bargains"][0]["saving"],
    description: json["subCategories"][0]["productCategories"][0]["bargains"][0]["description"],
    image: json["subCategories"][0]["productCategories"][0]["bargains"][0]["images"]["w120h100"][0],
  );

   @override
  String toString(){
    return 'Product {title: $title, image: $image, description: $description}';
  }
}

