import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:math_quiz/models/questionsModel.dart';
import 'package:math_quiz/models/user.dart';
import 'package:math_quiz/pages/admin/add_question_image.dart';
import 'package:math_quiz/pages/admin/questions_list.dart';
import 'package:math_quiz/styles/checkDesc.dart';
import 'package:math_quiz/styles/textStyles.dart';
import 'package:provider/provider.dart';

import 'add_questions.dart';

class SearchQuestion extends SearchDelegate<Questions> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        // close(context, null);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => QuestionListPage()));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Widget buildSuggestions(BuildContext context) {
    return Container(
      child: Text(query),
    );
  }

  @override
  // Widget buildResults(BuildContext context) {
  Widget buildSuggestions(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    List<Questions> questions = [];

    Iterable<Questions> _searchResults;

    Hive.openBox('Questions');
    var myBox = Hive.box(user.uid);

    myBox.values.forEach((data) {
      var _myQuestion = data as Questions;

      questions.add(Questions(
        id: _myQuestion.id,
        question: _myQuestion.question,
        correctAnswer: _myQuestion.correctAnswer,
        option2: _myQuestion.option2,
        option3: _myQuestion.option3,
        option4: _myQuestion.option4,
        level: _myQuestion.level,
        categoryId: _myQuestion.categoryId,
        photoUrl: _myQuestion.photoUrl,
      ));
    });

    //Filtering Search by Query

    _searchResults = questions.where((result) {
      return result.question.contains(query.toUpperCase());
    });

    return ListView.builder(
        itemCount: query.isEmpty ? 0 : _searchResults.length,
        itemBuilder: (context, index) {
          var data = _searchResults.elementAt(index);

          return ListTile(
            leading: data.photoUrl == null
                ? Icon(Icons.question_answer)
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FadeInImage(
                      placeholder: AssetImage('assets/images/placeholder.gif'),
                      image: FileImage(File(data.photoUrl)),
                    ),
                  ),
            title: RichText(
              text: TextSpan(
                children: highlightOccurrences(
                    _searchResults.elementAt(index).question, query),
                style: TextStyle(color: Colors.grey),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      if (data.photoUrl == null)
                        return AddQuestionPage(
                          true,
                          data.id,
                          data.question,
                          data.correctAnswer,
                          data.option2,
                          data.option3,
                          data.option4,
                          data.level,
                          data.categoryId,
                        );
                      else
                        return AddQuestionImagePage(
                          true,
                          data.id,
                          data.question,
                          data.correctAnswer,
                          data.option2,
                          data.option3,
                          data.option4,
                          data.level,
                          data.categoryId,
                          data.photoUrl,
                        );
                    }));
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    Hive.openBox('Questions');

                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Konfirmasi Hapus Soal'),
                              content: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.delete_forever,
                                    color: Colors.red[300],
                                    size: 30,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                        StringUtils.capitalize(data.question)),
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Tidak'),
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    'Ya',
                                  ),
                                  onPressed: () async {
                                    Box<dynamic> questionsBox =
                                        Hive.box(user.uid);

                                    try {
                                      if (data.categoryId == 3) {
                                        File imageFile = File(data.photoUrl);
                                        var fileExist =
                                            await imageFile.exists();
                                        if (fileExist) await imageFile.delete();
                                      }

                                      //delete item from DB
                                      questionsBox.delete(data.id);
                                      Navigator.pop(context, false);
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => WillPopScope(
                                          onWillPop: () => Future.value(false),
                                          child: AlertDialog(
                                            title: Text('Sukses'),
                                            content: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                  size: 30,
                                                ),
                                                SizedBox(width: 20),
                                                Expanded(
                                                  child: Text(
                                                      'Pertanyaan berhasil di Hapus.'),
                                                ),
                                              ],
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('OK'),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                  },
                                )
                              ],
                            ));
                  },
                ),
              ],
            ),
            onTap: () {
              print(_searchResults.elementAt(index).id.toString() +
                  ' ' +
                  _searchResults.elementAt(index).question);

              showModalBottomSheet(
                  context: context,
                  builder: (_) => Container(
                        color: Color(0xFF737373),
                        // height: MediaQuery.of(context).size.height * 0.6,
                        child:
                            _buildDetailView(_searchResults.elementAt(index)),
                      ));
            },
          );
        });
  }

  Widget _buildDetailView(Questions _questions) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Card(
            margin: EdgeInsets.symmetric(
                // vertical: 10,
                // horizontal: 8,
                ),
            // elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Text(
                        'Pertanyaan :',
                        style: playerStyle,
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              width: 1.5,
                              color: Colors.blueAccent,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 200,
                            child: Text(
                                StringUtils.capitalize(
                                    _questions.question.toString()),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // SECTION IMAGE & OPTION
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: GestureDetector(
                        onTap: () => (_questions.id),
                        child: (_questions.photoUrl != null)
                            ? Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: FadeInImage(
                                  placeholder: AssetImage(
                                      'assets/images/placeholder.gif'),
                                  image: FileImage(File(_questions.photoUrl)),
                                ),
                              )
                            : Container(),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: _answerList(_questions),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: <Widget>[],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 15),
                      Container(
                        width: 250,
                        // color: Colors.yellow,
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Level',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '             : ' +
                                  CheckDescription().cekLevel(_questions.level),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          Text(
                            'Kategori',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '       : ' +
                                CheckDescription()
                                    .cekCategory(_questions.categoryId),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  Column _answerList(_questions) {
    Widget _buildOptionCard(
        {String title, String optionValue, Color bodyColor, Color textColor}) {
      return Container(
        width: double.infinity,
        // height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // color: Color(0xFFdcf8c6),
          color: bodyColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: textColor,
                        )),
                    Text(':',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: textColor,
                        ))
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(StringUtils.capitalize(optionValue),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      // color: Color(0xFF5cd80d),
                      color: textColor,
                    )),
              )
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildOptionCard(
          title: 'Option 1',
          optionValue: _questions.correctAnswer.toString(),
          bodyColor: Color(0xFFdcf8c6),
          textColor: Color(0xFF5cd80d),
        ),
        SizedBox(height: 8),
        _buildOptionCard(
          title: 'Option 2',
          optionValue: _questions.option2.toString(),
          bodyColor: Color(0xFFffedec),
          textColor: Color(0xFFa85d45),
        ),
        SizedBox(height: 8),
        _buildOptionCard(
          title: 'Option 3',
          optionValue: _questions.option3.toString(),
          bodyColor: Color(0xFFffedec),
          textColor: Color(0xFFa85d45),
        ),
        SizedBox(height: 8),
        _buildOptionCard(
          title: 'Option 4',
          optionValue: _questions.option4.toString(),
          bodyColor: Color(0xFFffedec),
          textColor: Color(0xFFa85d45),
        ),
      ],
    );
  }

  List<TextSpan> highlightOccurrences(String source, String query) {
    if (query == null ||
        query.isEmpty ||
        !source.toLowerCase().contains(query.toLowerCase())) {
      return [TextSpan(text: source)];
    }
    final matches = query.toLowerCase().allMatches(source.toLowerCase());

    int lastMatchEnd = 0;

    final List<TextSpan> children = [];
    for (var i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);

      if (match.start != lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start),
        ));
      }

      children.add(TextSpan(
        text: source.substring(match.start, match.end),
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ));

      if (i == matches.length - 1 && match.end != source.length) {
        children.add(TextSpan(
          text: source.substring(match.end, source.length),
        ));
      }

      lastMatchEnd = match.end;
    }
    return children;
  }
}
