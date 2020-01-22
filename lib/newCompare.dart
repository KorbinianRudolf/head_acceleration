import 'package:flutter/material.dart';

class newComparePage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<newComparePage> {

  int _value = 0;
  String _dir = "";
  bool _validate(val, dir) {
   //Todo
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: new Text('Neue Höchstbeschleunigung'),
        leading: IconButton(icon: Icon(Icons.chevron_left),
          onPressed:() => Navigator.pop(context, false),
        ),
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
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
              child: new Text("Bestätigen", style: new TextStyle(color: Colors.white)),
              onPressed: () {

                if(_validate(_value, _dir)){
                  //Todo
                }
              },
            )
          ],
        ),
      ),
    );
  }
}