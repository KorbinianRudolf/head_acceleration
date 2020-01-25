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
    print(dir);
    bool ret = true;
    if (val == null || val <= 1) {
      _fail = _wrongValue;
      ret = false;
    } else if (_dir != 'x' && _dir != 'y' && _dir != 'z') {
      _fail = _wrongDir;
      ret = false;
    }
    return ret;
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
      body: Builder(
        builder: (ctx) => new Center(
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
                cursorColor: Colors.white,
                style: _white,
                keyboardType: TextInputType.number,
                onChanged: (input) {
                  _value = int.parse(input);
                },
              ),
              TextField(
                cursorColor: Colors.white,
                style: _white,
                onChanged: (input) {
                  _dir = input.toLowerCase();
                },
              ),
              RaisedButton(
                color: Colors.black12,
                child: new Text("Bestätigen",
                    style: new TextStyle(color: Colors.white)),
                onPressed: () {
                  if (_validate(_value, _dir)) {
                    Compare.add(new Compare(_value, _dir));
                    Navigator.pop(context, false);
                  } else {
                    print("fail");
                    Scaffold.of(ctx).showSnackBar(_fail);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
