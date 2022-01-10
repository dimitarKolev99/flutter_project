import 'package:penny_pincher/view/theme.dart';
import 'package:flutter/material.dart';
import 'package:penny_pincher/view/widget/app_bar_navigator.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';



class About extends StatefulWidget {



  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      //ScreenUtil.init(context, height:896, width:414, allowFontScaling: true);
        appBar: ExtendedViewAppBar(),
        body:
            Align(
                alignment: Alignment.center,
              child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Das Penny Pincher Team",
                      //textAlign: TextAlign.center,
                      style: GoogleFonts.pacifico(
                          textStyle:
                          TextStyle(
                            fontSize: 30,
                            decoration: TextDecoration.underline,
                          )),
                    ),

                    Text(
                        "Kaltenbach Christian"  "\n"
                        "Kolev Dimitar"         "\n"
                        "Kuehnau Marcel"        "\n"
                        "Ha Le Hiep"            "\n"
                        "Rapce Hermes"          "\n"
                        "Hahn Hendrik"          "\n"
                        "Siewertsen Paul"       "\n"
                        "Karmashikova Magdalena""\n"
                        "Stahf Jannes"          "\n",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                          textStyle:
                          TextStyle(
                            fontSize: 24,
                          )),
                    )
                  ],
                )
            )

    );
  }
}
