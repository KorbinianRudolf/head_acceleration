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
      content: new Text("Die Beschleunigung muss eine Zahl größer/gleich 1 sein"));
  SnackBar _wrongDir = new SnackBar(
      content: new Text(
          "Es muss eine Richtung (x,y oder z) ausgewählt werden."));

  int _value = 1;
  String _dir = "";

  bool _validate(val, String dir) {
    print(dir);
    bool ret = true;
    if (val == null || val < 1) {
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Text(
                "Beschleunigung 'a' als Faktor für 'a*${ColorCalculator.G}'",
                style: _white,
              ),
              new Text(
                "Richtung als x, y oder z (Standardkoordinatensystem) angeben",
                style: _white,
              ),
              /*TextField(
                decoration: new InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.indigoAccent,
                      ),
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  hintText: "Beschleunigung",
                  hintStyle: new TextStyle(color: Colors.grey),
                ),
                textAlign: TextAlign.center,
                maxLength: 3,
                cursorColor: Colors.white,
                style: _white,
                keyboardType: TextInputType.number,
                onChanged: (input) {
                  _value = int.parse(input);
                },
              ),*/
              new Column(
                children: <Widget>[
                  Text("Beschleunigung (Aktuell: $_value G)", style: _white,),
                  Slider(
                    activeColor: Colors.black,
                    inactiveColor: Colors.black26,
                    divisions: 19,
                    min: 1,
                    max: 20,
                    value: _value.toDouble(),
                    onChanged: (newVal) {
                      setState(() {
                        _value = newVal.round();
                      });
                    },
                    label: "$_value G",
                  )
                ],
              ),

              /*    TextField(
                decoration: new InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.indigoAccent,
                    ),
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  hintText: "Richtung",
                  hintStyle: new TextStyle(color: Colors.grey),

                ),
                textAlign: TextAlign.center,
                maxLength: 1,
                cursorColor: Colors.white,
                style: _white,
                onChanged: (input) {
                  _dir = input.toLowerCase();
                },
              ),*/
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(children: <Widget>[
                    Text("x", style: _white),
                    Radio(
                      value: "x",
                      groupValue: _dir,
                      onChanged: (val) {
                        setState(() {
                          _dir = val;
                        });
                      },
                    )
                  ]),
                  Column(children: <Widget>[
                    Text("y", style: _white),
                    Radio(
                      value: "y",
                      groupValue: _dir,
                      onChanged: (val) {
                        setState(() {
                          _dir = val;
                        });

                      },
                    )
                  ]),
                  Column(children: <Widget>[
                    Text("z", style: _white),
                    Radio(
                      value: "z",
                      groupValue: _dir,
                      onChanged: (val) {
                        setState(() {
                          _dir = val;
                        });
                      },
                    )
                  ]),
                ],
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
