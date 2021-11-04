import 'dart:convert';

class Product {
  Product({
    required this.subCategoryId,
    required this.categoryId,
    required this.productId,
    required this.title,
    //required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  int subCategoryId;
  int categoryId;
  int productId;
  String title;
  //double price;
  String description;
  String category;
  String image;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    subCategoryId: json["id"],
    categoryId: json["subCategories"][0]["productCategories"][0]["id"],
    productId: json["subCategories"][0]["productCategories"][0]["bargains"][0]["product_id"],
    title: json["subCategories"][0]["productCategories"][0]["bargains"][0]["product_title"],
    //price: json["subCategories"][0]["productCategories"][0]["bargains"][0]["best_price_offer"]["price"],
    description: json["subCategories"][0]["productCategories"][0]["bargains"][0]["description"],
    category: json["subCategories"][0]["productCategories"][0]["bargains"][0]["category_name"],
    image: json["subCategories"][0]["productCategories"][0]["bargains"][0]["images"]["w120h100"][0],
  );

   @override
  String toString(){
    return 'Product {title: $title, image: $image, description: $description, category: $category}';
  }
}

