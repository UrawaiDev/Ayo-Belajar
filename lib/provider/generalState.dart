import 'dart:io';

import 'package:flutter/foundation.dart';

class GeneralState extends ChangeNotifier {
  bool _isLoading = false;
  int _pressedIndexButton;
  File _image;
  int _levelId = 0;
  int _categoryId = 0;
  int _totalQuestions = 0;

  bool get isLoading => _isLoading;
  int get pressedIndexButton => _pressedIndexButton;
  File get imageFile => _image;
  int get levelId => _levelId;
  int get categoryId => _categoryId;
  int get totalQuestions => _totalQuestions;

  set isLoading(bool newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  set pressedIndexButton(int newValue) {
    _pressedIndexButton = newValue;
    notifyListeners();
  }

  set imageFile(File newValue) {
    _image = newValue;
    notifyListeners();
  }

  set levelId(int newValue) {
    _levelId = newValue;
    notifyListeners();
  }

  set categoryId(int newValue) {
    _categoryId = newValue;
    notifyListeners();
  }

  set totalQuestions(int newValue) {
    _totalQuestions = newValue;
    notifyListeners();
  }
}
