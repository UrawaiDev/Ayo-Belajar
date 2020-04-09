import 'dart:async';

import 'package:basic_utils/basic_utils.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:math_quiz/pages/admin/reset_password.dart';

import 'package:math_quiz/pages/services/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formLoginKey = GlobalKey<FormState>();
  final _formSignUpKey = GlobalKey<FormState>();

  final TextEditingController _userName = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _reTypepasswordTextController =
      TextEditingController();

  final AuthService _authService = AuthService();

  String errorMsg = '';
  bool _isFailed = false;
  bool _isLoading = false;
  bool _isLoginPage = true;

  bool _obscureText = true;

  @override
  void dispose() {
    _userName.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _reTypepasswordTextController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _isBackButtonPressed,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.cover)),
        child: Scaffold(
          // backgroundColor: Color(0xFF8bc2be),
          backgroundColor: Colors.transparent,
          body: Center(
              child: (!_isLoading)
                  ? SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 30),
                          Container(
                            height: 200,
                            width: screenWidth * 0.7,
                            child: FlareActor(
                              'assets/flare/teddy_animation.flr',
                              fit: BoxFit.cover,
                              animation: _isFailed ? 'fail' : 'idle',
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: _isLoginPage
                                      ? _formLogin()
                                      : _formSignUp()),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              // border: Border.all(color: Colors.blue),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                    child: Text('Lupa Password?',
                                        style: TextStyle(
                                          fontSize: 16,
                                          decoration: TextDecoration.underline,
                                        )),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ResetPage()));
                                    }),
                                SizedBox(height: 5),
                                (_isLoginPage)
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text('Belum punya akun,',
                                              style: TextStyle(fontSize: 16)),
                                          SizedBox(width: 10),
                                          GestureDetector(
                                            child: Text('Yuk! Daftar',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.underline,
                                                )),
                                            onTap: () {
                                              setState(() {
                                                _isLoginPage = !_isLoginPage;
                                              });
                                            },
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text('Sudah punya akun,',
                                              style: TextStyle(fontSize: 16)),
                                          SizedBox(width: 10),
                                          GestureDetector(
                                            child: Text('Yuk! Login',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.underline,
                                                )),
                                            onTap: () {
                                              setState(() {
                                                _isLoginPage = !_isLoginPage;
                                              });
                                            },
                                          ),
                                        ],
                                      )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              width: 70,
                              height: 70,
                              child: CircularProgressIndicator()),
                          SizedBox(height: 15),
                          Text('Loading...',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ))),
        ),
      ),
    );
  }

  Widget _formLogin() {
    return Form(
      key: _formLoginKey,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _emailTextController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.email), hintText: 'Email'),
                    // maxLength: 20,
                    validator: (value) {
                      if (value.isEmpty)
                        return 'Email Tidak Boleh Kosong';
                      else if (!EmailValidator.validate(value))
                        return 'Email tidak Valid';

                      return null;
                    },
                  ),
                  SizedBox(height: 25),
                  TextFormField(
                      controller: _passwordTextController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(_obscureText
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          icon: Icon(Icons.lock),
                          hintText: 'Password'),
                      validator: (value) => value.isEmpty
                          ? 'Password tidak boleh kosong.'
                          : null),
                  SizedBox(height: 20),
                  Text(errorMsg,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red, fontSize: 18)),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          InkWell(
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                      colors: [Color(0xFF41aaf1), Color(0xFF1c77f1)]),
                ),
                child: Center(
                    child: Text(
                  'LOGIN',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                )),
              ),
            ),
            onTap: () async {
              if (_formLoginKey.currentState.validate()) {
                setState(() {
                  _isLoading = true;
                });
                Future.delayed(Duration(seconds: 1), () async {
                  var result = await _authService.signInWithEmail(
                      email: _emailTextController.text,
                      password: _passwordTextController.text);

                  _isLoading = false;

                  if (result is String) {
                    setState(() {
                      // errorMsg = 'User Tidak Di Temukan. Silahkan Coba lagi.';
                      errorMsg = result;
                      _isFailed = true;
                    });
                    //reset to default
                    Future.delayed(Duration(seconds: 4), () {
                      setState(() {
                        _isFailed = false;
                        errorMsg = '';
                      });
                    });
                  }
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _formSignUp() {
    return Form(
      key: _formSignUpKey,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                      controller: _userName,
                      decoration: InputDecoration(
                          icon: Icon(Icons.perm_identity),
                          hintText: 'Username'),
                      validator: (value) {
                        if (value.length < 3)
                          return 'Minimal 3 Karakter.';
                        else if (value.length > 30)
                          return 'Maksimal 30 Karakter.';
                        else
                          return null;
                      }),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _emailTextController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.email), hintText: 'Email'),
                    // maxLength: 20,
                    validator: (value) {
                      if (value.isEmpty)
                        return 'Email Tidak Boleh Kosong';
                      else if (!EmailValidator.validate(value))
                        return 'Email tidak Valid';

                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                      controller: _passwordTextController,
                      obscureText: true,
                      decoration: InputDecoration(
                          icon: Icon(Icons.lock), hintText: 'Password'),
                      validator: (value) => value.isEmpty || value.length < 6
                          ? 'Password Minimal 6 Karakter'
                          : null),
                  SizedBox(height: 15),
                  TextFormField(
                      controller: _reTypepasswordTextController,
                      obscureText: true,
                      decoration: InputDecoration(
                          icon: Icon(Icons.enhanced_encryption),
                          hintText: 'Retype Password'),
                      validator: (value) => value.isEmpty || value.length < 6
                          ? 'Password Minimal 6 Karakter'
                          : value != _passwordTextController.text
                              ? 'Password Tidak sama'
                              : null),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(errorMsg,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red, fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          InkWell(
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                      colors: [Color(0xFF41aaf1), Color(0xFF1c77f1)]),
                ),
                child: Center(
                    child: Text(
                  'Daftar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )),
              ),
            ),
            onTap: () async {
              if (_formSignUpKey.currentState.validate()) {
                setState(() {
                  _isLoading = true;
                });
                try {
                  Future.delayed(Duration(seconds: 1), () async {
                    var result = _authService.registerWithEmail(
                        email: _emailTextController.text,
                        password: _passwordTextController.text,
                        username: StringUtils.capitalize(_userName.text));

                    result.then((value) {
                      if (value is String) {
                        setState(() {
                          errorMsg = value;

                          _isFailed = true;
                        });
                        //reset to default
                        Future.delayed(Duration(seconds: 4), () {
                          setState(() {
                            _isFailed = false;
                            errorMsg = '';
                          });
                        });
                      }

                      setState(() {
                        _isLoading = false;
                      });
                    });
                  });
                } catch (e) {
                  print('tambahan ' + e.toString());
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
