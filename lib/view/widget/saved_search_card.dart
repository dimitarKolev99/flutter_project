import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../theme.dart';


class SavedSearchCard extends StatelessWidget {
  String name;
  // callback to SearchView
  dynamic callback;

  SavedSearchCard(
      this.callback,
      this.name,

      ){

  }

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

    return Container(
        margin: EdgeInsets.symmetric(horizontal: blockSizeHorizontal * 3, vertical: blockSizeVertical * 0.5),
        height: blockSizeVertical * 10,
        decoration: BoxDecoration(
        color: ThemeChanger.articlecardbackground,
        borderRadius: BorderRadius.circular(3),
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
        child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Container(
                      margin: EdgeInsets.only(left: blockSizeHorizontal * 2, top: blockSizeVertical * 2),//(left: 4, right: 4, top: 20),
                      width: blockSizeHorizontal * 45,//displayWidth/3 ,
                      //height: blockSizeVertical * 10,
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: safeBlockHorizontal * 4.5,//16,
                          color: ThemeChanger.reversetextColor,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    // Price & Discount Badges
                    Container(
                      margin: EdgeInsets.only(left: blockSizeHorizontal * 2),
                      child:
                    Row(
                      children:[
                        // Show Min & Max Price only if they were set
                        (callback.widget.searches[name].startValue > 0) ?
                        buildBadge(true, callback.widget.searches[name].startValue.toString()): SizedBox(width: 0),
                        (callback.widget.searches[name].endValue != 4900) ?
                        buildBadge(false, callback.widget.searches[name].endValue.toString()): SizedBox(width: 0),
                        buildDiscountBadge(callback.widget.searches[name].discounts),
                      ]
                    ), ),


                    ],
                    ),
                // ICON FOR REMOVING A SAVED SEARCH
                Container(
                  margin: EdgeInsets.only(right: 8),
                  child:
                  IconButton(icon: Icon(Icons.delete_rounded, color: Colors.redAccent,),
                    onPressed: () {
                     callback.setState(() {
                       callback.widget.prefs.removeSearch(name);
                     });
                    }),
                )
              ],
            )
            );
            }


              Widget buildDiscountBadge(dynamic discounts){

                for(int i = 0; i<discounts.length; i++){
                  if(discounts[i][1] == true){
                    return Container(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                        margin: EdgeInsets.only(right: 3, top: 5, bottom: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          color: ThemeChanger.lightBlue,
                        ),
                        child:
                        Text("> ${discounts[i][0].toString()} %", style:
                        TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ThemeChanger.textColor
                        ),)
                    );
                }
                }
                return SizedBox(width: 0,);
              }

              Widget buildBadge(bool isBigger, String content)=>
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  margin: EdgeInsets.only(right: 3, top: 5, bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: ThemeChanger.lightBlue,
                  ),
                  child:
                  Text(isBigger? "> $content €": "< $content €", style:
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ThemeChanger.textColor
                    ),)
                );


}