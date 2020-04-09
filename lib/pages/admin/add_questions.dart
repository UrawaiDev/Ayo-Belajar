import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:math_quiz/models/questionsModel.dart';
import 'package:math_quiz/models/user.dart';
import 'package:math_quiz/pages/mainMenu.dart';
import 'package:math_quiz/styles/textStyles.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddQuestionPage extends StatefulWidget {
  final bool isEdit;
  final String uuid;
  final String question;
  final String correctAnswer;
  final String option2;
  final String option3;
  final String option4;
  final int level;
  final int categoryId;

  AddQuestionPage(
      [this.isEdit = false,
      this.uuid,
      this.question,
      this.correctAnswer,
      this.option2,
      this.option3,
      this.option4,
      this.level,
      this.categoryId]);

  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final TextEditingController questionTextCtrl = TextEditingController();
  final TextEditingController correctAnswerTextCtrl = TextEditingController();
  final TextEditingController option1TextCtrl = TextEditingController();
  final TextEditingController option2TextCtrl = TextEditingController();
  final TextEditingController option3TextCtrl = TextEditingController();
  final TextEditingController option4TextCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode _questionFocusNode;
  Uuid uuid = Uuid();

  int _level;
  int _category;

  TextStyle _textStyle() {
    return TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w400,
    );
  }

  InputDecoration textFieldStyle(String hintText) {
    return InputDecoration(
        // fillColor: Colors.grey[200],
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 18,

          // color: Colors.white,
        ),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Color(0xFF38b5ed),
              width: 2,
            )),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFa8a8a8),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ));
  }

  List<DropdownMenuItem<int>> _tingakKesulitan = [
    DropdownMenuItem(
      value: 1,
      child: Row(
        children: <Widget>[
          Icon(Icons.free_breakfast, color: Color(0xFF00b17e)),
          SizedBox(width: 20),
          Text('Mudah'),
        ],
      ),
    ),
    DropdownMenuItem(
      value: 2,
      child: Row(
        children: <Widget>[
          Icon(Icons.desktop_mac, color: Color(0xFFb3bb1e)),
          SizedBox(width: 20),
          Text('Menengah'),
        ],
      ),
    ),
    DropdownMenuItem(
      value: 3,
      child: Row(
        children: <Widget>[
          Icon(Icons.directions_bike, color: Color(0xFFbb5243)),
          SizedBox(width: 20),
          Text('Sulit'),
        ],
      ),
    ),
  ];

  List<DropdownMenuItem<int>> _kategori = [
    DropdownMenuItem(
      value: 1,
      child: Row(
        children: <Widget>[
          Icon(FontAwesomeIcons.calculator, color: Color(0xFF814374)),
          SizedBox(width: 20),
          Text('Matematika'),
        ],
      ),
    ),
    DropdownMenuItem(
      value: 2,
      child: Row(
        children: <Widget>[
          Icon(FontAwesomeIcons.bookOpen, color: Color(0xFF51A39D)),
          SizedBox(width: 20),
          Text('Membaca'),
        ],
      ),
    ),
    // DropdownMenuItem(
    //   value: 3,
    //   child: Text('Tebak Gambar'),
    // ),
    DropdownMenuItem(
      value: 4,
      child: Row(
        children: <Widget>[
          Icon(FontAwesomeIcons.layerGroup, color: Color(0xFF714374)),
          SizedBox(width: 20),
          Text('Pengetahuan Umum'),
        ],
      ),
    ),
    DropdownMenuItem(
      value: 5,
      child: Row(
        children: <Widget>[
          Icon(FontAwesomeIcons.language, color: Color(0xFF49e585)),
          SizedBox(width: 20),
          Text('Bahasa Inggris'),
        ],
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    Hive.openBox('Questions');
    _questionFocusNode = FocusNode();

    //assigned intialvalue when edit process
    if (widget.question != null) questionTextCtrl.text = widget.question;
    if (widget.correctAnswer != null)
      correctAnswerTextCtrl.text = widget.correctAnswer;
    if (widget.option2 != null) option2TextCtrl.text = widget.option2;
    if (widget.option3 != null) option3TextCtrl.text = widget.option3;
    if (widget.option4 != null) option4TextCtrl.text = widget.option4;
    if (widget.level != null) _level = widget.level;
    if (widget.categoryId != null) _category = widget.categoryId;
    // print(widget.categoryId);
  }

  @override
  void dispose() {
    super.dispose();
    questionTextCtrl.dispose();
    correctAnswerTextCtrl.dispose();
    option1TextCtrl.dispose();
    option2TextCtrl.dispose();
    option3TextCtrl.dispose();
    option4TextCtrl.dispose();
    _questionFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final user = Provider.of<User>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MainMenu(
                      email: user.email,
                      userId: user.uid,
                    )));
      },
      child: Container(
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.cover)),
        child: Scaffold(
            backgroundColor: Color(0xFFf8f9fa),
            // backgroundColor: Colors.transparent,
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton.extended(
                  // heroTag: 'btn1',
                  backgroundColor: Color(0xFF38b5ed),
                  elevation: 5.0,
                  icon: Icon(Icons.save),
                  label: widget.isEdit
                      ? Text('Update',
                          style: TextStyle(fontWeight: FontWeight.bold))
                      : Text(
                          'Simpan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                  onPressed: () {
                    var questionBox = Hive.box(user.uid);
                    if (_formKey.currentState.validate()) {
                      if (!widget.isEdit) {
                        String _uuid = uuid.v1();
                        var question = Questions(
                          question: questionTextCtrl.text,
                          correctAnswer: correctAnswerTextCtrl.text,
                          option1: correctAnswerTextCtrl.text,
                          option2: option2TextCtrl.text,
                          option3: option3TextCtrl.text,
                          option4: option4TextCtrl.text,
                          level: _level,
                          categoryId: _category,
                          id: _uuid,
                        );

                        questionBox.put(_uuid, question);

                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          duration: Duration(seconds: 2),
                          content: Row(
                            children: <Widget>[
                              Icon(Icons.save, color: Colors.white),
                              SizedBox(width: 20),
                              Text('Pertanyaan sudah disimpan.',
                                  style: TextStyle(fontSize: 18)),
                            ],
                          ),
                        ));

                        //set cursor back to textbox question
                        // FocusScope.of(context).requestFocus(_questionFocusNode);
                      } else {
                        questionBox.put(
                            widget.uuid,
                            Questions(
                              question: questionTextCtrl.text,
                              correctAnswer: correctAnswerTextCtrl.text,
                              option1: correctAnswerTextCtrl.text,
                              option2: option2TextCtrl.text,
                              option3: option3TextCtrl.text,
                              option4: option4TextCtrl.text,
                              level: _level,
                              categoryId: _category,
                              id: widget.uuid,
                            ));

                        //SHOW Dialog When Update Completed
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => WillPopScope(
                                  onWillPop: () => Future.value(false),
                                  child: AlertDialog(
                                    title: Text('Information'),
                                    content: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 35,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                              'Pertanyaan sudah di Update.',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () => Navigator.push(
                                                  context, MaterialPageRoute(
                                                      builder: (context) {
                                                var user = Provider.of<User>(
                                                    context,
                                                    listen: false);

                                                return MainMenu(
                                                  userId: user.uid,
                                                  email: user.email,
                                                );
                                              })),
                                          child: Text(
                                            'OK',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ))
                                    ],
                                  ),
                                ));
                      }

                      //manual reset
                      questionTextCtrl.text = '';
                      correctAnswerTextCtrl.text = '';
                      option1TextCtrl.text = '';
                      option4TextCtrl.text = '';
                      option2TextCtrl.text = '';
                      option3TextCtrl.text = '';

                      //set cursor back to textbox question
                      FocusScope.of(context).requestFocus(_questionFocusNode);
                    }
                  },
                ),
                SizedBox(height: 10),
              ],
            ),
            key: _scaffoldKey,
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      widget.isEdit
                          ? Text(
                              'Update Pertanyaan :',
                              style: scoreStyle,
                            )
                          : Text('Buat Pertanyaan :',
                              style: TextStyle(
                                color: Color(0xFF38b5ed),
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              )),
                      SizedBox(height: 4),
                      Container(
                        height: 2,
                        color: Colors.grey[350],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: _textStyle(),
                        controller: questionTextCtrl,
                        // autofocus: true,
                        focusNode: _questionFocusNode,
                        initialValue: null,
                        maxLines: 2,
                        maxLength: 120,

                        decoration: textFieldStyle('Pertanyaan'),
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Kolom pertanyaan tidak boleh kosong';
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        style: _textStyle(),
                        controller: correctAnswerTextCtrl,
                        initialValue: null,
                        maxLength: 20,
                        decoration: textFieldStyle('Jawaban Benar'),
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Kolom Jawab benar tidak boleh kosong';
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: screenWidth * 0.35,
                            child: TextFormField(
                              style: _textStyle(),
                              maxLines: null,
                              controller: correctAnswerTextCtrl,
                              initialValue: null,
                              enabled: false,
                              decoration: textFieldStyle('Pilihan 1'),
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Kolom Pilihan 1 tidak boleh kosong';
                                return null;
                              },
                            ),
                          ),
                          Container(
                            width: screenWidth * 0.35,
                            child: TextFormField(
                              style: _textStyle(),
                              maxLines: null,
                              controller: option2TextCtrl,
                              decoration: textFieldStyle('Pilihan 2'),
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Kolom Pilihan 2 tidak boleh kosong';
                                else if (value.length > 30)
                                  return 'Makasimal Karakter 30';
                                else
                                  return null;
                              },
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: screenWidth * 0.35,
                            child: TextFormField(
                              style: _textStyle(),
                              maxLines: null,
                              controller: option3TextCtrl,
                              decoration: textFieldStyle('Pilihan 3'),
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Kolom Pilihan 3 tidak boleh kosong';
                                else if (value.length > 30)
                                  return 'Makasimal Karakter 30';
                                else
                                  return null;
                              },
                            ),
                          ),
                          Container(
                            width: screenWidth * 0.35,
                            child: TextFormField(
                              style: _textStyle(),
                              maxLines: null,
                              controller: option4TextCtrl,
                              decoration: textFieldStyle('Pilihan 4'),
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Kolom Pilihan 4 tidak boleh kosong';
                                else if (value.length > 30)
                                  return 'Makasimal Karakter 30';
                                else
                                  return null;
                              },
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: screenWidth * 0.9,
                        child: DropdownButtonFormField<int>(
                          style: _textStyle(),
                          items: _kategori,
                          onChanged: (value) {
                            setState(() {
                              _category = value;
                            });
                          },
                          value: _category,
                          decoration: textFieldStyle('Pilih Kategori:'),
                          validator: (value) {
                            if (value == null)
                              return 'Kolom ini tidak boleh kosong.';
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        width: screenWidth * 0.9,
                        child: DropdownButtonFormField<int>(
                          style: _textStyle(),
                          items: _tingakKesulitan,
                          onChanged: (value) {
                            setState(() {
                              _level = value;
                            });
                          },
                          value: _level,
                          decoration: textFieldStyle('Pilih Level:'),
                          validator: (value) {
                            if (value == null)
                              return 'Kolom ini tidak boleh kosong.';
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
