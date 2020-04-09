import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:math_quiz/models/questionsModel.dart';
import 'package:math_quiz/models/user.dart';
import 'package:math_quiz/pages/mainMenu.dart';
import 'package:math_quiz/provider/generalState.dart';
import 'package:math_quiz/styles/textStyles.dart';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddQuestionImagePage extends StatefulWidget {
  final bool isEdit;
  final String uuid;
  final String question;
  final String correctAnswer;
  final String option2;
  final String option3;
  final String option4;
  final int level;
  final int categoryId;
  final String photoUrl;

  AddQuestionImagePage([
    this.isEdit = false,
    this.uuid,
    this.question,
    this.correctAnswer,
    this.option2,
    this.option3,
    this.option4,
    this.level,
    this.categoryId,
    this.photoUrl,
  ]);

  @override
  _AddQuestionImagePageState createState() => _AddQuestionImagePageState();
}

class _AddQuestionImagePageState extends State<AddQuestionImagePage> {
  final TextEditingController questionTextCtrl = TextEditingController();
  final TextEditingController correctAnswerTextCtrl = TextEditingController();
  final TextEditingController option1TextCtrl = TextEditingController();
  final TextEditingController option2TextCtrl = TextEditingController();
  final TextEditingController option3TextCtrl = TextEditingController();
  final TextEditingController option4TextCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode _questionFocusNode;
  Uuid _uuid = Uuid();

  String imagePath;

  int _level;
  int _editLevel;
  int _categoryId;

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

