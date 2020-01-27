import 'package:flutter/material.dart';
import 'package:head_acceleration/colorCalculator.dart';
import 'package:head_acceleration/detailsPage.dart';


class InfoPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.indigo,
        appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text('Informationen und Kategorien'),
            leading: IconButton(icon:Icon(Icons.chevron_left),
              onPressed:() => Navigator.pop(context, false),
            )
        ),
        body: new Center(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
              new Column(
                children: <Widget>[
                  new Text("Allgemeines:",
                      style: new TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  new Text(
                      "Abhängig von der Positionierung eines menschlichen Körpers, kann dieser nur Beschleunigungen bis zu einem bestimmten Grad aushalten!",
                      style: new TextStyle(color: Colors.white)),
                ],
              ),
              new Text("Kategorien:",
                  style: new TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              new Column(
                children: <Widget>[
                  new Text("Grau:", style: new TextStyle(color: ColorCalculator.NO_VALUE)),
                  new Text("Kein Gerät verbunden oder fehlerhafte Daten",
                      style: new TextStyle(color: Colors.white)),
                ],
              ),
              new Column(
                children: <Widget>[
                  new Text("Grün:", style: new TextStyle(color: ColorCalculator.NO_DANGER)),
                  new Text("Keine Gefahr",
                      style: new TextStyle(color: Colors.white)),
                ],
              ),
            new Column(
              children: <Widget>[
                new Text("Gelb:", style: new TextStyle(color: ColorCalculator.MEDIUM)),
                new Text("Aushaltbar, bzw. Beschleunigung erkannt",
                    style: new TextStyle(color: Colors.white)),
              ],
            ),
              new Column(
                children: <Widget>[
                  new Text("Rot:", style: new TextStyle(color: ColorCalculator.DANGER)),
                  new Text("Gefahr! So bald wie möglich Beschleunigung verringern",
                      style: new TextStyle(color: Colors.white)),
                ],
              ),

              new RaisedButton(
                color: Colors.black12,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailsPage()),
                  );
                },
                child: new Text("weitere Informationen", style: new TextStyle(color: Colors.white)),
              )
            ])));
  }
}
