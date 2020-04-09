import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:math_quiz/models/Initial_Question.dart';
import 'package:math_quiz/models/category.dart';
import 'package:math_quiz/pages/admin/add_question_image.dart';
import 'package:math_quiz/pages/admin/add_questions.dart';
import 'package:math_quiz/pages/admin/questions_list.dart';
import 'package:math_quiz/pages/admin/settings.dart';
import 'package:math_quiz/pages/detail_profile_image.dart';
import 'package:math_quiz/pages/levelPage.dart';
import 'package:math_quiz/pages/services/auth.dart';
import 'package:math_quiz/pages/services/scroll_behaviour.dart';

class MainMenu extends StatefulWidget {
  final String displayName;
  final String userId;
  final String email;

  MainMenu({this.userId, this.displayName, this.email});

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final AuthService _auth = AuthService();
  DocumentSnapshot dataSnapshot;
  String defaultPhotoUrl = 'assets/images/player1.jpeg';

  static const Color _iconMenuColor = Color(0xFFF7F7F7);

  List<Category> _myCategory;

  InitialData defaultQuestion = InitialData();

  @override
  void initState() {
    super.initState();
    Hive.openBox(widget.userId);
    _myCategory = Category().getDefaultCategory();
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
                    Icons.exit_to_app,
                    color: Colors.red,
                    size: 25,
                  ),
                  SizedBox(width: 20),
                  Text('Keluar Aplikasi ?')
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
                  },
                ),
                FlatButton(
                  child: Text(
                    'Ya',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                )
              ],
            ));
  }

  Future<void> _signOut() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Konfirmasi'),
              content: Row(
                children: <Widget>[
                  Icon(Icons.info_outline, color: Colors.blue[300]),
                  SizedBox(width: 8),
                  Expanded(child: Text('Anda akan keluar dari Akun ini?')),
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
                  },
                ),
                FlatButton(
                  child: Text(
                    'Ya',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);

                    await _auth.signOut();
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _isBackButtonPressed,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.cover)),
        child: Scaffold(
          // backgroundColor: Color(0xFF2c163a),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            title: Text(
              'Halaman Utama',
              style: TextStyle(color: Colors.black87),
            ),
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(
                  Icons.perm_identity,
                  color: Colors.black87,
                ),
                label: Text('Keluar',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
                onPressed: () {
                  _signOut();
                },
              )
            ],
          ),
          body: ScrollConfiguration(
            behavior: MyScrollBehavior(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),

                    // color: Colors.yellow,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('Users')
                            .where('uid', isEqualTo: widget.userId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(child: CircularProgressIndicator());

                          if (snapshot.hasError)
                            return Center(
                              child: Text(
                                'Upss!..  ${snapshot.error}',
                              ),
                            );

                          return _userHeaderBar(
                              screenHeight: screenHeight,
                              dataSnapshot: snapshot.data.documents[0],
                              iconMenuColor: _iconMenuColor);
                        }),
                  ),
                ),
                // Expanded(
                //   flex: 1,
                //   child: Container(
                //       color: Colors.orange, child: _buildBoxSoalBawaan()),
                // ),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: <Widget>[
                      _buildBoxSoalBawaan(),
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.all(10),
                            itemCount: _myCategory?.length,
                            itemBuilder: (context, index) => _buildMenuItem(
                                context: context,
                                categoryName: _myCategory[index].categoryName,
                                leadingIcon: _myCategory[index].leadingIcon,
                                trailingIcon: _myCategory[index].trailingIcon,
                                beginColor: _myCategory[index].beginColor,
                                endColor: _myCategory[index].endColor,
                                pageDestination: LevelPage(
                                    categoryId: _myCategory[index].id)),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<Box> _buildBoxSoalBawaan() {
    return FutureBuilder(
        future: Hive.openBox(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError) {
            var questionBox = Hive.box(widget.userId);
            if (questionBox.length == 0)
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5.0,
                  vertical: 5,
                ),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.blue,
                    width: 2.5,
                  )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: GestureDetector(
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.file_download,
                              size: 35,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 20),
                            Text('Memuat soal  \'Matematika\' ',
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                          ],
                        ),
                      ),
                      onTap: () {
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
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Tidak')),
                                    FlatButton(
                                        onPressed: () {
                                          defaultQuestion.initialSoalMatematika(
                                              widget.userId);
                                          Navigator.pop(context);
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
              );
            else
              return Container();
          }

          return Center(child: CircularProgressIndicator());
        });
  }
}

class _userHeaderBar extends StatelessWidget {
  const _userHeaderBar({
    Key key,
    @required this.screenHeight,
    @required this.dataSnapshot,
    @required Color iconMenuColor,
  })  : _iconMenuColor = iconMenuColor,
        super(key: key);

  final double screenHeight;
  final DocumentSnapshot dataSnapshot;
  final Color _iconMenuColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // HEADER
        Container(
          height: screenHeight * 0.15,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),

                  child: GestureDetector(
                      child: Hero(
                        tag: dataSnapshot['photo_url'],
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              )),
                          child: FadeInImage(
                            fadeInCurve: Curves.easeIn,
                            placeholder:
                                AssetImage('assets/images/placeholder.gif'),
                            image: NetworkImage(dataSnapshot['photo_url']),
                            fit: BoxFit.cover,
                            height: 70,
                            width: 70,
                          ),
                        ),
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileImagePage(
                                    imageFileName: dataSnapshot['photo_url'],
                                  )))),
                  // backgroundColor: Colors.grey.withOpacity(0.3),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(dataSnapshot['username'] ?? 'Guest',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      Text(dataSnapshot['email'] ?? '',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          )),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddQuestionPage()));
                          },
                          icon: Icon(
                            Icons.add_circle,
                            color: _iconMenuColor,
                            size: 32,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddQuestionImagePage()));
                          },
                          icon: Icon(
                            Icons.add_a_photo,
                            color: _iconMenuColor,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QuestionListPage()));
                          },
                          icon: Icon(
                            Icons.list,
                            color: _iconMenuColor,
                            size: 32,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SettingPage(
                                          uid: dataSnapshot['uid'],
                                        )));
                          },
                          icon: Icon(
                            Icons.settings,
                            color: _iconMenuColor,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildMenuItem(
    {BuildContext context,
    String categoryName,
    IconData leadingIcon,
    IconData trailingIcon,
    Color beginColor,
    Color endColor,
    Widget pageDestination}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (contex) => pageDestination));
    },
    child: Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              colors: [beginColor, endColor],
            )),
        child: Center(
          child: ListTile(
            leading: Icon(
              leadingIcon,
              size: 35,
              color: Colors.white60,
            ),
            title: Text(
              categoryName,
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            trailing: Icon(
              trailingIcon,
              size: 35,
              color: Colors.white54,
            ),
          ),
        ),
      ),
    ),
  );
}
