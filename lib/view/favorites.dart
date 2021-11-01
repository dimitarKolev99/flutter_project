import 'dart:convert';

import 'package:penny_pincher/models/product.api.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/view/widget/favorite_card.dart';
import 'package:penny_pincher/view/widget/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';



class FavoritePage extends StatefulWidget {
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  //late Product _product;

  late List<Product> _product;
  late final List<Product> _products = [];
  bool _isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    if(this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    super.initState();
    getProducts();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // displayName = prefs.getStringList('displayName');
    });
  }

  Future<void> getProducts() async {
    _product = await ProductApi.fetchProduct();
    if(this.mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    for (var i = 0; i < _product.length; i++) {
      _products.insert(i, _product[i]);
    }
  }

  void removeFavorite(int index) {
    if(this.mounted) {
      setState(() {
        _products.removeAt(index);
      });
    }
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
          ),
          actions: [
          IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            removeFavorite(0);
          },
        )
    ]),
      bottomNavigationBar: BottomNavBarGenerator(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Align(
        alignment: Alignment.topCenter,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: _products.length,
            itemBuilder: (context, index) {
              return FavoriteCard(
                index: index,
                title: _products[index].title,
                category: _products[index].category,
                description: _products[index].description,
                image: _products[index].image,
                price:  _products[index].price,
              removeFunction: removeFavorite,);

            }),
      ),
    );
  }
}
