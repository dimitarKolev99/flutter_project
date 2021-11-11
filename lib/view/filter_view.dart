import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/models/product.dart';

class FilterView extends StatefulWidget {
  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  var _currentSliderValuePrice = 0.0;
  var _currentSliderValueRabatt = 0.0;



  @override
  Widget build(BuildContext context) {

    MediaQueryData _mediaQueryData;
    double displayWidth;
    double displayHeight;
    double blockSizeHorizontal;
    double blockSizeVertical;

    _mediaQueryData = MediaQuery.of(context);
    displayWidth = _mediaQueryData.size.width;
    displayHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = displayWidth / 100;
    blockSizeVertical = displayHeight / 100;

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

                SizedBox(width: 10),
                Text('Penny Pincher')
              ],
            )),
    body: Container(
      height: blockSizeHorizontal * 30,
      width: displayWidth,
      //color: Colors.red,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Price",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromRGBO(23, 41, 111, 1),
                ),
              ),
              Container(
                //color: Colors.green,
                width: blockSizeHorizontal * 80,
                child: Slider(
                  value: _currentSliderValuePrice,
                  min: 0,
                  max: 100,
                  divisions: 5,
                  label: _currentSliderValuePrice.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _currentSliderValuePrice = value;
                    });
                  },
                ),
              )
            ],
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rabatt",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromRGBO(23, 41, 111, 1),
                ),
              ),
              Container(
               // color: Colors.green,
                width: blockSizeHorizontal * 80,
                child: Slider(
                  value: _currentSliderValueRabatt,
                  min: 0,
                  max: 100,
                  divisions: 5,
                  label: _currentSliderValueRabatt.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _currentSliderValueRabatt = value;
                    });
                  },
                ),
              )
            ]
          )

        ])));
  }
}

/*
Scaffold(
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
 */
