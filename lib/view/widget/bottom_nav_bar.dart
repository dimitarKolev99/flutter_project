import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.update),
        label: "LiveFeed",
        //backgroundColor: Colors.black
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.filter_list_alt),
        label: "Browser",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.price_check),
        label: "SuperDeals",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle_sharp),
        label: "Profile",
      ),
    ],);
  }



}