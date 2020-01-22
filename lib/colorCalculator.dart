import 'package:flutter/material.dart';
import 'dart:math';
import 'package:head_acceleration/compare.dart';

class ColorCalculator {
  ColorCalculator();

  static const Color NO_DANGER = Colors.green;
  static const Color MEDIUM = Colors.orange;
  static const Color DANGER = Colors.red;
  static const Color NO_VALUE = Colors.grey;
  static const int G = 10 * 1000;

  //Test variable just used for alternate(), to have a color changing effect for test purposes
  int current = -1;

  //Test Method, to change the color, until i have actual data to use and evaluate
  Color alternate() {
    if (current == -1) {
      current++;
      return NO_VALUE;
    } else if (current == 0) {
      current++;
      return NO_DANGER;
    } else if (current == 1) {
      current++;
      return MEDIUM;
    } else {
      current = 0;
      return DANGER;
    }
  }

  //select color depending on the total acceleration of the device hence of the head
  Color calc(accX, accY, accZ, sampling) {
    if (_isDanger(accX, accY, accZ)) {
      return DANGER;
    } else if (_isMedium(accX, accY, accZ)) {
      return MEDIUM;
    } else if (accX <= G && accY <= G && accZ <= G) {
      return NO_DANGER;
    } else if(Compare.tryAll([accX,accY,accZ])) {
      return DANGER;
    }
    return NO_DANGER;
  }

  bool _isDanger(x, y, z) {
    if (y > 3 * G) {
      //acc in y direction (headstand)
      return true;
    } else if (x.abs() > (20 * G) || z.abs() > (20 * G)) {
      //absolute acc in x or z direction
      return true;
    } else {
      return false;
    }

  }

  bool _isMedium(x, y, z) {
    return (x > G || y > G || z > G || _absAcc(x, y, z) > G);
  }

  double _absAcc(x, y, z) {
    return sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2));
  }
}
