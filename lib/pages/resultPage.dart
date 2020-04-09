import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:math_quiz/pages/checkAnswer.dart';

import 'package:math_quiz/pages/services/gateKepeer.dart';

import 'package:math_quiz/provider/answer.dart';
import 'package:math_quiz/styles/layout.dart';

import 'package:provider/provider.dart';

class ResultPage extends StatelessWidget {
  final int result;
  final Widget page;
  final int questionLength;
  final List<List<String>> summaryList;

  ResultPage({this.result, this.page, this.questionLength, this.summaryList});

  @override
  Widget build(BuildContext context) {
    final answerProvider = Provider.of<Answer>(context);

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Color(0xFF9149c0).withOpacity(0.3),
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    width: SizeConfig.screenWidth * 0.8,
                    height: SizeConfig.screenHeight * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      // gradient: LinearGradient(
                      //     colors: [Color(0xFF81c784), Color(0xFF00c740)]),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        (result > (questionLength / 2))
                            ? Text(
                                'Wow Hebat, Selamat.',
                                style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrangeAccent),
                              )
                            : Text('Upss! Ayo dicoba lagi.',
                                style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrangeAccent)),
                        SizedBox(height: 20),
                        Container(
                          width: SizeConfig.screenWidth * 0.5,
                          height: 160,
                          child: FlareActor(
                            'assets/flare/teddy_animation.flr',
                            fit: BoxFit.cover,
                            animation: (result > (questionLength / 2))
                                ? 'success'
                                : 'fail',
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                CircleAvatar(
                                    backgroundColor: Colors.green,
                                    child: Icon(
                                      FontAwesomeIcons.check,
                                      color: Colors.white,
                                      // size: 27,
                                    )),
                                SizedBox(width: 20),
                                Text(
                                  result.toString(),
                                  style: TextStyle(
                                      color: Colors.green[300],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )
                              ],
                            ),
                            SizedBox(width: 30),
                            Row(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                  child: Icon(
                                    FontAwesomeIcons.times,
                                    color: Colors.white,
                                    // size: 27,
                                  ),
                                ),
                                SizedBox(width: 20),
                                Text(
                                  (questionLength - result).toString(),
                                  style: TextStyle(
                                      color: Colors.green[300],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )
                              ],
                            ),
                          ],
                        ),
                        // Text(
                        //   'Jawaban benar ' +
                        //       result.toString() +
                        //       ' dari ' +
                        //       questionLength.toString() +
                        //       ' Soal',
                        //   // style: scoreStyle,
                        //   style: TextStyle(
                        //       color: Colors.green[300],
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 20),
                        // ),
                        SizedBox(height: 30),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CheckAnswerPage(
                                          summaryList: summaryList,
                                        )));
                          },
                          child: (summaryList != null)
                              ? Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Container(
                                    height: SizeConfig.blockHeight * 0.5,
                                    width: SizeConfig.screenWidth * 0.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      gradient: LinearGradient(colors: [
                                        Color(0xFF0091ae),
                                        Color(0xFF00c1b3)
                                      ]),
                                    ),
                                    child: Center(
                                        child: Text(
                                      'Lihat Jawaban',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                  ),
                                )
                              : Text(''),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                InkWell(
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Container(
                      height: SizeConfig.blockHeight * 0.75,
                      width: SizeConfig.screenWidth * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(
                            colors: [Color(0xFF41aaf1), Color(0xFF1c77f1)]),
                      ),
                      child: Center(
                          child: Text(
                        'Main Lagi',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ),
                  ),
                  onTap: () {
                    answerProvider.reset();
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => page));
                  },
                ),
                SizedBox(height: 10),
                InkWell(
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Container(
                      height: SizeConfig.blockHeight * 0.75,
                      width: SizeConfig.screenWidth * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(
                            colors: [Color(0xFF41aaf1), Color(0xFF1c77f1)]),
                      ),
                      child: Center(
                          child: Text(
                        'Halaman Utama',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ),
                  ),
                  onTap: () {
                    answerProvider.reset();

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => GateKeeper()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
