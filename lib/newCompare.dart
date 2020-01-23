import 'package:flutter/material.dart';
import 'package:head_acceleration/colorCalculator.dart';
import 'package:head_acceleration/compare.dart';

class NewComparePage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<NewComparePage> {
  TextStyle _white = new TextStyle(color: Colors.white);

  SnackBar _fail;

  SnackBar _wrongValue = new SnackBar(
      content: new Text("Die Beschleunigung muss eine Zahl größer 1 sein"));
  SnackBar _wrongDir = new SnackBar(
      content: new Text(
          "Die Richtung muss x,y oder z aus dem Standardkoordinatensystem entsprechen"));

  int _value = 0;
  String _dir = "";

  bool _validate(val, String dir) {
    String dirLow = dir.toLowerCase();

    if (val == null || val <= 1) {
      _fail = _wrongValue;
      return false;
    } else if (dirLow != 'x' || dirLow != 'y' || dirLow != 'z') {
      _fail = _wrongDir;
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: new Text('Neue Höchstbeschleunigung'),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            new Text(
              "Beschleunigung 'a' als Faktor für 'a*${ColorCalculator.G}'",
              style: _white,
            ),
            new Text(
              "Richtung als x, y oder z Richung angeben",
              style: _white,
            ),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (input) {
                _value = int.parse(input);
              },
            ),
            TextField(
              onChanged: (input) {
                _dir = input;
              },
            ),
            RaisedButton(
              child: new Text("Bestätigen",
                  style: new TextStyle(color: Colors.white)),
              onPressed: () {
                if (_validate(_value, _dir)) {
                  Compare.add(new Compare(_value, _dir));
                } else {
                  Scaffold.of(context).showSnackBar(_fail);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
