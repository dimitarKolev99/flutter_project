class Product {
  List<Map<String, dynamic>> bargains = [];
  Product({
    //required this.subCategoryId,
    required this.categoryId,
    required this.categoryName,
    required this.productId,
    required this.title,
    required this.price,
    required this.saving,
    required this.description,
    required this.image,
  });

  //int subCategoryId;
  int categoryId;
  String categoryName;
  int productId;
  String title;
  int saving;
  double price;
  String description;
  String image;

  factory Product.fromJson(Map<String, dynamic> json) {

    return Product(
      //subCategoryId: json["id"],
      categoryId: json["category_id"],
      categoryName: json["category_name"],
      productId: json["product_id"],
      title: json["product_title"],
      price: json["price"].toDouble(),
      saving: json["saving"],
      description:json["description"],
      image: json["images"]["w120h100"][0],
    );
  }

   @override
  String toString(){
    return 'Product {title: $title, image: $image, description: $description}';
  }

  bool equals(Product p) {
    return this.productId == p.productId;
  }
}

