import 'package:flutter/material.dart';
import 'package:head_acceleration/compare.dart';
import 'package:head_acceleration/newCompare.dart';

class ConstraintsPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<ConstraintsPage> {
  List<Compare> _comps = [];
  bool _empty = true;
  TextStyle _white = new TextStyle(color: Colors.white);

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 50), () {    //if not added, the list is loaded, before the scaffold is build and it does not show the content
      setState(() {
        Compare.read().then((vals) {
          _comps = vals;
          _empty = (_comps.length == 0);
        });
      });
    });


  }

  _refresh() {
    setState(() {
      Compare.read().then((vals) {
        _comps = vals;
        _empty = (_comps.length == 0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        backgroundColor: Colors.indigo,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Personalisieren'),
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () => Navigator.pop(context, false),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewComparePage()),
                ).then((val) {
                  _refresh();
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _refresh,
            ),
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                Compare.clearAll();
                _refresh();
              },
            )
          ],
        ),
        body: new Center(
            child: new Column(
          children: <Widget>[
            _empty
                ? new Text("--Keine Elemente vorhanden--", style: _white)
                : SizedBox.shrink(),
            Container(
                height: 300.0,
                width: 300.0,
                child: ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: _comps.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        height: 50,
                        color: Colors.indigo[400],
                        child: Center(
                            child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Column(
                              children: <Widget>[
                                new Text("Wert: ${_comps[index].maxVal}",
                                    style: new TextStyle(color: Colors.white)),
                                new Text("Richtung: ${_comps[index].direction}",
                                    style: new TextStyle(color: Colors.white)),
                              ],
                            ),
                            new IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  Compare.delete(_comps[index]).then((val) {
                                    _refresh();
                                  });
                                }),
                          ],
                        )));
                  },
                )),
          ],
        )));
  }
}
