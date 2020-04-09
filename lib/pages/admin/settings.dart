import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:math_quiz/pages/detail_profile_image.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:math_quiz/provider/generalState.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  final uid;

  SettingPage({this.uid});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final StorageReference storageReference =
      FirebaseStorage().ref().child('Screenshot_1575291506');

  final imageUrl = FirebaseStorage.instance.ref().child('dribble_leaderboard');

  List maxEasy = [];
  List maxMedium = [];
  List maxHard = [];

  //Styling
  final Color iconColor = Color(0xFF008e9d);
  final Color textColor = Color(0xFF57595e);

  Future getImageandUploadtoFirebase(GeneralState appState) async {
    try {
      var _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

      var croppedImage = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Image Cropper',
            toolbarColor: Colors.blue[300],
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
      );

      _imageFile = croppedImage ?? _imageFile;

      File compressedImage = await FlutterImageCompress.compressAndGetFile(
        _imageFile.path,
        _imageFile.path + '.jpg',
        quality: 70,
      );

      if (compressedImage != null) {
        appState.isLoading = true;

        String filename = path.basename(_imageFile.path);

        //upload image to firebase stroage
        StorageReference storageReference =
            FirebaseStorage.instance.ref().child(filename);
        StorageUploadTask uploadTask =
            storageReference.putFile(compressedImage);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

        if (uploadTask.isComplete) {
          //update photo url
          String photoUrl = await storageReference.getDownloadURL();
          Firestore.instance.collection('Users').document(widget.uid).updateData({
            'photo_url': photoUrl
          }).whenComplete(() => print(
              ' Total file size : ${((taskSnapshot.bytesTransferred) / 1024).toStringAsFixed(0)} KB'));
        }

        appState.isLoading = false;
      }
    } catch (e) {
      print(e);
    }
  }

  _showDialog(BuildContext context, String _hint, String uid) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Ganti Username'),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: TextFormField(
                    controller: _textEditingController,
                    decoration: InputDecoration(hintText: _hint),
                    maxLines: null,
                    validator: (value) {
                      if (value.length < 3)
                        return 'Minimal 3 Karakter.';
                      else if (value.length > 30) return 'Maksimal Karakter 30';
                      return null;
                    }),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ganti'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Firestore.instance
                        .collection('Users')
                        .document(uid)
                        .updateData({'username': _textEditingController.text});
                    _textEditingController.clear();
                    Navigator.pop(context);
                  }
                },
              ),
              FlatButton(
                child: Text('Batal'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();

    Hive.openBox('Questions');
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    maxEasy.clear();
    maxMedium.clear();
    maxHard.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('Users')
              .where('uid', isEqualTo: widget.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null)
              return Center(child: CircularProgressIndicator());

            var data = snapshot.data.documents[0];

            var _timerSedang = data['mediumTimeLimit'];
            var _timerSulit = data['hardTimeLimit'];

            var _soalMudah = data['easyMaxQuestions'];
            var _soalSedang = data['mediumMaxQuestions'];
            var _soalSulit = data['hardMaxQuestions'];

            return SingleChildScrollView(
              child: Container(
                child: ChangeNotifierProvider.value(
                  value: GeneralState(),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 40),
                      Container(
                          // height: screenHeight * 0.25,
                          // color: Colors.white54,
                          child: Center(
                              child: Stack(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                height: 120,
                                width: 120,
                                child: GestureDetector(
                                  child: Hero(
                                    tag: data['photo_url'],
                                    child: FadeInImage.assetNetwork(
                                      fadeInCurve: Curves.easeIn,
                                      placeholder:
                                          'assets/images/placeholder.gif',
                                      image: data['photo_url'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ProfileImagePage(
                                              imageFileName:
                                                  data['photo_url']))),
                                ),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ],
                          ),
                          Consumer<GeneralState>(
                            builder: (context, appState, _) => Positioned(
                              bottom: 0.0,
                              child: GestureDetector(
                                onTap: () =>
                                    getImageandUploadtoFirebase(appState),
                                child: Container(
                                  height: 40,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.8),
                                  ),
                                  child: Center(
                                      child: Text('Ganti Photo',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ))),
                                ),
                              ),
                            ),
                          ),
                          Consumer<GeneralState>(
                            builder: (context, appState, _) => Positioned(
                                left: 120 * 0.35,
                                top: 120 * 0.35,
                                child: appState.isLoading
                                    ? CircularProgressIndicator()
                                    : Container()),
                          ),
                        ],
                      ))),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              // height: screenHeight * 0.20,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(Icons.perm_identity),
                                      trailing: Text(data['username']),
                                      onTap: () {
                                        _showDialog(context, 'Username Baru',
                                            data['uid']);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.email),
                                      trailing: Text(data['email']),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.settings_input_hdmi),
                                      trailing: Text(data['uid']),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              // height: screenHeight * 0.30,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(
                                        'Pengaturan Waktu :',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.blueGrey),
                                      ),
                                    ),
                                    ListTile(
                                      leading: Text(
                                        'Level [SEDANG]',
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(
                                              Icons.remove,
                                              color: iconColor,
                                            ),
                                            onPressed: () {
                                              if (_timerSedang != 10) {
                                                _timerSedang -= 5;

                                                Firestore.instance
                                                    .collection('Users')
                                                    .document(widget.uid)
                                                    .updateData({
                                                  'mediumTimeLimit':
                                                      _timerSedang
                                                });
                                              }
                                            },
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            _timerSedang.toString() + ' Detik',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: textColor,
                                                fontSize: 16),
                                          ),
                                          SizedBox(width: 5),
                                          IconButton(
                                            icon: Icon(
                                              Icons.add,
                                              color: iconColor,
                                            ),
                                            onPressed: () {
                                              if (_timerSedang < 90) {
                                                _timerSedang += 5;

                                                Firestore.instance
                                                    .collection('Users')
                                                    .document(widget.uid)
                                                    .updateData({
                                                  'mediumTimeLimit':
                                                      _timerSedang
                                                });
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    ListTile(
                                      leading: Text(
                                        'Level [SULIT]',
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(
                                              Icons.remove,
                                              color: iconColor,
                                            ),
                                            onPressed: () {
                                              if (_timerSulit != 5) {
                                                _timerSulit -= 5;

                                                Firestore.instance
                                                    .collection('Users')
                                                    .document(widget.uid)
                                                    .updateData({
                                                  'hardTimeLimit': _timerSulit
                                                });
                                              }
                                            },
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                              _timerSulit.toString() + ' Detik',
                                              style: TextStyle(
                                                  color: textColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          SizedBox(width: 5),
                                          IconButton(
                                            icon: Icon(
                                              Icons.add,
                                              color: iconColor,
                                            ),
                                            onPressed: () {
                                              if (_timerSulit < 90) {
                                                _timerSulit += 5;
                                                Firestore.instance
                                                    .collection('Users')
                                                    .document(widget.uid)
                                                    .updateData({
                                                  'hardTimeLimit': _timerSulit
                                                });
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              // height: screenHeight * 0.30,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(
                                        'Pengaturan Jumlah Soal :',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.blueGrey),
                                      ),
                                    ),
                                    ListTile(
                                      leading: Text(
                                        'Level [MUDAH]',
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(
                                              Icons.remove,
                                              color: iconColor,
                                            ),
                                            onPressed: () {
                                              if (_soalMudah > 1) {
                                                _soalMudah -= 1;
                                                Firestore.instance
                                                    .collection('Users')
                                                    .document(widget.uid)
                                                    .updateData({
                                                  'easyMaxQuestions': _soalMudah
                                                });
                                              }
                                            },
                                          ),
                                          SizedBox(width: 5),
                                          Text(_soalMudah.toString() + ' Soal',
                                              style: TextStyle(
                                                  color: textColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          SizedBox(width: 5),
                                          IconButton(
                                            icon: Icon(
                                              Icons.add,
                                              color: iconColor,
                                            ),
                                            onPressed: () {
                                              if (_soalMudah != 30)
                                                _soalMudah++;
                                              Firestore.instance
                                                  .collection('Users')
                                                  .document(widget.uid)
                                                  .updateData({
                                                'easyMaxQuestions': _soalMudah
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    ListTile(
                                      leading: Text(
                                        'Level [SEDANG]',
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(
                                              Icons.remove,
                                              color: iconColor,
                                            ),
                                            onPressed: () {
                                              if (_soalSedang > 1) {
                                                _soalSedang -= 1;
                                                Firestore.instance
                                                    .collection('Users')
                                                    .document(widget.uid)
                                                    .updateData({
                                                  'mediumMaxQuestions':
                                                      _soalSedang
                                                });
                                              }
                                            },
                                          ),
                                          SizedBox(width: 5),
                                          Text(_soalSedang.toString() + ' Soal',
                                              style: TextStyle(
                                                  color: textColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          SizedBox(width: 5),
                                          IconButton(
                                            icon: Icon(
                                              Icons.add,
                                              color: iconColor,
                                            ),
                                            onPressed: () {
                                              if (_soalSedang < 30)
                                                _soalSedang += 1;
                                              Firestore.instance
                                                  .collection('Users')
                                                  .document(widget.uid)
                                                  .updateData({
                                                'mediumMaxQuestions':
                                                    _soalSedang
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    ListTile(
                                      leading: Text(
                                        'Level [SULIT]',
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(
                                              Icons.remove,
                                              color: iconColor,
                                            ),
                                            onPressed: () {
                                              if (_soalSulit > 1) {
                                                _soalSulit -= 1;
                                                Firestore.instance
                                                    .collection('Users')
                                                    .document(widget.uid)
                                                    .updateData({
                                                  'hardMaxQuestions': _soalSulit
                                                });
                                              }
                                            },
                                          ),
                                          SizedBox(width: 5),
                                          Text(_soalSulit.toString() + ' Soal',
                                              style: TextStyle(
                                                  color: textColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          SizedBox(width: 5),
                                          IconButton(
                                            icon: Icon(
                                              Icons.add,
                                              color: iconColor,
                                            ),
                                            onPressed: () {
                                              if (_soalSulit < 30) {
                                                _soalSulit += 1;
                                                Firestore.instance
                                                    .collection('Users')
                                                    .document(widget.uid)
                                                    .updateData({
                                                  'hardMaxQuestions': _soalSulit
                                                });
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
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
            );
          },
        ),
      ),
    );
  }
}
