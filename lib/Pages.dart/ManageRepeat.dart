import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

enum day {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

class ManageRepeatPage extends ChangeNotifier {
  List<bool> _checkBox;

  ManageRepeatPage() {
    _checkBox = [false, false, false, false, false, false, false, true];
  }
  List<bool> get checkBox {
    return _checkBox;
  }

  set(bool isRepeat, int index) {
    _checkBox[index] = isRepeat;
    _checkBox[7] = false;
    print(_checkBox.toString());
    notifyListeners();
  }

  void setAllCheckBox(bool isRepeat) {
    _checkBox = [false, false, false, false, false, false, false, true];
    notifyListeners();
  }

  bool repeat() {
    return _checkBox[7];
  }

  bool sunday() {
    return _checkBox[6];
  }

  bool monday() {
    return _checkBox[0];
  }

  bool tuesday() {
    return _checkBox[1];
  }

  bool wednesday() {
    return _checkBox[2];
  }

  bool thursday() {
    return _checkBox[3];
  }

  bool friday() {
    return _checkBox[4];
  }

  bool saturday() {
    return _checkBox[5];
  }
}
