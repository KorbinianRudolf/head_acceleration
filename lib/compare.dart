import 'package:head_acceleration/colorCalculator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Compare {
  int _maxVal;
  int _dir;
  String _direction;


  ///maxVal: The value, that maxVal*G is the maximal acceleration
  ///dir: the direction, that is looked at
  Compare(int maxVal, String dir) {
    _maxVal = maxVal;
    _direction = dir;
    if (dir == 'x') {
      _dir = 0;
    } else if (dir == 'y') {
      _dir = 1;
    } else if(dir == 'z') {
      _dir = 2;
    }
  }

  /// val: the list of the x,y and z value
  bool eval(List<int> val) {
    return (val[_dir] > _maxVal*ColorCalculator.G);
  }

  @override
  String toString() {
    return _dir.toString() + "," + _maxVal.toString();
  }

  int get dir => _dir;
  int get maxVal => _maxVal;
  String get direction => _direction;

  static save(List<Compare> cons) async {
    final prefs = await SharedPreferences.getInstance();
    int i = 0;
    cons.forEach((el) {
      final key = i.toString();
      final value = cons.toString();
      prefs.setString(key, value);
      print('saved $value');
    });
  }

  static Future<List<Compare>> read() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    List<Compare> out = [];
    keys.forEach((key) {
        String val = prefs.get(key) ?? "";
        if(val != "") {
          var vals = val.split(",");
          out.add(new Compare(int.parse(vals[1]), val[0]));
        }
    });
    return out;
  }

  static bool tryAll(List<int> accs) {
    bool out = false;
    Compare.read().then((vals) {
      vals.forEach((val) {
        out = out || val.eval(accs);
      });

    });
    return out;
  }


}