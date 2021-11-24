import 'package:penny_pincher/models/preferences_articles.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/view/widget/article_card.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/view/widget/article_search.dart';
import 'dart:async';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';


import 'package:penny_pincher/view/widget/browser_article_card.dart';
import 'package:penny_pincher/view/widget/extended_view.dart';

StreamController<bool> streamController = StreamController<bool>.broadcast();

class ProfilePage extends StatefulWidget {
  late final Stream<bool> stream;
  late final StreamController updateStream;

  ProfilePage(this.stream, this.updateStream);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late List<Product> _product;
  late final List _favoriteIds = [];
  late final List<Product> _products = [];
  bool _isLoading = true;
  var count = 0;
  Timer? _timer;

  final _preferenceArticles = PreferencesArticles();

  @override
  void initState() {
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    super.initState();
    widget.stream.listen((update) {
      updateBrowser(update);
    });
    getProducts();
  }

  Future<void> getProducts() async {
    _product = await ProductApi.fetchProduct();
    List<Product> favorites = await _preferenceArticles.getAllFavorites();
    for (var i in favorites) {
      if (!_favoriteIds.contains(i.productId)) {
        _favoriteIds.add(i.productId);
      }
    }

    if (this.mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    _products.addAll(_product);
    //count++;
  }

  updateBrowser(bool update) {
    if (this.mounted) {
      updateFavorites();
    }
  }

  Future<void> updateFavorites() async {
    _favoriteIds.clear();
    List<Product> favorites = await _preferenceArticles.getAllFavorites();
    for (var i in favorites) {
      if (!_favoriteIds.contains(i.productId)) {
        _favoriteIds.add(i.productId);
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    ;
    double displayWidth = _mediaQueryData.size.width;
    double displayHeight = _mediaQueryData.size.height;
    double blockSizeHorizontal = displayWidth / 100; // bildschirmbreite in 1%
    double blockSizeVertical = displayHeight / 100; // bildschirmhöhe in 1%
    return Scaffold(
      //ScreenUtil.init(context, height:896, width:414, allowFontScaling: true);
      appBar: AppBar(
          backgroundColor: ProductApi.darkBlue,
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
              Padding(
                padding: EdgeInsets.only(top: 3),
                child: Text(
                  'Penny Pincher',
                  style: TextStyle(
                    // Shaddow is used to get Distance to the underline -> TextColor itself is transparent
                    shadows: [
                      Shadow(
                          color: Color.fromRGBO(240, 240, 240, 1),
                          offset: Offset(0, -5))
                    ],
                    //fontFamily: '....',
                    fontSize: 21,
                    letterSpacing: 3,
                    color: Colors.transparent,
                    fontWeight: FontWeight.w900,
                    decoration: TextDecoration.underline,
                    decorationColor: Color.fromRGBO(220, 110, 30, 1),
                    decorationThickness: 4,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                final results =
                    showSearch(context: context, delegate: ArticleSearch());
              },
            )
          ]),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 50),
              children: <Widget>[
                ProfileListItem(
                  icon: LineAwesomeIcons.user_shield,
                  text: "Optionen",
                ),
                ProfileListItem(
                  icon: LineAwesomeIcons.history,
                  text: "Kauf Verlauf",
                ),
                ProfileListItem(
                  icon: LineAwesomeIcons.accessible_icon,
                  text: "Hilfe",
                ),
                ProfileListItem(
                  icon: LineAwesomeIcons.address_book,
                  text: "Teilen",
                ),
              ],
            )
          )
        ]
      )



      /*
        Container(
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          children: [
            SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 25)),
                  textStyle: MaterialStateProperty.all(TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ))),
              child: Text("Suchverlauf"),
            ),
          ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 25)),
                    textStyle: MaterialStateProperty.all(TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ))),
                child: Text("Hilfe"),
              ),
            ),
          ],
        ),
      ),*/
    );
  }
}

class ProfileListItem extends StatelessWidget{
  //Source: https://github.com/jameelsocorro/profile_app_ui/blob/master/lib/widgets/profile_list_item.dart
  final IconData icon;
  final String text;
  final bool hasNavigation;

  const ProfileListItem({
    Key? key,
    required this.icon,
    required this.text,
    this.hasNavigation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(33),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: Offset(
              0.0,
              10.0,
            ),
            blurRadius: 20.0,
            spreadRadius: -3.0,
          ),
        ],
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          Icon(this.icon, size: 33, color: Colors.black,),
          SizedBox(width: 75), // space between icon and text 
          Text(this.text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 21,
              fontWeight: FontWeight.w500,
            ),
          )],
      ),
    );
  }
  
  
}
