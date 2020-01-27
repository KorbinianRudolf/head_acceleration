import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<DetailsPage> {
  Text _newText(String text) {
    return new Text(text, style: new TextStyle(color: Colors.white));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Details zur Gefahr zu hoher Beschleunigung'),
        leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () => Navigator.pop(context, false)),
      ),
      body: new Center(
        child: Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
            child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _newText(
                "Um die Beschleuigung zu beschreiben werden 3 Raumdimensionen verwendet:"),
            _newText("X: Die Achse, die senkrecht auf der Brust steht."),
            _newText("Y: Die Achse, die vertikal durch den Körper verläuft."),
            _newText("Z: Die Achse, die parallel zu den Schultern verläuft."),
            _newText(
                "Die Beschleunigung wird in m/s\u00B2 angegeben, bzw als Faktor a, sodass a*G die Beschleunigung ergibt."),
            _newText(
                "Dabei entspricht G der Erdbeschleunigung, oder ca. 10m/s\u00B2."),
            _newText(
                "In X und Z Richtung hält der Körper das bis zu 20fache der Erdbeschleunigung aus, bevor es gefährlich wird."),
            _newText(
                "In Y Richtung wird es schon früher gefährlich. Da spielt das Blut, das in bzw. aus dem Kopf gedrückt wird eine Rolle."),
            _newText(
                "Deswegen kann es schon ab 3*G zu einem Redout(zu viel Blut in den Augen und Kopf) oder einem Blackout (zu wenig Blut) kommen."),
          ],
        )),
      ),
    );
  }
}
