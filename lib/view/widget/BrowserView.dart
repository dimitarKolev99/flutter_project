import 'package:penny_pincher/models/recipe.api.dart';
import 'package:penny_pincher/models/recipe.dart';
import 'package:penny_pincher/view/widget/bottom_nav_bar.dart';
import 'package:penny_pincher/view/widget/recipe_card.dart';
import 'package:flutter/material.dart';

class BrowserView extends StatefulWidget {
  @override
  State<BrowserView> createState() => _BrowserViewState();
}

class _BrowserViewState extends State<BrowserView> {

  late List<Recipe> _recipes;
  bool _isLoading = true;

  @override
  void initState(){
    super.initState();

    getRecipes();
  }

  Future<void> getRecipes() async {
    _recipes = await RecipeApi.getRecipes();
    setState(() {
      _isLoading = false;
    });
    print(_recipes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color.fromRGBO(23, 41, 111, 1),
            title: Row(
              mainAxisAlignment:  MainAxisAlignment.center,
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
            )
        ),
        bottomNavigationBar: BottomNavBarGenerator(),
        body: _isLoading
            ? Center(child:CircularProgressIndicator())
            : ListView.builder(
            itemCount: _recipes.length,
            itemBuilder: (context, index) {
              return RecipeCard(
                  title: _recipes[index].name,
                  cookTime: _recipes[index].totalTime,
                  rating: _recipes[index].rating.toString(),
                  thumbnailUrl: _recipes[index].images);
            }
        )
    );
  }
}