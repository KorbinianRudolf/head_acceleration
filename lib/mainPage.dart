import 'package:flutter/material.dart';
import 'package:head_acceleration/colorCalculator.dart';
import 'package:head_acceleration/infoPage.dart';
import 'package:esense_flutter/esense.dart';
import 'dart:async';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:head_acceleration/addConstraint.dart';

class MainPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<MainPage> {
  FlutterBlue _flutterBlue = FlutterBlue.instance;
  bool _blueOn = false;
  String _powOTwo = '\u00B2';

  //colorStuff
  ColorCalculator cc = new ColorCalculator();
  Color curCo = ColorCalculator.NO_VALUE;

  //snackbars
  SnackBar _activateBlue = SnackBar(
    content: new Text("Bitte aktivieren Sie Bluetooth!"),
  );
  SnackBar _connect = SnackBar(
    content: new Text("Bitte verbinden Sie sich mit den Kopfhörern!"),
  );
  SnackBar _alreadyConnected = SnackBar(
    content: new Text("Verbindung schon hergestellt!"),
  );

  //eSense Stuff
  String _deviceStatus = 'unknown';
  bool sampling = false;
  String _event = '';
  String _button = 'not pressed';
  int _accX = 0;
  int _accY = 0;
  int _accZ = 0;
  int _maxAcc = 0;

  String eSenseName = 'eSense-0864'; //TODO change

  @override
  void initState() {
    super.initState();
    _flutterBlue.state.listen((event) {
      if (event == BluetoothState.on) {
        setState(() {
          _blueOn = true;
        });
        _connectToESense();
      } else {
        setState(() {
          _blueOn = false;
        });
      }
    });
  }

  Future<void> _connectToESense() async {
    bool con = false;
    ESenseManager.connectionEvents.listen((event) {
      print('CONNECTION event: $event');

      // when we're connected to the eSense device, we can start listening to events from it
      if (event.type == ConnectionType.connected) _listenToESenseEvents();

      setState(() {
        switch (event.type) {
          case ConnectionType.connected:
            _deviceStatus = 'connected';
            break;
          case ConnectionType.unknown:
            _deviceStatus = 'unknown';
            break;
          case ConnectionType.disconnected:
            _deviceStatus = 'disconnected';
            _stopListenToESenseEvents();
            _pauseListenToSensorEvents();
            _changeColor();
            break;
          case ConnectionType.device_found:
            _deviceStatus = 'device_found';
            break;
          case ConnectionType.device_not_found:
            _deviceStatus = 'device_not_found';
            break;
        }
      });
    });

    con = await ESenseManager.connect(eSenseName);

    setState(() {
      _deviceStatus = con ? 'connecting' : 'connection failed';
    });
  }

  StreamSubscription esenseEvent;

  void _listenToESenseEvents() async {
    esenseEvent = ESenseManager.eSenseEvents.listen((event) {
      print('ESENSE event: $event');

      setState(() {
        switch (event.runtimeType) {
          case BatteryRead:
            // _voltage = (event as BatteryRead).voltage;
            break;
          case ButtonEventChanged:
            _button = (event as ButtonEventChanged).pressed
                ? 'pressed'
                : 'not pressed';
            break;
        }
      });
    });

    _getESenseProperties();
  }

  void _stopListenToESenseEvents() async {
    esenseEvent.cancel();
  }

  void _getESenseProperties() async {
    print(_deviceStatus);
  }

  StreamSubscription esenseSubscription;

  void _startListenToSensorEvents() async {
    // subscribe to sensor event from the eSense device
    print(sampling);
    esenseSubscription = ESenseManager.sensorEvents.listen((event) {
      print('SENSOR event: $event');
      setState(() {
        _event = event.toString();
        print(event.accel);
        _accX = event.accel[0];
        _accY = event.accel[1];
        _accZ = event.accel[2];

        _changeColor();

        int _maxAb = _maxAcc.abs();
        if (_accX.abs() > _maxAb) {
          _maxAcc = _accX;
        }
        if (_accY.abs() > _maxAb) {
          _maxAcc = _accY;
        }
        if (_accZ.abs() > _maxAb) {
          _maxAcc = _accZ;
        }
      });
    });
    setState(() {
      sampling = true;
    });
  }

  void _pauseListenToSensorEvents() async {
    print(sampling);
    esenseSubscription.cancel();
    curCo = ColorCalculator.NO_VALUE;
    setState(() {
      sampling = false;
    });
  }

  void dispose() {
    _pauseListenToSensorEvents();
    ESenseManager.disconnect();
    super.dispose();
  }

  _changeColor() {
    setState(() {
      //curCo = cc.alternate();
      if (!ESenseManager.connected) {
        curCo = ColorCalculator.NO_VALUE;
      } else {
        curCo = cc.calc(_accX, _accY, _accZ, sampling);
      }
    });
  }

  String _germanStatus(String status) {
    switch (status) {
      case 'connected':
        return "verbunden";
        break;
      case 'unknown':
        return "unbekannt";
        break;
      case 'disconnected':
        return "getrennt";
        break;
      case 'device_found':
        return "Gerät gefunden";
        break;
      case 'device_not_found':
        return "Gerät nicht gefunden";
        break;
      default:
        return "unbekannt";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: curCo,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: new IconButton(
            icon: Icon(Icons.info_outline),
              color: Colors.white,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InfoPage()));
              },
          ),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConstraintsPage()),
                );
              },),
          ],
        ),
        body: new Center(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
              new Text(
                  "Maximal Gemessene Beschleunigung: ${(_maxAcc.abs() / 1000).round()} m/s$_powOTwo",
                  style: new TextStyle(color: Colors.white)),
              new Text(
                  (_blueOn)
                      ? "Derzeitiger Status: ${_germanStatus(_deviceStatus)}"
                      : "Bitte aktivieren Sie Bluetooth",
                  style: new TextStyle(color: Colors.white)),
              /*new RaisedButton(
                onPressed: () =>  _changeColor(0),
                child: new Text("change"),
                color: Colors.black26,
                textColor: Colors.white,

              ), */
              new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.black26,
                      child: new Text('Neu verbinden',
                          style: new TextStyle(color: Colors.white)),
                      onPressed: () {
                        if (_blueOn) {
                          if (!ESenseManager.connected) {
                            _connectToESense();
                          } else {
                            final snackbar = _alreadyConnected;
                            Scaffold.of(context).showSnackBar(snackbar);
                          }
                        } else {
                          final snackbar = _activateBlue;
                          Scaffold.of(context).showSnackBar(snackbar);
                        }
                      },
                    ),
                    RaisedButton(
                      color: Colors.black26,
                      onPressed: () {
                        if (_blueOn && ESenseManager.connected) {
                          (!sampling)
                              ? _startListenToSensorEvents()
                              : _pauseListenToSensorEvents();
                        } else {
                          final snackbar =
                              (!_blueOn) ? _activateBlue : _connect;
                          Scaffold.of(context).showSnackBar(snackbar);
                        }
                      },
                      child: Icon((!sampling) ? Icons.play_arrow : Icons.pause,
                          color: Colors.white),
                    ),
                  ]),
            ])));
  }
}
