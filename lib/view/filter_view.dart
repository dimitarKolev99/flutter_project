import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/services/product_api.dart';

class FilterView extends StatefulWidget {


  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  var _currentSliderValuePrice = 0.0;
  var _currentSliderValueDiscount = 0.0;
  late final List<String> _categories = ["Books", "Phones", "Computers", "Clothes", "Shoes", "Sweets", "School supplies"];
//"Category", "Category", "Category", "Category", "Category", "Category", "Category", "Category", "Category", "Category", "Category",
//     "Category", "Category", "Category", "Category", "Category", "Category"



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
    body: Column(
        children: [
          // Sliders
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
                            fontSize: 25,
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
                            divisions: 20,
                            label: _currentSliderValuePrice.round().toString() + "€",
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
                              fontSize: 25,
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
                              divisions: 20,
                              label: _currentSliderValueDiscount.round().toString() + "€",
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
          //SizedBox(height: 7),

          Container(
            alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 21),
              child:
              Text(
                "Categories",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: ProductApi.darkBlue,
                ),
              ),
          ),

          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
              childAspectRatio: 3.5,
              children: List.generate(_categories.length, (index) {
                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  margin: EdgeInsets.symmetric(horizontal: blockSizeHorizontal * 2, vertical: blockSizeVertical * 0.8),
                  decoration: BoxDecoration(
                    color: ProductApi.lightBlue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  //width: displayWidth / 1.5,
                  //height: displayHeight / 8,
                  child: Text(
                    _categories[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                    //backgroundColor: ProductApi.orange,
                    color: ProductApi.white,
              ),
            ),
          );}),
          ),

          //Save Button
          Container(
            //color: ProductApi.orange,
            height: blockSizeVertical * 37,
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.only(right: 21),
            child:
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ProductApi.darkBlue,
              ),
              child:
              const Text("Save",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: ProductApi.white,
                    //backgroundColor: ProductApi.darkBlue,
                  )),
              onPressed: () {},
            )
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
