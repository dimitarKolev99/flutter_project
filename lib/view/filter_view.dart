import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/services/product_api.dart';

class FilterView extends StatefulWidget {

  var categoryName;

  FilterView({
    this.categoryName,
  });

  factory FilterView.fromJson(Map<String, dynamic> json){

    return FilterView(
      categoryName: json["category_name"],
    );
  }





  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  var _currentSliderValuePrice = 0.0;
  var _currentSliderValueDiscount = 0.0;




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

                SizedBox(width: 10),
                Text('Penny Pincher')
              ],
            )),
    body: Row(
        children: [
          Container(
              padding: EdgeInsets.only(left: blockSizeHorizontal * 5),
              height: blockSizeVertical * 18,
              width: displayWidth,
              //color: ProductApi.lightBlue,

              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [

                        Text(
                          "Price",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: ProductApi.darkBlue,
                            //backgroundColor: ProductApi.orange,
                          ),
                        ),

                        Container(
                          //color: Colors.green,
                          width: blockSizeHorizontal * 70,

                          child: Slider(
                            activeColor: ProductApi.darkBlue,
                            //inactiveColor: ProductApi.orange,
                            value: _currentSliderValuePrice,
                            min: 0,
                            max: 100,
                            divisions: 5,
                            label: _currentSliderValuePrice.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                _currentSliderValuePrice = value;
                              });},
                          ),
                        )],
                    ),

                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Discount",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: ProductApi.darkBlue,
                            ),
                          ),
                          Container(
                            //color: Colors.green,
                            width: blockSizeHorizontal * 70,
                            child: Slider(
                              activeColor: ProductApi.darkBlue,
                              value: _currentSliderValueDiscount,
                              min: 0,
                              max: 100,
                              divisions: 5,
                              label: _currentSliderValueDiscount.round().toString(),
                              onChanged: (double value) {
                                setState(() {
                                  _currentSliderValueDiscount = value;
                                });
                                },
                            ),
                          )
                        ])
                  ])
          ),
        ])
    );
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
