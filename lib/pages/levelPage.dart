import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:math_quiz/models/questionsModel.dart';
import 'package:math_quiz/models/user.dart';
import 'package:math_quiz/pages/image_questions.dart';

import 'package:math_quiz/pages/local_question.dart';

import 'package:math_quiz/pages/resultPage.dart';

import 'package:math_quiz/provider/Timer.dart';
import 'package:math_quiz/provider/answer.dart';
import 'package:math_quiz/provider/generalState.dart';
import 'package:math_quiz/styles/checkDesc.dart';
import 'package:math_quiz/styles/layout.dart';

import 'package:math_quiz/styles/textStyles.dart';
import 'package:provider/provider.dart';

class LevelPage extends StatefulWidget {
  final int categoryId;
  final String uid;

  LevelPage({this.categoryId, this.uid});

  @override
  _LevelPageState createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  int LEVEL_INT_TIMER;
  int LEVEL_ADV_TIMER;
  SizeConfig screenConfig = SizeConfig();
  int _easyLength;
  int _mediumLength;
  int _hardLength;
  List<int> timerOnly = [];
  Timer _myTimer;
  final _document = Firestore.instance.collection('Users');

  List maxEasy = [];
  List maxMedium = [];
  List maxHard = [];

  int levelId;
  int pressedIndexButton;

  List<String> levelName = ['Mudah', 'Menengah', 'Sulit'];
  List<bool> isSelected = [false, false, false];

  static const int EASY = 1;
  static const int INTERMEDIATE = 2;
  static const int ADVANCED = 3;

  bool _picturePage = false;
  bool _isLocalDB = false;

  DocumentSnapshot dataFirebase;

  @override
  void initState() {
    super.initState();

    Hive.openBox('Questions');
    // final _user = Provider.of<User>(context);
  }

  @override
  void dispose() {
    if (_myTimer != null) _myTimer.cancel();

    super.dispose();
  }

  _getBoxQuestionLength() {
    final user = Provider.of<User>(context, listen: false);
    //make sure to clear list before we add to get exact length of available questions.
    maxEasy.clear();
    maxMedium.clear();
    maxHard.clear();

    var _myBox = Hive.box(user.uid);
    _myBox.values.forEach((data) {
      var x = data as Questions;
      if (x.level == 1 && x.categoryId == widget.categoryId)
        maxEasy.add(x.level);
      else if (x.level == 2 && x.categoryId == widget.categoryId)
        maxMedium.add(x.level);
      else if (x.level == 3 && x.categoryId == widget.categoryId)
        maxHard.add(x.level);
    });
  }

  int getQuestionsLength(int levelId) {
    switch (levelId) {
      case 1:
        {
          if (_easyLength == null)
            return 1;
          else
            return _easyLength < maxEasy.length ? _easyLength : maxEasy.length;
        }

        break;
      case 2:
        {
          if (_mediumLength == null)
            return 1;
          else
            return _mediumLength < maxMedium.length
                ? _mediumLength
                : maxMedium.length;
        }

        break;
      case 3:
        {
          if (_hardLength == null)
            return 1;
          else
            return _hardLength < maxHard.length ? _hardLength : maxHard.length;
        }
        break;
      default:
        return 5; // default 5 questions
    }
  }

  void _getDataFromFirebase(User user, GeneralState appState) async {
    var data = await _document.document(user.uid).get();

    data.reference.get().whenComplete(() {
      LEVEL_INT_TIMER = data['mediumTimeLimit'];
      LEVEL_ADV_TIMER = data['hardTimeLimit'];

      _easyLength = data['easyMaxQuestions'];
      _mediumLength = data['mediumMaxQuestions'];
      _hardLength = data['hardMaxQuestions'];

      dataFirebase = data;
      appState.isLoading = false;

      print('completed loaded from firebase.');
    });
  }

