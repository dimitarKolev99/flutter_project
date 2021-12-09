import 'package:penny_pincher/view/theme.dart';
import 'package:flutter/material.dart';
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
        appBar: AppBar(
          backgroundColor: ThemeChanger.navBarColor,
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
              Padding(
                padding: EdgeInsets.only(top: 3),
                child: Text(
                  'Penny Pincher',
                  style: TextStyle(
                    // Shaddow is used to get Distance to the underline -> TextColor itself is transparent
                    shadows: [
                      Shadow(
                          color: ThemeChanger.textColor,
                          offset: Offset(0, -5))
                    ],
                    //fontFamily: '....',
                    fontSize: 21,
                    letterSpacing: 3,
                    color: Colors.transparent,
                    fontWeight: FontWeight.w900,
                    decoration: TextDecoration.underline,
                    decorationColor: ThemeChanger.highlightedColor,
                    decorationThickness: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
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
