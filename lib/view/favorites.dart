import 'package:penny_pincher/models/product.api.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/view/widget/article_card.dart';
import 'package:penny_pincher/view/widget/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class FavoritePage extends StatefulWidget {
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  //late Product _product;
  late List<Product> _product;
  late final List<Product> _products = [];
  bool _isLoading = true;
  var count = 0;
  Timer? _timer;

  @override
  void initState() {
    if(this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      getProducts();
      if(count>=_product.length - 1){
        dispose();
      }
    });
  }

  Future<void> getProducts() async {
    _product = await ProductApi.fetchProduct();
    if(this.mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    _products.insert(count, _product[count]);
    count++;
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromRGBO(23, 41, 111, 1),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Icon(Icons.restaurant_menu),
              Image.network(
                "https://cdn.discordapp.com/attachments/899305939109302285/903270501781221426/photopenny.png",
                width: 40,
                height: 40,
              ),
              /*
            // Doesnt work yet
            Image.asset("pictures/logopenny.png"
            , width: 40,
              height: 40,
            ),
            */
              SizedBox(width: 10),
              Text('Penny Pincher')
            ],
          )),
      bottomNavigationBar: BottomNavBarGenerator(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Align(
        alignment: Alignment.topCenter,
        child: ListView.builder(
            reverse: true,
            shrinkWrap: true,
            itemCount: _products.length,
            itemBuilder: (context, index) {
              return  ArticleCard(
                title: _products[index].title,
                category: _products[index].categoryName,
                description: _products[index].description,
                image: _products[index].image,
                price:  _products[index].price,);
              }),
      ),
    );
  }
}
