import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/view/browser_view.dart';

import '../favorites.dart';
import '../home.dart';

class BottomNavBarGenerator extends StatefulWidget{

  const BottomNavBarGenerator({Key? key}) : super(key: key);
  @override
  _BottomNavBarGeneratorState createState() => _BottomNavBarGeneratorState();
}


class _BottomNavBarGeneratorState extends State<BottomNavBarGenerator>{

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: const Color.fromRGBO(220, 110, 30, 1),
      unselectedItemColor: const Color.fromRGBO(0, 0, 0, 1),
      iconSize: 22,
      backgroundColor: const Color.fromRGBO(23, 41, 111, 1),
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: IconButton(icon: Icon(Icons.update), onPressed: () {Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  HomePage()),
        );},),
        label: 'LiveFeed',
        ),
      BottomNavigationBarItem(
            icon: IconButton(icon: Icon(Icons.filter_list_alt), onPressed: () {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BrowserView()),
            );},),
            label: 'Browser',
        ),
      BottomNavigationBarItem(
        icon: IconButton(icon: Icon(Icons.price_check), onPressed: () {Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FavoritePage()),
        );},),
        label: "Merkzettel",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle_sharp),
        label: "Profile",
      ),
    ],);
  }



}