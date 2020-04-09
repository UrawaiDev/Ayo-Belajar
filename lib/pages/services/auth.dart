import 'package:firebase_auth/firebase_auth.dart';
import 'package:math_quiz/models/Initial_Question.dart';
import 'package:math_quiz/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _userDocuments = Firestore.instance.collection('Users');
  final myQuestion = InitialData();

  User _getUser(FirebaseUser user) => user != null
      ? User(
          uid: user.uid,
          displayName: user.displayName == null ? 'Guest' : user.displayName,
          email: user.email)
      : null;

  //auth change by stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_getUser);
  }

  //sign in anonymous
  Future signAnonymous() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;

      return _getUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email
  Future<dynamic> signInWithEmail({String email, String password}) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser user = result.user;

      return _getUser(user);
    } catch (e) {
      // print(e.toString());
      return e.message.toString();
    }
  }

  //register with email
  Future registerWithEmail(
      {String email, String password, String username}) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser user = result.user;

      //add new user to cloud firebase
      _userDocuments.document(user.uid).setData({
        'uid': user.uid,
        'username': username,
        'email': email,
        'provider': user.providerId,
        'photo_url':
            'https://firebasestorage.googleapis.com/v0/b/aplikasi-ayo-belajar.appspot.com/o/no_picture.png?alt=media&token=a11ab754-8bee-49cf-9fdb-91625d92d0a3',
        'mediumTimeLimit': 60,
        'hardTimeLimit': 30,
        'easyMaxQuestions': 10,
        'mediumMaxQuestions': 10,
        'hardMaxQuestions': 10,
        'points': 0,
      });

      //Create Default Questions
      // myQuestion.initialQuestions(user.uid);

      return _getUser(user);
    } catch (e) {
      // print(e.message);
      // print(e.code);
      // print(e.details);

      return e.message.toString();
    }
  }

  //Reset Password
  Future resetPassword({String email}) async {
    try {
      var result = await _auth.sendPasswordResetEmail(email: email);
      return result;
    } catch (e) {
      print(e.message.toString());
      return e.message.toString();
    }
  }

  //sign out
  Future signOut() async {
    await _auth.signOut();
    // _getUser(null);
  }

  //Future get Users from firebase
  Future<QuerySnapshot> getUserfromFirebase(String uid) async {
    var snapshot = _userDocuments.where('uid', isEqualTo: uid).snapshots();
    var dataResult = await snapshot.first;

    return dataResult;
  }
}
