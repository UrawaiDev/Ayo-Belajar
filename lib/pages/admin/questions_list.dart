import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:math_quiz/models/Initial_Question.dart';
import 'package:math_quiz/models/questionsModel.dart';
import 'package:math_quiz/models/user.dart';
import 'package:math_quiz/pages/admin/add_question_image.dart';
import 'package:math_quiz/pages/admin/add_questions.dart';
import 'package:math_quiz/pages/admin/searchDelegate.dart';
import 'package:math_quiz/provider/generalState.dart';
import 'package:math_quiz/styles/checkDesc.dart';
import 'package:math_quiz/styles/textStyles.dart';
import 'package:provider/provider.dart';

class QuestionListPage extends StatefulWidget {
  @override
  _QuestionListPageState createState() => _QuestionListPageState();
}

class _QuestionListPageState extends State<QuestionListPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<int> _matematika = [];
  List<int> _membaca = [];
  List<int> _pengetahuanUmum = [];
  List<int> _bahasaInggris = [];
  List<int> _tebakGambar = [];

  int _matematikaLevelMudah = 0;
  int _matematikaLevelSedang = 0;
  int _matematikaLevelSulit = 0;

  int _membacaLevelMudah = 0;
  int _membacaLevelSedang = 0;
  int _membacaLevelSulit = 0;

  int _tebakGambarLevelMudah = 0;
  int _tebakGambarLevelSedang = 0;
  int _tebakGambarLevelSulit = 0;

  int _pengetahuanUmumLevelMudah = 0;
  int _pengetahuanUmumLevelSedang = 0;
  int _pengetahuanUmumLevelSulit = 0;

  int _bahasaInggrisLevelMudah = 0;
  int _bahasaInggrisLevelSedang = 0;
  int _bahasaInggrisLevelSulit = 0;

  static const MATEMATIKA = 1;
  static const MEMBACA = 2;
  static const TEBAK_GAMBAR = 3;
  static const PENGETAHUAN_UMUM = 4;
  static const BAHASA_INGGRIS = 5;

  static const MUDAH = 1;
  static const SEDANG = 2;
  static const SULIT = 3;

  int _questionLength = 0;

  InitialData defaultQuestion = InitialData();

  int _getCountOfQuestions() {
    //clear list at first
    _matematika.clear();
    _membaca.clear();
    _pengetahuanUmum.clear();
    _bahasaInggris.clear();
    _tebakGambar.clear();

    _matematikaLevelMudah = 0;
    _matematikaLevelSedang = 0;
    _matematikaLevelSulit = 0;

    _membacaLevelMudah = 0;
    _membacaLevelSedang = 0;
    _membacaLevelSulit = 0;

    _tebakGambarLevelMudah = 0;
    _tebakGambarLevelSedang = 0;
    _tebakGambarLevelSulit = 0;

    _pengetahuanUmumLevelMudah = 0;
    _pengetahuanUmumLevelSedang = 0;
    _pengetahuanUmumLevelSulit = 0;

    _bahasaInggrisLevelMudah = 0;
    _bahasaInggrisLevelSedang = 0;
    _bahasaInggrisLevelSulit = 0;

    final user = Provider.of<User>(context, listen: false);

    Hive.openBox('Questions');
    var myBox = Hive.box(user.uid);

    myBox.values.forEach((data) {
      var x = data as Questions;

      if (x.categoryId == MATEMATIKA) {
        _matematika.add(x.categoryId);

        if (x.level == MUDAH)
          _matematikaLevelMudah++;
        else if (x.level == SEDANG)
          _matematikaLevelSedang++;
        else if (x.level == SULIT) _matematikaLevelSulit++;
      } else if (x.categoryId == MEMBACA) {
        _membaca.add(x.categoryId);

        if (x.level == MUDAH)
          _membacaLevelMudah++;
        else if (x.level == SEDANG)
          _membacaLevelSedang++;
        else if (x.level == SULIT) _membacaLevelSulit++;
      } else if (x.categoryId == PENGETAHUAN_UMUM) {
        _pengetahuanUmum.add(x.categoryId);
        if (x.level == MUDAH)
          _pengetahuanUmumLevelMudah++;
        else if (x.level == SEDANG)
          _pengetahuanUmumLevelSedang++;
        else if (x.level == SULIT) _pengetahuanUmumLevelSulit++;
      } else if (x.categoryId == BAHASA_INGGRIS) {
        _bahasaInggris.add(x.categoryId);
        if (x.level == MUDAH)
          _bahasaInggrisLevelMudah++;
        else if (x.level == SEDANG)
          _bahasaInggrisLevelSedang++;
        else if (x.level == SULIT) _bahasaInggrisLevelSulit++;
      } else if (x.categoryId == TEBAK_GAMBAR) {
        _tebakGambar.add(x.categoryId);
        if (x.level == MUDAH)
          _tebakGambarLevelMudah++;
        else if (x.level == SEDANG)
          _tebakGambarLevelSedang++;
        else if (x.level == SULIT) _tebakGambarLevelSulit++;
      }
    });

    int _totalQuestions = _matematika.length +
        _pengetahuanUmum.length +
        _membaca.length +
        _bahasaInggris.length +
        _tebakGambar.length;

    return _totalQuestions;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _resetList() {
    final appState = Provider.of<GeneralState>(context);
    appState.levelId = 0;
    appState.categoryId = 0;
  }

  _deleteData(Questions _questions, String uid, String key) async {
    try {
      Box<dynamic> questionsBox = Hive.box(uid);
      // when category Tebak Gambar
      if (_questions.categoryId == TEBAK_GAMBAR) {
        File imageFile = File(_questions.photoUrl);
        var fileExist = await imageFile.exists();
        if (fileExist) await imageFile.delete();
      }

      print('trying to delete :' + key.toString());
      await questionsBox.delete(key);
      // await questionsBox.deleteAt(0);

      Navigator.pop(context, false);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Row(
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.red,
            ),
            SizedBox(width: 20),
            Text(
              'Pertanyaan sudah dihapus.',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ));
      //refresh page to reload correct summary questions length
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getCountOfQuestions();
    print('page initiated');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final user = Provider.of<User>(context, listen: false);
    final appState = Provider.of<GeneralState>(context);

    print('page rebuild');

    // TODO: need to check proper way
    _questionLength = _getCountOfQuestions();

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        // backgroundColor: Colors.grey.withOpacity(0.8),

        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text('Daftar Soal'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: SearchQuestion(),
                  );
                },
              ),
            ),
          ],
        ),
        body: WillPopScope(
          onWillPop: () {
            _resetList();
            Navigator.pop(context);
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,

                          children: <Widget>[
                            ExpansionTile(
                              leading: Icon(FontAwesomeIcons.calculator),
                              title: Text(
                                'MATEMATIKA ( ${_matematika.length.toString()} )',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.free_breakfast),
                                  title: Text(
                                    'LEVEL MUDAH ',
                                    style: TextStyle(color: Colors.brown),
                                  ),
                                  trailing: Text(
                                    '(${_matematikaLevelMudah.toString()})',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    appState.levelId = MUDAH;
                                    appState.categoryId = MATEMATIKA;
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.desktop_mac),
                                  title: Text(
                                    'LEVEL SEDANG ',
                                    style: TextStyle(color: Colors.brown),
                                  ),
                                  trailing: Text(
                                    '(${_matematikaLevelSedang.toString()})',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    appState.levelId = SEDANG;
                                    appState.categoryId = MATEMATIKA;
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.directions_bike),
                                  title: Text(
                                    'LEVEL SULIT ',
                                    style: TextStyle(color: Colors.brown),
                                  ),
                                  trailing: Text(
                                    '(${_matematikaLevelSulit.toString()})',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    appState.levelId = SULIT;
                                    appState.categoryId = MATEMATIKA;
                                  },
                                )
                              ],
                            ),
                            ExpansionTile(
                              leading: Icon(FontAwesomeIcons.layerGroup),
                              title: Text(
                                'PENGETAHUAN UMUM ( ${_pengetahuanUmum.length.toString()} )',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.free_breakfast),
                                  title: Text(
                                    'LEVEL MUDAH ',
                                    style: TextStyle(color: Colors.brown),
                                  ),
                                  trailing: Text(
                                    '(${_pengetahuanUmumLevelMudah.toString()})',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    appState.levelId = MUDAH;
                                    appState.categoryId = PENGETAHUAN_UMUM;
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.desktop_mac),
                                  title: Text(
                                    'LEVEL SEDANG ',
                                    style: TextStyle(color: Colors.brown),
                                  ),
                                  trailing: Text(
                                    '(${_pengetahuanUmumLevelSedang.toString()})',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    appState.levelId = SEDANG;
                                    appState.categoryId = PENGETAHUAN_UMUM;
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.directions_bike),
                                  title: Text(
                                    'LEVEL SULIT ',
                                    style: TextStyle(color: Colors.brown),
                                  ),
                                  trailing: Text(
                                    '(${_pengetahuanUmumLevelSulit.toString()})',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    appState.levelId = SULIT;
                                    appState.categoryId = PENGETAHUAN_UMUM;
                                  },
                                )
                              ],
                            ),
                            ExpansionTile(
                              leading: Icon(FontAwesomeIcons.book),
                              title: Text(
                                'MEMBACA ( ${_membaca.length.toString()} )',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.free_breakfast),
                                  title: Text(
                                    'LEVEL MUDAH ',
                                    style: TextStyle(color: Colors.brown),
                                  ),
                                  trailing: Text(
                                    '(${_membacaLevelMudah.toString()})',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    appState.levelId = MUDAH;
                                    appState.categoryId = MEMBACA;
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.desktop_mac),
                                  title: Text(
                                    'LEVEL SEDANG ',
                                    style: TextStyle(color: Colors.brown),
                                  ),
                                  trailing: Text(
                                    '(${_membacaLevelSedang.toString()})',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    appState.levelId = SEDANG;
                                    appState.categoryId = MEMBACA;
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.directions_bike),
                                  title: Text(
                                    'LEVEL SULIT ',
                                    style: TextStyle(color: Colors.brown),
                                  ),
                                  trailing: Text(
                                    '(${_membacaLevelSulit.toString()})',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    appState.levelId = SULIT;
                                    appState.categoryId = MEMBACA;
                                  },
                                )
                              ],
                            ),
                            ExpansionTile(
                              leading: Icon(FontAwesomeIcons.language),
                              title: Text(
                                'BAHASA INGGRIS ( ${_bahasaInggris.length.toString()} )',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.free_breakfast),
                                  title: Text(
                                    'LEVEL MUDAH ',
                                    style: TextStyle(color: Colors.brown),
                                  ),
                                  trailing: Text(
                                    '(${_bahasaInggrisLevelMudah.toString()})',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    appState.levelId = MUDAH;
                                    appState.categoryId = BAHASA_INGGRIS;
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.desktop_mac),
                                  title: Text(
                                    'LEVEL SEDANG ',
                                    style: TextStyle(color: Colors.brown),
                                  ),
                                  trailing: Text(
                                    '(${_bahasaInggrisLevelSedang.toString()})',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    appState.levelId = SEDANG;
                                    appState.categoryId = BAHASA_INGGRIS;
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.directions_bike),
                                  title: Text(
                                    'LEVEL SULIT ',
                                    style: TextStyle(color: Colors.brown),
                                  ),
                                  trailing: Text(
                                    '(${_bahasaInggrisLevelSulit.toString()})',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    appState.levelId = SULIT;
                                    appState.categoryId = BAHASA_INGGRIS;
                                  },
                                )
                              ],
                            ),
                            ExpansionTile(
                              leading: Icon(FontAwesomeIcons.image),
                              title: Text(
                                'TEBAK GAMBAR ( ${_tebakGambar.length.toString()} )',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.free_breakfast),
                                  title: Text(
                                    'LEVEL MUDAH ',
                                    style: TextStyle(color: Colors.brown),
                                  ),
                                  trailing: Text(
                                    '(${_tebakGambarLevelMudah.toString()})',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    appState.levelId = MUDAH;
                                    appState.categoryId = TEBAK_GAMBAR;
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.desktop_mac),
                                  title: Text(
                                    'LEVEL SEDANG ',
                                    style: TextStyle(color: Colors.brown),
                                  ),
                                  trailing: Text(
                                    '(${_tebakGambarLevelSedang.toString()})',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    appState.levelId = SEDANG;
                                    appState.categoryId = TEBAK_GAMBAR;
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.directions_bike),
                                  title: Text(
                                    'LEVEL SULIT ',
                                    style: TextStyle(color: Colors.brown),
                                  ),
                                  trailing: Text(
                                    '(${_tebakGambarLevelSulit.toString()})',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    appState.levelId = SULIT;
                                    appState.categoryId = TEBAK_GAMBAR;
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Consumer<GeneralState>(
                  builder: (context, appState, _) => Container(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: FutureBuilder(
                      future: Hive.openBox('Questions'),
                      builder: (context, snapshot) {
                        var questionsBox;
                        if (appState.levelId == 0 && appState.categoryId == 0) {
                          // when Question is not filterred
                          questionsBox = Hive.box(user.uid);
                        } else {
                          questionsBox =
                              Hive.box(user.uid).values.where((value) {
                            var myQuestion = value as Questions;

                            return myQuestion.level == appState.levelId &&
                                myQuestion.categoryId == appState.categoryId;
                          });
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          _questionLength = questionsBox.length;

                          if (questionsBox.length == 0)
                            return Container(
                              height: 200,
                              margin: EdgeInsets.only(
                                  top: 20, bottom: 50, left: 10, right: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              alignment: Alignment.center,
                              // padding: EdgeInsets.only(top: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Belum ada Soal...',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 30),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                        color: Colors.blue,
                                        width: 1.5,
                                      )),
                                      child: FlatButton.icon(
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        icon: Icon(Icons.file_upload,
                                            color: Colors.blue),
                                        label:
                                            Text('Memuat Soal \'Matematika\' '),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (_) => AlertDialog(
                                                    title: Text('Konfirmasi'),
                                                    content: Row(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.info,
                                                          color: Colors.blue,
                                                        ),
                                                        SizedBox(width: 20),
                                                        Expanded(
                                                          child: Text(
                                                              'Anda akan memuat soal bawaan untuk kategori Matematika ?'),
                                                        ),
                                                      ],
                                                    ),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: Text('Tidak')),
                                                      FlatButton(
                                                          onPressed: () {
                                                            defaultQuestion
                                                                .initialSoalMatematika(
                                                                    user.uid);
                                                            Navigator.pop(
                                                                context);
                                                            //Refresh Page..
                                                            setState(() {});
                                                          },
                                                          child: Text('Ya')),
                                                    ],
                                                  ));
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                        color: Colors.blue,
                                        width: 1.5,
                                      )),
                                      child: FlatButton.icon(
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        icon: Icon(Icons.file_upload,
                                            color: Colors.blue),
                                        label: Text('Memuat Soal \'Membaca\' '),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (_) => AlertDialog(
                                                    title: Text('Konfirmasi'),
                                                    content: Row(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.info,
                                                          color: Colors.blue,
                                                        ),
                                                        SizedBox(width: 20),
                                                        Expanded(
                                                          child: Text(
                                                              'Anda akan memuat soal bawaan untuk kategori Membaca ?'),
                                                        ),
                                                      ],
                                                    ),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: Text('Tidak')),
                                                      FlatButton(
                                                          onPressed: () {
                                                            defaultQuestion
                                                                .initialSoalMembaca(
                                                                    user.uid);
                                                            Navigator.pop(
                                                                context);
                                                            //Refresh Page..
                                                            setState(() {});
                                                          },
                                                          child: Text('Ya')),
                                                    ],
                                                  ));
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );

                          if (snapshot.hasData) {
                            return Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.view_column,
                                                  size: 35,
                                                  color: Colors.brown,
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  'Total Pertanyaan :',
                                                  style: playerStyle,
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  '( ${_questionLength.toString()} )',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            (appState.levelId != 0)
                                                ? IconButton(
                                                    tooltip: 'Refresh List',
                                                    icon: Icon(
                                                      Icons.refresh,
                                                      size: 35,
                                                      color: Colors.blue,
                                                    ),
                                                    onPressed: () =>
                                                        _resetList())
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.42,
                                    child: _buildListViewCard(questionsBox,
                                        appState, screenWidth, user),
                                  ),
                                ],
                              ),
                            );
                          }
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListViewCard(
      questionsBox, GeneralState appState, double screenWidth, User user) {
    return Container(
      // color: Colors.grey.shade700,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: questionsBox.length,
        itemBuilder: (context, index) {
          var _questions;
          if (appState.levelId == 0 || appState.categoryId == 0)
            _questions = questionsBox.getAt(index) as Questions;
          else {
            _questions = questionsBox.elementAt(index) as Questions;
          }

          int lenQuestionChar = _questions.question.length;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Card(
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8,
                ),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
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
                                child: Text(_questions.question.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            (lenQuestionChar > 17) ? 16 : 20)),
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: FadeInImage(
                                      placeholder: AssetImage(
                                          'assets/images/placeholder.gif'),
                                      image:
                                          FileImage(File(_questions.photoUrl)),
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
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.edit),
                                iconSize: 30,
                                tooltip: 'Ubah Soal',
                                color: Colors.blueAccent,
                                onPressed: () {
                                  if (_questions.categoryId != 3) {
                                    //UnFilter List
                                    _resetList();

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddQuestionPage(
                                                  true,
                                                  _questions.id,
                                                  _questions.question,
                                                  _questions.correctAnswer,
                                                  _questions.option2,
                                                  _questions.option3,
                                                  _questions.option4,
                                                  _questions.level,
                                                  _questions.categoryId,
                                                )));
                                  } else if (_questions.categoryId ==
                                      TEBAK_GAMBAR) {
                                    //UnFilter List
                                    _resetList();

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddQuestionImagePage(
                                                  true,
                                                  _questions.id,
                                                  _questions.question,
                                                  _questions.correctAnswer,
                                                  _questions.option2,
                                                  _questions.option3,
                                                  _questions.option4,
                                                  _questions.level,
                                                  _questions.categoryId,
                                                  _questions.photoUrl,
                                                )));
                                  }
                                },
                              ),
                              SizedBox(height: 15),
                              IconButton(
                                icon: Icon(Icons.delete),
                                iconSize: 30,
                                tooltip: 'Hapus Soal',
                                color: Colors.red,
                                onPressed: () {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title:
                                                Text('Konfirmasi Hapus Soal'),
                                            content: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.delete_forever,
                                                  color: Colors.red[300],
                                                  size: 30,
                                                ),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child:
                                                      Text(_questions.question),
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
                                                onPressed: () {
                                                  _deleteData(
                                                    _questions,
                                                    user.uid,
                                                    _questions.id,
                                                  );

                                                  //UnFilter List
                                                  appState.categoryId = 0;
                                                  appState.levelId = 0;
                                                },
                                              )
                                            ],
                                          ));
                                },
                              ),
                            ],
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '             : ' +
                                      CheckDescription()
                                          .cekLevel(_questions.level),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
                        ],
                      ),
                    )
                  ],
                )),
          );
        },
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
                child: Text(optionValue,
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
          optionValue: _questions.option1.toString(),
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
}
