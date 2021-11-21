import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:penny_pincher/models/product.dart';
import 'package:penny_pincher/services/product_api.dart';
import 'package:penny_pincher/view/widget/browser_article_card.dart';

class FilterView extends StatefulWidget {
  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  RangeValues _currentSliderValuesPrice = const RangeValues(20, 70);
  var _currentSliderValueDiscount = 0.0;

  late final List<String> _categories = [
    "Books",
    "Phones",
    "Computers",
    "Clothes",
    "Shoes",
    "Sweets",
    "School supplies",
    "Instruments",
    "Cars",
    "Airplanes",
  ];

  double _minValue = 0;
  double _maxValue = 100;

  late final List<String> _subCategories = [
    "EBooks",
    "Buecher",
    "Phones",
    "Samsung",
    "Apple",
    "Huawei",
    "Sony",
    "Computers",
    "AAAA",
    "BBBB",
    "CCCC",
    "DDDD",
    "EEEE",
    "FFFFF",
    "GGGGGG",
    "HHHHH",
    "IIIIII",
    "JJJJJJ",
    "KKKKKK",
    "KJSDHNKSD"
  ];

  bool _show = false;

//"Category", "Category", "Category", "Category", "Category", "Category", "Category", "Category", "Category", "Category", "Category",
//     "Category", "Category", "Category", "Category", "Category", "Category"

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData;
    double displayWidth;
    double displayHeight;
    double blockSizeHorizontal;
    double blockSizeVertical;

    double _safeAreaHorizontal;
    double _safeAreaVertical;
    double safeBlockHorizontal;
    double safeBlockVertical;

