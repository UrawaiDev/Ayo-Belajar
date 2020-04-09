import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:math_quiz/styles/layout.dart';

class CheckAnswerPage extends StatelessWidget {
  final List<List<String>> summaryList;

  CheckAnswerPage({this.summaryList});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: Colors.blueGrey,
        child: Icon(
          Icons.arrow_back,
          size: 30,
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 10),
              child: Text(
                'Ringkasan Jawaban :',
                style: TextStyle(
                    color: Colors.green[300],
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: SizeConfig.screenHeight * 0.88,
              color: Colors.white,
              child: Container(
                child: ListView.builder(
                  itemCount: summaryList.length,
                  itemBuilder: (context, index) {
                    int lenQuestionChar =
                        summaryList[index][0].toString().length;

                    return Card(
                      elevation: 10,
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        title: Row(
                          children: <Widget>[
                            CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.blueAccent,
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                )),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      StringUtils.capitalize(
                                          summaryList[index][0]),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: (lenQuestionChar > 17)
                                              ? 16
                                              : 20)),
                                  SizedBox(height: 8),
                                  Container(
                                    width: SizeConfig.screenWidth * 0.65,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color(0xFFdcf8c6),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      child: Text(
                                        'Jawaban Benar : ' +
                                            StringUtils.capitalize(
                                                summaryList[index][1]
                                                    .toString()),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Color(0xFF5cd80d)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  (summaryList[index][1] !=
                                          summaryList[index][2])
                                      ? Container(
                                          width: SizeConfig.screenWidth * 0.65,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Color(0xFFffedec),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            child: Text(
                                              'Jawaban Kamu : ' +
                                                  StringUtils.capitalize(
                                                      summaryList[index][2]
                                                          .toString()),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Color(0xFFa85d45)),
                                            ),
                                          ),
                                        )
                                      : Text(''),
                                  SizedBox(height: 8),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            (summaryList[index][1].toUpperCase() ==
                                    summaryList[index][2].toUpperCase())
                                ? CircleAvatar(
                                    backgroundColor: Colors.green,
                                    child: Icon(
                                      FontAwesomeIcons.check,
                                      color: Colors.white,
                                      // size: 27,
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.red,
                                    child: Icon(
                                      FontAwesomeIcons.times,
                                      color: Colors.white,
                                      // size: 27,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