  void _showSnackBar(
      {IconData icon, Color iconColor, String scaffoldText, double fontsize}) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      duration: Duration(seconds: 2),
      content: Row(
        children: <Widget>[
          Icon(icon, color: iconColor),
          SizedBox(width: 20),
          Text(scaffoldText, style: TextStyle(fontSize: fontsize)),
        ],
      ),
    ));
  }

  void _loadPicture(ImageSource imageSource, BuildContext context) async {
    final appState = Provider.of<GeneralState>(context);

    try {
      var image = await ImagePicker.pickImage(source: imageSource);

      if (image != null) {
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String appPath = appDir.path;
        final filename = path.basenameWithoutExtension(image.path) +
            DateTime.now().toString();

        File copiedFile = await image.copy(appPath + '/' + filename + '.jpg');
        print(copiedFile.path);
        copiedFile.exists().then((value) => print(value));

        imagePath = copiedFile.path;
        appState.imageFile = copiedFile;
      }
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text(e.toString()),
      ));
      // ImagePicker.retrieveLostData().then((value) => print(value.file.path));
    }
  }

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
    if (widget.level != null) _editLevel = widget.level;
    if (widget.photoUrl != null) imagePath = widget.photoUrl;
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
    final myAppState = Provider.of<GeneralState>(context);
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
            // backgroundColor: Colors.transparent,
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton.extended(
                  // heroTag: 'btn1',
                  backgroundColor: Color(0xFF41aaf1),
                  elevation: 5.0,
                  icon: Icon(Icons.save),
                  label: widget.isEdit ? Text('Update') : Text('Simpan'),
                  onPressed: () {
                    var questionBox = Hive.box(user.uid);

                    if (_formKey.currentState.validate() && imagePath != null) {
                      if (!widget.isEdit) {
                        String uuid = _uuid.v1();
                        var question = Questions(
                          id: uuid,
                          question: questionTextCtrl.text,
                          correctAnswer: correctAnswerTextCtrl.text,
                          option1: correctAnswerTextCtrl.text,
                          option2: option2TextCtrl.text,
                          option3: option3TextCtrl.text,
                          option4: option4TextCtrl.text,
                          level: _level,
                          categoryId: 3, // Category Question with Picture
                          photoUrl: imagePath,
                        );
                        questionBox.put(uuid, question);

                        print('ini path ke db :' + imagePath);

                        _showSnackBar(
                          icon: Icons.save,
                          iconColor: Colors.white,
                          scaffoldText: 'Pertanyaan sudah disimpan.',
                          fontsize: 18,
                        );

                        //set cursor back to textbox question
                        // FocusScope.of(context).requestFocus(_questionFocusNode);

                      } else if (widget.isEdit && imagePath != null) {
                        questionBox.put(
                            widget.uuid,
                            Questions(
                              question: questionTextCtrl.text,
                              correctAnswer: correctAnswerTextCtrl.text,
                              option1: correctAnswerTextCtrl.text,
                              option2: option2TextCtrl.text,
                              option3: option3TextCtrl.text,
                              option4: option4TextCtrl.text,
                              level: _level == null ? widget.level : _level,
                              categoryId: _categoryId == null
                                  ? widget.categoryId
                                  : _categoryId,
                              photoUrl: imagePath,
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
                                          child: Text('OK'))
                                    ],
                                  ),
                                ));
                      }
                      //doesnt work
                      // _formKey.currentState.reset();
                      //manual reset
                      questionTextCtrl.text = '';
                      correctAnswerTextCtrl.text = '';
                      option1TextCtrl.text = '';
                      option4TextCtrl.text = '';
                      option2TextCtrl.text = '';
                      option3TextCtrl.text = '';

                      _editLevel = null;
                      // _level = null;
                      imagePath = null;
                      myAppState.imageFile = null;

                      // if (widget.isEdit)
                      //   Navigator.push(context,
                      //       MaterialPageRoute(builder: (context) => MainMenu()));

                      //set cursor back to textbox question
                      // FocusScope.of(context).requestFocus(_questionFocusNode);
                    } else if (_formKey.currentState.validate() &&
                        imagePath == null) {
                      _showSnackBar(
                        icon: Icons.info,
                        iconColor: Colors.white,
                        scaffoldText: 'Belum ada gambar yang di unggah.',
                        fontsize: 15,
                      );
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
                      Consumer<GeneralState>(
                        builder: (context, appState, _) => Stack(
                          children: <Widget>[
                            Container(
                              // width: 250,
                              height: 205,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: (imagePath == null)
                                      ? Colors.grey
                                      : Color(0xFF38b5ed),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                  child: (imagePath == null)
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text('Unggah Gambar',
                                                style: TextStyle(fontSize: 20)),
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                IconButton(
                                                    icon: Icon(
                                                      Icons.image,
                                                      size: 35,
                                                      color: Colors.blueGrey,
                                                    ),
                                                    onPressed: () =>
                                                        _loadPicture(
                                                            ImageSource.gallery,
                                                            context)),
                                                IconButton(
                                                    icon: Icon(
                                                      Icons.camera_alt,
                                                      size: 35,
                                                      color: Colors.blueGrey,
                                                    ),
                                                    onPressed: () =>
                                                        _loadPicture(
                                                            ImageSource.camera,
                                                            context)),
                                              ],
                                            )
                                          ],
                                        )
                                      : FadeInImage(
                                          fit: BoxFit.fill,
                                          placeholder: AssetImage(
                                              'assets/images/placeholder.gif'),
                                          fadeInCurve: Curves.easeIn,
                                          image: FileImage(File(imagePath)))
                                  // : Image(
                                  //     image: FileImage(File(imagePath)),
                                  //     fit: BoxFit.cover),
                                  ),
                            ),
                            (myAppState.imageFile != null || imagePath != null)
                                ? IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      size: 35,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      try {
                                        if (!widget.isEdit) {
                                          print(myAppState.imageFile.path);
                                          if (await myAppState.imageFile
                                              .exists())
                                            await myAppState.imageFile.delete();
                                        }

                                        imagePath = null;
                                        myAppState.imageFile = null;
                                      } catch (e) {
                                        print(e.toString());
                                        _scaffoldKey.currentState.showSnackBar(
                                            SnackBar(
                                                content: Text(e.toString())));
                                      }
                                    })
                                : Container(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: questionTextCtrl,
                        autofocus: false,
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
                      SizedBox(height: 25),
                      Container(
                        width: screenWidth * 0.9,
                        child: DropdownButtonFormField<int>(
                          items: _tingakKesulitan,
                          onChanged: (value) {
                            setState(() {
                              _level = value;
                            });
                          },
                          value: _level == null ? _editLevel : _level,
                          decoration:
                              textFieldStyle('Pilih Tingkat Kesulitan :'),
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
