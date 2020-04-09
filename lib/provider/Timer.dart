import 'package:flutter/foundation.dart';

class TimerApp with ChangeNotifier {
  int _value = 5;
  int _flashTimer = 5;
  bool _stopTimer = false;

  int get value => _value;
  int get flashTimer => _flashTimer;
  bool get stopTimer => _stopTimer;

  set value(int newValue) {
    _value = newValue;
    notifyListeners();
  }

  set flashTimer(int newValue) {
    _flashTimer = newValue;
    notifyListeners();
  }

  set stopTimer(bool newValue) {
    _stopTimer = newValue;
    notifyListeners();
  }
}
