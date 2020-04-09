import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:math_quiz/models/questionsModel.dart';
import 'package:math_quiz/models/user.dart';
import 'package:math_quiz/pages/levelPage.dart';
import 'package:math_quiz/pages/resultPage.dart';
import 'package:math_quiz/pages/services/scroll_behaviour.dart';

import 'package:math_quiz/provider/Timer.dart';
import 'package:math_quiz/provider/answer.dart';
import 'package:math_quiz/styles/checkDesc.dart';
import 'package:math_quiz/styles/layout.dart';
import 'package:math_quiz/styles/textStyles.dart';
import 'package:math_quiz/widgets/costumProgressBar.dart';
//import 'package:basic_utils/basic_utils.dart';

import 'package:provider/provider.dart';
import 'package:volume/volume.dart';

class LocalQuestionPage extends StatefulWidget {
  final bool isShowTimer;
  final int questionLength;
  final int level;
  final int levelTimer;
  final int category;
  final Widget child;
  final Timer timer;
  final DocumentSnapshot dataFirebase;

  LocalQuestionPage({
    this.level,
    this.levelTimer,
    this.isShowTimer,
    this.questionLength,
    this.category,
    this.child,
    this.timer,
    this.dataFirebase,
  });

  @override
  _LocalQuestionPageState createState() => _LocalQuestionPageState();
}

class _LocalQuestionPageState extends State<LocalQuestionPage> {
  List<List<String>> summaryList = [];
  List<List<dynamic>> _filteredQuestion;
  List<List<dynamic>> _allQuestions = [];

  int currVolumeSystem;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    if (widget.timer != null) {
      widget.timer.cancel();
    }

