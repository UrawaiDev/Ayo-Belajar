import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Answer with ChangeNotifier {
  var _answer;
  bool _isTrue = false;
  bool _isWrong = false;
  bool _showResultPage = false;

  int _indexQuestion = 0;
  int _buttonIndex = 0;
  int _totalCorrectAnswer = 0;
  int _lifeCount = 3;

  get answer => _answer;
  get isTrue => _isTrue;
  get isWrong => _isWrong;
  get showResultPage => _showResultPage;

  get indexQuestion => _indexQuestion;
  get buttonIndex => _buttonIndex;
  get lifeCount => _lifeCount;

  get totalCorrectAnswer => _totalCorrectAnswer;

  set lifeCount(var newValue) {
    _lifeCount = newValue;
    notifyListeners();
  }

  set answer(var newValue) {
    _answer = newValue;
    notifyListeners();
  }

  set isTrue(bool newValue) {
    _isTrue = newValue;
    notifyListeners();
  }

  set isWrong(bool newValue) {
    _isWrong = newValue;
    notifyListeners();
  }

  set showResultPage(bool newValue) {
    _showResultPage = newValue;
    notifyListeners();
  }

  set indexQuestion(int newValue) {
    _indexQuestion = newValue;
    notifyListeners();
  }

  set buttonIndex(int newValue) {
    _buttonIndex = newValue;
    notifyListeners();
  }

  set totalCorrectAnswer(int newValue) {
    _totalCorrectAnswer = newValue;
    notifyListeners();
  }

  void updateScore(bool value) {
    if (value == true) {
      totalCorrectAnswer++;
      // buttonIndex++;
    }
  }

  void nextQuestion(int lengthQuestion) {
    if (indexQuestion < lengthQuestion) {
      indexQuestion++;

      isTrue = false;
      isWrong = false;
    } else
      showResultPage = true;
  }

  void reset() {
    isTrue = false;
    isWrong = false;
    showResultPage = false;

    indexQuestion = 0;
    totalCorrectAnswer = 0;
    lifeCount = 3;
  }
}