    _mediaQueryData = MediaQuery.of(context);
    displayWidth = _mediaQueryData.size.width;
    displayHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = displayWidth / 100;
    blockSizeVertical = displayHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (displayWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (displayHeight - _safeAreaVertical) / 100;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: ProductApi.darkBlue,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Categories',
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
                  decorationColor: ProductApi.white,
                  decorationThickness: 4,
                ),
              ),
              SizedBox(width: blockSizeHorizontal * 10),
            ],
          )),
      body: Column(children: [
        Visibility(
          visible: _show,
          child: Container(
          height: blockSizeVertical * 3,
          padding: EdgeInsets.only(left: 3),
          //margin: EdgeInsets.all(blockSizeHorizontal),
          color: ProductApi.orange,
          child: GridView.count(
            physics: ScrollPhysics(),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            crossAxisCount: 1,
            childAspectRatio: 0.3,

            children: List.generate(_subCategories.length, (index) {
              return Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 3),
                //color: ProductApi.white,
                child: Text(
                  _subCategories[index],
                  //textAlign: TextAlign.left,
                  style: TextStyle(
                    color: ProductApi.darkBlue,
                    fontSize: _safeAreaVertical * 0.6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            })
          ),
        ),
        ),

        Visibility(
          visible: !_show,
          child: Container(
            color: ProductApi.orange,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 6),
            height: blockSizeVertical * 3,
            child: Text(
              "Die gewählte Filter werden hier angezeigt",
              style: TextStyle(
                color: ProductApi.darkBlue,
                fontSize: _safeAreaVertical * 0.6,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Sliders
        Container(
            padding: EdgeInsets.only(left: blockSizeHorizontal * 0.5),
            height: blockSizeVertical * 35,
            width: displayWidth,
            //color: ProductApi.lightBlue,

            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(height: blockSizeVertical * 1.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: blockSizeHorizontal * 6, right: blockSizeHorizontal * 1),
                    //Headline: Price
                    child: Text("Price limit: ",
                        style: TextStyle(
                          color: ProductApi.darkBlue,
                          //fontWeight: FontWeight.bold,
                          fontSize: safeBlockHorizontal * 5,
                        )),
                  ),

                  //Output of slider
                  Container(
                    padding: EdgeInsets.only(
                        top: blockSizeVertical * 1,
                        bottom: blockSizeVertical * 1,
                        left: blockSizeHorizontal * 3,
                        right: blockSizeHorizontal * 3),
                    decoration: BoxDecoration(
                      color: ProductApi.lightBlue,
                      borderRadius:
                          BorderRadius.circular(blockSizeHorizontal * 3),
                    ),
                    child: Text(
                      _currentSliderValuesPrice.start.round().toString() +
                          " - " +
                          _currentSliderValuesPrice.end.round().toString() +
                          " €",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: safeBlockHorizontal * 4.8,
                        color: ProductApi.white,
                        //backgroundColor: ProductApi.lightBlue,
                      ),
                    ),
                  )
                ],
              ),

              //Slider for the Price Range
              Container(
                //color: Colors.green,
                width: blockSizeHorizontal * 100,
                child: RangeSlider(
                  activeColor: ProductApi.darkBlue,
                  //inactiveColor: ProductApi.orange,
                  values: _currentSliderValuesPrice,
                  min: _minValue,
                  max: _maxValue,
                  divisions: 100,
                  /*
                      labels: RangeLabels(
                        _currentSliderValuesPrice.start.round().toString() + "€",
                        _currentSliderValuesPrice.end.round().toString() + "€",
                      ),
                       */
                  onChanged: (RangeValues values) {
                    setState(() {
                      _currentSliderValuesPrice = values;
                    });
                  },
                ),
              ),

              //Slider for Discount
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                //Headline: Discount
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: blockSizeHorizontal * 6, right: blockSizeHorizontal * 4),
                  child: Text("Discount: ",
                      style: TextStyle(
                        color: ProductApi.darkBlue,
                        //fontWeight: FontWeight.bold,
                        fontSize: safeBlockHorizontal * 5,
                      )),
                ),

                //Output for Discount
                Container(
                  padding: EdgeInsets.only(
                      top: blockSizeVertical * 1,
                      bottom: blockSizeVertical * 1,
                      left: blockSizeHorizontal * 3,
                      right: blockSizeHorizontal * 3),
                  decoration: BoxDecoration(
                    color: ProductApi.lightBlue,
                    borderRadius:
                        BorderRadius.circular(blockSizeHorizontal * 3),
                  ),
                  child: Text(
                    _currentSliderValueDiscount.round().toString() + " %",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: safeBlockHorizontal * 4.8,
                      color: ProductApi.white,
                    ),
                  ),
                )
              ]),
              Container(
                //color: Colors.green,
                width: blockSizeHorizontal * 100,
                child: Slider(
                  activeColor: ProductApi.darkBlue,
                  value: _currentSliderValueDiscount,
                  min: 0,
                  max: 80,
                  divisions: 100,
                  // label: _currentSliderValueDiscount.round().toString() + "€",
                  onChanged: (double value) {
                    setState(() {
                      _currentSliderValueDiscount = value;
                    });
                  },
                ),
              ),
            ])),
        //SizedBox(height: 7),

        // Headline: Categories
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: blockSizeHorizontal * 7),
          child: Text("Categories",
              style: TextStyle(
                color: ProductApi.darkBlue,
                //fontWeight: FontWeight.bold,
                fontSize: safeBlockHorizontal * 5,
              )),
        ),
        SizedBox(height: blockSizeVertical * 3),
        Expanded(
          child: ListView.builder(
              physics: ScrollPhysics(),
              addAutomaticKeepAlives: false,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return Column(children: [
                  // Kategorienamen
                  ListTile(
                    onTap: () {
                      // Öffnet die Unterkategorien, wenn man auf die Kategorienamen tippt
                      setState(() {
                        _show = !_show;
                      });
                    },
                    title: Text(
                      _categories[index],
                      style: TextStyle(
                        color: ProductApi.darkBlue,
                        fontSize: safeBlockHorizontal * 4.2,
                      ),
                    ),
                    leading: CircleAvatar(
                      // backgroundColor: ProductApi.darkBlue,
                      child: FloatingActionButton(
                        backgroundColor: ProductApi.darkBlue,
                        onPressed: () {
                          setState(() {
                            // Öffnet die Unterkategorien, wenn man auf die Icons tippt
                            _show = !_show;
                          });
                        },
                        child: Icon(_show
                            ? Icons.arrow_drop_up_outlined
                            : Icons.arrow_drop_down),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _show,
                    child: Container(
                      //color: Colors.red,
                      height: blockSizeVertical * 15,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: ProductApi.white,
                        border: Border(
                          bottom: BorderSide(
                            color: ProductApi.orange,
                            width: 0.5,
                          ),
                          /*
                            top: BorderSide(
                              color: Colors.grey,
                              width: 0.5,
                            )*/
                        ),
                      ),
                      child: GridView.count(
                        physics: ScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        childAspectRatio: 0.45,
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        children: List.generate(_subCategories.length, (index) {
                          return Column(
                            children: [
                              Container(
                                  //color: Colors.red,
                                  //width: blockSizeHorizontal * 20,
                                  height: blockSizeVertical * 5,
                                  alignment: Alignment.center,
                                  //padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                  margin: EdgeInsets.only(
                                      //right: blockSizeHorizontal * 1.0,
                                      //bottom: blockSizeVertical * 0.8,
                                      //top: blockSizeVertical * 1.0,
                                      left: blockSizeHorizontal * 2.0),
                                  decoration: BoxDecoration(
                                    color: ProductApi.lightBlue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  //width: displayWidth / 1.5,
                                  //height: displayHeight / 8,
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Text(
                                      _subCategories[index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          //backgroundColor: ProductApi.orange,
                                          color: ProductApi.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                            ],
                          );
                        }),
                      ),
                    ),
                  )
                ]);
              }),
        ),

        /*
        ListView.builder(
                        shrinkWrap: true,
                        //semanticChildCount: 10,
                        scrollDirection: Axis.horizontal,
                        itemCount: _subCategories.length,
                        itemBuilder: (context, index) {
                          return Column(children: [
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Container(
                                //color: ProductApi.lightBlue,
                                height: blockSizeVertical * 7.0,
                                width: blockSizeHorizontal * 25.0,
                                decoration: BoxDecoration(
                                  color: ProductApi.lightBlue,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.6),
                                      offset: Offset(
                                        0.0,
                                        10.0,
                                      ),
                                      blurRadius: 10.0,
                                      spreadRadius: -6.0,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    _subCategories[index],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),),

                          )
                              ),
                            )
                          ]);
                        }),
         */

        /*
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            childAspectRatio: 3.5,
            children: List.generate(_categories.length, (index) {
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                margin: EdgeInsets.symmetric(
                    horizontal: blockSizeHorizontal * 2,
                    vertical: blockSizeVertical * 0.8),
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
              );
            }),
          ),



          //Save Button
          Container(
              color: ProductApi.orange,
              height: blockSizeVertical * 30,
              alignment: Alignment.bottomRight,
              margin: EdgeInsets.only(right: 21),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: ProductApi.darkBlue,
                ),
                child: const Text("Save",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: ProductApi.white,
                      //backgroundColor: ProductApi.darkBlue,
                    )),
                onPressed: () {},
              )
          ),

           */
      ]),
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
