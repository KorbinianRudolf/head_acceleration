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
    } else if (dir == 'z') {
      _dir = 2;
    }
  }

  /// val: the list of the x,y and z value
  bool eval(List<int> val) {
    bool out = (val[_dir] > this._maxVal * ColorCalculator.G);
    return out;
  }

  @override
  String toString() {
    return direction + ";" + _maxVal.toString();
  }

  int get dir => _dir;

  int get maxVal => _maxVal;

  String get direction => _direction;

  static save(List<Compare> cons) async {
    final prefs = await SharedPreferences.getInstance();
    int i = 0;
    cons.forEach((el) {
      String key = "k" + i.toString();
      final value = cons.toString();
      prefs.setString(key, value);
      print('saved $value');
      i++;
    });
  }

  static clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (var value in keys) {
      prefs.remove(value);
    }
  }

  static Future<List<Compare>> read() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    List<Compare> out = [];

    if(keys.isEmpty) {
      return out;
    }
    var key = keys.elementAt(0);

    String val = prefs.getString(key) ?? "";

    if (val != "") {
      var vals = val.replaceAll("[", "").replaceAll("]", "");
      var allValues = vals.split(",");

      allValues.forEach((v) {
        var vals2 = v.split(";");
        out.add(new Compare(int.parse(vals2[1]), vals2[0]));
      });
    }

    return out;
  }

  static add(Compare comp) async {
    List<Compare> list = await read();
    list.add(comp);
    save(list);
  }


  static Future<bool> tryAll(List<int> accs) async {
    bool out = false;
    var vals = await read();
      vals.forEach((val) {
        bool va = val.eval(accs);
        print(va);
        if(va) {
          out = true;
        }
      });

    return out;
  }


  ///equals operation
  bool eq(Compare el) {
    return this._dir == el._dir && this._maxVal == el._maxVal;
  }

  static Future<bool> delete(Compare old) async {
    List<Compare> comps = await read();
    if(comps.length == 1) {
      clearAll();
      return true;        //solution to the problem, that the last element doesn't want to be deleted
    }
    bool found = false;
    Compare toDelete = null;
    comps.forEach((el) {
      if(old.eq(el)) {
        toDelete = el;
      }
    });

    if(toDelete != null) {
      found = comps.remove(toDelete);
    }
    print(toDelete);
    print(found);
    save(comps);
    return found;
  }

}
