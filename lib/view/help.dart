import 'package:penny_pincher/view/theme.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/view/widget/app_bar_navigator.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';



class Help extends StatefulWidget {



  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    double displayWidth = _mediaQueryData.size.width;
    double displayHeight = _mediaQueryData.size.height;
    double blockSizeHorizontal = displayWidth / 100; // screen width in 1%
    double blockSizeVertical = displayHeight / 100; // screen height in 1%

    return Scaffold(
      //ScreenUtil.init(context, height:896, width:414, allowFontScaling: true);
        appBar: ExtendedViewAppBar(),
        body: Text("DOne"),
    );
  }
}