  Widget _toggleButton() {
    return ToggleButtons(
      disabledBorderColor: Colors.transparent,
      selectedBorderColor: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      // borderColor: Colors.transparent,
      selectedColor: Color(0xFFd5f7fd),
      textStyle: TextStyle(
          fontSize: 18,
          // color: Colors.blue[400],
          fontWeight: FontWeight.bold,
          fontFamily: 'Quicksand'),
      // fillColor: Color(0xFFd5f7fd),
      focusColor: Color(0xFFd5f7fd),
      borderWidth: 10.0,
      isSelected: isSelected,

      children: <Widget>[
        AnimatedContainer(
          height: SizeConfig.screenWidth * 0.3,
          width: SizeConfig.screenWidth * 0.3,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueGrey,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.free_breakfast,
                  size: 45,
                ),
                SizedBox(height: 5),
                Text(
                  'Mudah',
                )
              ],
            ),
          ),
        ),
        AnimatedContainer(
          height: SizeConfig.screenWidth * 0.3,
          width: SizeConfig.screenWidth * 0.3,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueGrey,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.desktop_mac,
                  size: 45,
                ),
                SizedBox(height: 5),
                Text('Menengah')
              ],
            ),
          ),
        ),
        AnimatedContainer(
          height: SizeConfig.screenWidth * 0.3,
          width: SizeConfig.screenWidth * 0.3,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueGrey,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.directions_bike,
                  size: 45,
                ),
                SizedBox(height: 5),
                Text('Sulit')
              ],
            ),
          ),
        ),
      ],
      onPressed: (int index) {
        final _user = Provider.of<User>(context);
        final appState = Provider.of<GeneralState>(context);

        setState(() {
          for (int indexBtn = 0; indexBtn < isSelected.length; indexBtn++) {
            if (indexBtn == index) {
              isSelected[indexBtn] = !isSelected[indexBtn];
            } else {
              isSelected[indexBtn] = false;
            }
          }
          pressedIndexButton = index + 1;
        });

        if (!isSelected.every((element) => element == false)) {
          appState.isLoading = true;
          _getDataFromFirebase(_user, appState);
        }

        _getBoxQuestionLength();
      },
    );
  }

  _showQuestionPage(
      {int categoryId, int level, int levelTimer, bool isPicturePage = false}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      if (isPicturePage) {
        levelId = level;
        return LocalQuestionWithImagePage(
          timer: _myTimer,
          isShowTimer: (level > 1) ? true : false,
          level: level,
          // levelTimer: levelTimer != null
          //     ? levelTimer
          //     : level == 2 ? LEVEL_INT_TIMER : LEVEL_ADV_TIMER,
          levelTimer: levelTimer,
          category: categoryId,
          questionLength: getQuestionsLength(level),
          dataFirebase: dataFirebase,
        );
      } else {
        levelId = level;
        return LocalQuestionPage(
          timer: _myTimer,
          isShowTimer: (level > 1) ? true : false,
          level: level,
          // levelTimer: levelTimer != null
          //     ? levelTimer
          //     : level == 2 ? LEVEL_INT_TIMER : LEVEL_ADV_TIMER,
          levelTimer: levelTimer,
          category: categoryId,
          questionLength: getQuestionsLength(level),
          dataFirebase: dataFirebase,
        );
      }
    }));
  }

  void _executePage(BuildContext context, int selectedLevel) {
    final timerState = Provider.of<TimerApp>(context);
    final answerProvider = Provider.of<Answer>(context);

    if (selectedLevel == 1) {
      _showQuestionPage(
        categoryId: widget.categoryId,
        level: EASY,
        isPicturePage: _picturePage,
      );
    } else {
      //initial timerSate
      int _initalTimerValue;
      selectedLevel == 2
          ? _initalTimerValue = LEVEL_INT_TIMER
          : _initalTimerValue = LEVEL_ADV_TIMER;

      timerState.value = _initalTimerValue;

      print('initial timer value : ${timerState.value}');

      _myTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
        int maxTimerQuestions = getQuestionsLength(selectedLevel);

        //manually set to 100 to force stop
        if (timerState.value == 100) {
          //set to default value
          timer.cancel();
          print('timer from level page is cancelled');
        }

        if (timerState.value == 0) {
          if (answerProvider.indexQuestion + 1 >= maxTimerQuestions) {
            print('pertayaan habis...Auto show Result Page');

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ResultPage(
                        questionLength: maxTimerQuestions,
                        page: LevelPage(
                          categoryId: widget.categoryId,
                        ),
                        result: answerProvider.totalCorrectAnswer)));

            timer.cancel();
          } else {
            answerProvider.nextQuestion(maxTimerQuestions);
            timerState.value = _initalTimerValue;
          }
        } else {
          timerState.value -= 1;
          print('value :' + timerState.value.toString());
        }
      });

      print('sebelum passing ke Page : $_initalTimerValue');

      _showQuestionPage(
        categoryId: widget.categoryId,
        level: selectedLevel,
        levelTimer: _initalTimerValue,
        isPicturePage: _picturePage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    screenConfig.init(context);

    // final _user = Provider.of<User>(context);

    //QUESTION PAGE WITH IMAGE
    switch (widget.categoryId) {
      case 3:
        _picturePage = true;
        break;
      case 4:
        _isLocalDB = true;
        break;
      default:
        _picturePage = false;
        break;
    }

    return Scaffold(
      backgroundColor: Color(0xFF2c163a),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              // color: Colors.yellow,
              margin: EdgeInsets.only(left: 20),
              alignment: Alignment.center,
              height: SizeConfig.screenHeight * 0.1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'KATEGORI : ',
                    style: scoreStyle,
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Text(
                        CheckDescription()
                            .cekCategory(widget.categoryId)
                            .toUpperCase(),
                        style: scoreStyle),
                  ),
                ],
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50),
              Container(
                // height: SizeConfig.screenHeight * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          'Pilih tingkat kesulitan :',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 40),
                        _toggleButton(),
                        SizedBox(
                          height: 50,
                        ),
                        Consumer<GeneralState>(
                          builder: (context, appState, _) => RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(width: 1.5, color: Colors.white),
                            ),
                            child: Container(
                              height: 55,
                              width: SizeConfig.screenWidth * 0.6,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: appState.isLoading
                                    ? CircularProgressIndicator(
                                        // backgroundColor: Colors.green,
                                        )
                                    : Text('Mulai',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        )),
                              ),
                            ),
                            color:
                                isSelected.contains(true) && !appState.isLoading
                                    ? Color(0xFF1d68df)
                                    : Colors.grey,
                            onPressed: () {
                              if (isSelected.contains(true) &&
                                  !appState.isLoading) {
                                print('OK Execute');
                                _executePage(context, pressedIndexButton);
                              } else
                                print('no level choose');
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