    super.dispose();
  }

  Future<void> initPlatformState() async {
    await Volume.controlVolume(AudioManager.STREAM_SYSTEM);
  }

  Future<bool> _isBackButtonPressed() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Konfirmasi'),
              content: Row(
                children: <Widget>[
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue[300],
                    size: 30,
                  ),
                  SizedBox(width: 8),
                  Text('Keluar dari sesi pertanyaan?'),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                    child: Text(
                      'Tidak',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pop(context, false);
                    }),
                Consumer<TimerApp>(
                  builder: (context, timerState, _) => Consumer<Answer>(
                    builder: (context, answerProvider, _) => FlatButton(
                        child: Text(
                          'Ya',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          answerProvider.reset();
                          timerState.value = 100; // stop timer

                          Navigator.pop(context, true);
                        }),
                  ),
                ),
              ],
            ));
  }

  _showResultPage(Answer provider, int questionLength, Widget showPage,
      List<List<String>> list) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultPage(
                  result: provider.totalCorrectAnswer,
                  questionLength: questionLength,
                  page: showPage,
                  summaryList: list,
                )));
  }

  Widget _generateRandomAnswer(
      {Answer answerProvider,
      Box<dynamic> box,
      int questionLength,
      List<List<dynamic>> randomList,
      int intialTimerValue}) {
    questionLength = questionLength - 1;
    bool isAnswerTrue = false;
    AudioPlayer audioPlayer = AudioPlayer();
    AudioCache audioCache = AudioCache(fixedPlayer: audioPlayer);
    double buttonHeight = SizeConfig.blockHeight * 0.65;

    _setColor(int indexButton, Answer answerProvider) {
      if (indexButton == answerProvider.buttonIndex && answerProvider.isTrue) {
        return Colors.green;
      } else if (answerProvider.isWrong &&
          indexButton == answerProvider.buttonIndex) {
        return Colors.red;
      } else
        return Color(0xFF118ef1);
    }

    //ANSWER BUTTON WIDGET
    return Container(
      width: SizeConfig.screenWidth * 0.85,
      height: SizeConfig.screenHeight * 0.45,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ScrollConfiguration(
          behavior: MyScrollBehavior(),
          child: ListView.builder(
            itemCount: 4, //count of Options
            itemBuilder: (context, indexButton) {
              return Consumer<TimerApp>(
                builder: (context, timerState, _) => GestureDetector(
                  child: Card(
                    margin: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)),
                    elevation: 7,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _setColor(indexButton, answerProvider),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      alignment: Alignment.center,
                      height: buttonHeight,
                      child: Text(
                        randomList[answerProvider.indexQuestion][indexButton]
                            .toString(),
                        style: answerSmallStyle,
                      ),
                    ),
                  ),
                  onTap: () async {
                    //check android System Audio
                    currVolumeSystem = await Volume.getVol;

                    if (randomList[answerProvider.indexQuestion][indexButton]
                            .toString()
                            .toUpperCase() ==
                        _filteredQuestion[answerProvider.indexQuestion][1]
                            .toString()
                            .toUpperCase()) {
                      if (currVolumeSystem != 0)
                        await audioCache.play('sounds/correct-answer.mp3');

                      isAnswerTrue = true;
                      answerProvider.isTrue = true;

                      answerProvider.buttonIndex = indexButton;
                    } else {
                      if (currVolumeSystem != 0)
                        await audioCache.play('sounds/incorrect-answer.mp3');

                      answerProvider.buttonIndex = indexButton;
                      answerProvider.isWrong = true;
                    }

                    //Delay to coloring button & update score to screen
                    Timer(Duration(milliseconds: 500), () {
                      summaryList.add([
                        // currentQuestion.question.toUpperCase(),
                        // currentQuestion.correctAnswer.toUpperCase(),
                        _filteredQuestion[answerProvider.indexQuestion][0]
                            .toString()
                            .toUpperCase(),
                        _filteredQuestion[answerProvider.indexQuestion][1]
                            .toString()
                            .toUpperCase(),

                        randomList[answerProvider.indexQuestion][indexButton]
                            .toString()
                            .toUpperCase(),
                      ]);

                      answerProvider.nextQuestion(questionLength);
                      answerProvider.updateScore(isAnswerTrue);
                      answerProvider.buttonIndex = null;

                      if (answerProvider.showResultPage &&
                          widget.isShowTimer == true) {
                        timerState.value = 100; //stop timer
                        _showResultPage(
                            answerProvider,
                            widget.questionLength,
                            LevelPage(
                              categoryId: widget.category,
                            ),
                            summaryList);
                      } else if (answerProvider.showResultPage &&
                          widget.isShowTimer == false) {
                        _showResultPage(
                            answerProvider,
                            widget.questionLength,
                            LevelPage(
                              categoryId: widget.category,
                            ),
                            summaryList);
                      }
                    });

                    //reset Timer Value
                    timerState.value = intialTimerValue;
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context, DocumentSnapshot dataSnapshot) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.15,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          // bottom: 15,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),

              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    )),
                child: FadeInImage.assetNetwork(
                  fadeInCurve: Curves.easeIn,
                  placeholder: 'assets/images/placeholder.gif',
                  image: dataSnapshot['photo_url'],
                  fit: BoxFit.cover,
                  height: 70,
                  width: 70,
                ),
              ),
              // backgroundColor: Colors.grey.withOpacity(0.3),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(dataSnapshot['username'],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(dataSnapshot['email'] ?? '',
                      style: TextStyle(
                        fontSize: 16,
                      )),
                ],
              ),
            ),
            Consumer<Answer>(
              builder: (context, answerProvider, _) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Points',
                    style: playerStyle,
                  ),
                  Text(
                    answerProvider.totalCorrectAnswer.toString(),
                    style: scoreStyle,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final user = Provider.of<User>(context, listen: false);

    List<List<dynamic>> randomOptionList;

    return SafeArea(
      child: WillPopScope(
          onWillPop: _isBackButtonPressed,
          child: Scaffold(
            body: FutureBuilder(
                //load list of questions
                future: Hive.openBox(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.data == null)
                    return Center(child: CircularProgressIndicator());

                  if (snapshot.hasError)
                    return Center(
                        child: Text(
                      'An Error has Occured..',
                      style: playerStyle,
                    ));

                  var questionsBox = Hive.box(user.uid);

                  questionsBox.values.forEach((data) {
                    var x = data as Questions;

                    _allQuestions.add([
                      x.question,
                      x.correctAnswer,
                      x.option1,
                      x.option2,
                      x.option3,
                      x.option4,
                      x.level,
                      x.categoryId
                    ]);
                  });

                  //shuffle all questions
                  _allQuestions.shuffle();

                  randomOptionList = [];
                  _filteredQuestion = [];

                  //RANDOM QUESTIONS

                  _allQuestions.forEach((data) {
                    if (data[6] == widget.level && data[7] == widget.category) {
                      _filteredQuestion.add([
                        data[0], //question
                        data[1], //correct answer
                      ]);

                      //option
                      randomOptionList.add([
                        data[2], // option1
                        data[3], //option2
                        data[4], // option3
                        data[5], // option4
                      ]);
                    }
                  });

                  for (int x = 0; x < randomOptionList.length; x++) {
                    randomOptionList[x].shuffle();
                    // print(randomOptionList[x]);
                  }

                  if (_filteredQuestion.length == 0)
                    return Consumer<TimerApp>(
                        builder: (context, timerState, _) {
                      //stop the timer
                      Future.delayed(
                          Duration(seconds: 2), () => timerState.value = 100);

                      return Container(
                        color: Colors.grey.withOpacity(0.3),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 60,
                            bottom: 40,
                          ),
                          child: Center(
                            child: Container(
                              // color: Colors.yellow,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        width: 200,
                                        height: 200,
                                        child: Image.asset(
                                            'assets/images/no_data.png'),
                                      ),
                                      SizedBox(height: 40),
                                      Text(
                                        'Upss!\nBelum ada soal untuk Level atau Kategori ini. Silahkan buat soal pada menu di Halaman Utama.',
                                        textAlign: TextAlign.left,
                                        style: playerStyle,
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Container(
                                        height: 40,
                                        width: 250,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            gradient: LinearGradient(colors: [
                                              Color(0xFF0c4135),
                                              Color(0xFF2a7f26)
                                            ]),
                                            color: Colors.yellowAccent),
                                        child: Center(
                                            child: Text(
                                          'Kembali',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.white),
                                        )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
                  else if (_filteredQuestion.length != 0)
                    return Column(
                      children: <Widget>[
                        _header(context, widget.dataFirebase),
                        Divider(
                          color: Colors.black,
                        ),
                        Consumer<TimerApp>(
                          builder: (context, timerState, _) => Consumer<Answer>(
                            builder: (context, answerProvider, _) => Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Level : ' +
                                          CheckDescription()
                                              .cekLevel(widget.level),
                                      style: playerStyle,
                                    ),
                                    (widget.isShowTimer)
                                        ? Text((timerState.value).toString(),
                                            style: playerStyle)
                                        : Text(''),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Soal Ke - ' +
                                            (answerProvider.indexQuestion + 1)
                                                .toString() +
                                            '/' +
                                            widget.questionLength
                                                .toString(), // limit number of questions
                                        style: playerStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        Consumer<TimerApp>(
                          builder: (context, timerState, _) =>
                              widget.isShowTimer
                                  ? CostumProgressBar(
                                      width: SizeConfig.screenWidth,
                                      currentValue: timerState.value,
                                      totalValue: widget.levelTimer,
                                    )
                                  : Container(),
                        ),
                        Consumer<Answer>(builder: (context, answerProvider, _) {
                          //check length charchter of question to set proper font size
                          int questionCharLen =
                              _filteredQuestion[answerProvider.indexQuestion][0]
                                  .length;

                          return Material(
                            elevation: 10,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              color: Colors.grey.withOpacity(0.4),
                              height: SizeConfig.screenHeight * 0.25,
                              child: Center(
                                  child: Text(
                                _filteredQuestion[answerProvider.indexQuestion]
                                    [0],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: (questionCharLen > 90)
                                        ? 18
                                        : (questionCharLen > 30) ? 24 : 30),
                              )),
                            ),
                          );
                        }),
                        SizedBox(height: 20),
                        Consumer<Answer>(
                            builder: (context, answerProvider, _) =>
                                _generateRandomAnswer(
                                    answerProvider: answerProvider,
                                    questionLength: widget.questionLength,
                                    box: questionsBox,
                                    randomList: randomOptionList,
                                    intialTimerValue: widget.levelTimer)),
                      ],
                    );
                }),
          )),
    );
  }
}
