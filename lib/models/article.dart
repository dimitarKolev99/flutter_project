
class Article{
  final String name;
  final String images;
  final double rating;
  final String totalTime;

  Article({required this.name, required this.images, required this.rating, required this.totalTime});

  factory Article.fromJson(dynamic json){
    return Article(
        name: json['name'] as String,
        images: json['images'][0]['hostedLargeUrl'] as String,
        rating: json['rating'] as double,
        totalTime: json['totalTime'] as String
    );
  }

  static List<Article> recipesFromSnapshot(List snapshot){
    return snapshot.map((data){
      return Article.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return 'Recipe {name: $name, image: $images, rating: $rating, totalTime: $totalTime}';
  }
}