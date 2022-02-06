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
        body: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget> [
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child:
                    Text("1. Produkte zum Merkzettel hinzufügen.",
                        style: TextStyle(
                          color: ThemeChanger.reversetextColor,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Text("Sie befinden momentan in LiveFeed oder in der Browserseite oder haben in der Suche ein Produkt gefunden "
                      "und möchten das Produkt speichern. Klicken Sie dafür das Herzsymbol rechts in der Artikelcard.",
                      style: TextStyle(
                        color: ThemeChanger.reversetextColor,
                      )),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(10),
              child:Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child:
                    Text("2. Produkte vom Merkzettel löschen.",
                        style: TextStyle(
                          color: ThemeChanger.reversetextColor,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Text("Klicken Sie das Herzsymbol in dem unteren Bar. Nun sind Sie in der Merkzettelseite gelandet und "
                      "können die gewünschte Produkte löschen, indem Sie auf das Herzsymbol rechts in der Artikelcard klicken. "
                      "Wählen Sie in dem Popup-Menü Ja aus und das Produkt wird vom Merkzettel gelöscht.",
                      style: TextStyle(
                        color: ThemeChanger.reversetextColor,
                      )),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(10),
              child:Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child:
                    Text("3. Produkte Filtern.",
                        style: TextStyle(
                          color: ThemeChanger.reversetextColor,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Text("Klicken Sie das Browsersymbol in dem unteren Bar. Dann wählen Sie eine der Hauptkategorien aus. "
                      "Nun sind Sie in der Filterseite dieser Hauptkategorie gelandet. "
                      "Hier können Sie filtern. Am Ende drücken Sie Zeige x Produkte.",
                      style: TextStyle(
                        color: ThemeChanger.reversetextColor,
                      )),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(10),
              child:Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child:
                    Text("4. Produkte nach Preise bzw. Rabatte filtern.",
                        style: TextStyle(
                          color: ThemeChanger.reversetextColor,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Text("Gehen Sie zur Filterseite und klappen Sie die Preisklasse aus. "
                      "Hier können Sie die Preisgrenze anpassen und ein Rabatt auswählen.",
                      style: TextStyle(
                        color: ThemeChanger.reversetextColor,
                      )),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(10),
              child:Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child:
                    Text("5. Unsere Empfehlung:",
                        style: TextStyle(
                          color: ThemeChanger.reversetextColor,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Text("Lassen Sie die Preisklasse immer eingeklappt sein für ein besseres Übersicht der Filterseite. "
                      "Natürlich nachdem Sie in der Preisklasse fertig sind.",
                      style: TextStyle(
                        color: ThemeChanger.reversetextColor,
                      )),
                ],
              ),
            ),
          ],
        ),
    );
  }
}
