import 'package:penny_pincher/models/product.api.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/view/widget/bottom_nav_bar.dart';
import 'package:penny_pincher/view/widget/product_card.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //late Product _product;
  late List<Product> _product;
  late final List<Product> _products = [];
  bool _isLoading = true;
  var count = 0;
  Timer? _timer;

  /* Stream<Product> getProducts = ( () async* {
    await Future<void>.delayed(Duration(seconds: 2));

      yield ProductApi().fetchProduct();
    }
  })();
*/

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    
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
    setState(() {
      _isLoading = false;
    });
    _products.insert(count, _product[count]);
    count++;
  }

  // @override
  // void initState() {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
  //     ProductApi().fetchProduct().then((product) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       _product = product;
  //       _products.insert(0, _product);
  //     });
  //   });
  //   super.initState();
  // }
  

  /*Future<void> getProduct() async {
    _product = await ProductApi().fetchProduct();
    _products.insert(0, _product);
    if (!_products.isEmpty) {
      setState(() {
        _isLoading = false;
      });
    }
  }
*/
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
            : ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                      title: _products[index].title,
                      category: _products[index].category,
                      description: _products[index].description,
                      thumbnailUrl: _products[index].image);
                }));
  }
}
  