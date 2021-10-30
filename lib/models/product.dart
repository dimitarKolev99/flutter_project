import 'dart:convert';
/*class Recipe{
  final String name;
  final String images;
  final double rating;
  final String totalTime;

  Recipe({required this.name, required this.images, required this.rating, required this.totalTime});

  factory Recipe.fromJson(dynamic json){
    return Recipe(
      name: json['name'] as String,
      images: json['images'][0]['hostedLargeUrl'] as String,
      rating: json['rating'] as double,
      totalTime: json['totalTime'] as String
    );
  }

  static List<Recipe> recipesFromSnapshot(List snapshot){
    return snapshot.map((data){
      return Recipe.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return 'Recipe {name: $name, image: $images, rating: $rating, totalTime: $totalTime}';
  }
}

 */

// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);


String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  int id;
  String title;
  double price;
  String description;
  String category;
  String image;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    title: json["title"],
    price: json["price"].toDouble(),
    description: json["description"],
    category: json["category"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "price": price,
    "description": description,
    "category": category,
    "image": image,
  };
}

