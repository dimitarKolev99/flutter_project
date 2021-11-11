import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/models/product.dart';

class FilterView extends StatefulWidget{
  
  @override
  State<FilterView> createState() => _FilterViewState ();
}

class _FilterViewState extends State<FilterView> {

  var _currentSliderValue = 0.0;
  @override
  Widget build(BuildContext context){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Price",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Color.fromRGBO(23, 41, 111, 1),
          ),),
        Slider(value: _currentSliderValue,
        min: 0,
        max: 100,
        divisions: 5,
        label: _currentSliderValue.round().toString(),
        onChanged: (double value){
        setState(() {
          _currentSliderValue = value;
        });
        },
      )]
    ));
  }
}