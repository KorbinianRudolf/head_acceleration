import 'package:flutter/material.dart';


class DetailsPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<DetailsPage> {

  @override
  Widget build(BuildContext context) {
        return new Scaffold(
          backgroundColor: Colors.indigo,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text('Details zur Gefahr zu hoher Beschleunigung'),
            leading: IconButton(icon: Icon(Icons.chevron_left),
            onPressed: () => Navigator.pop(context, false)),
          ),
          body: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("TO BE DONE"),  //TODO
              ],
            )
          ),
        );
  }

}