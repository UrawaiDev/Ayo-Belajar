import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:math_quiz/pages/services/auth.dart';

class ResetPage extends StatefulWidget {
  @override
  _ResetPageState createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  final _formKey = GlobalKey<FormState>();
  final emailText = TextEditingController();

  bool _isSuccess = false;
  bool _isError = false;
  String _messageToDisplay;

  @override
  void dispose() {
    emailText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 8),
                    Text('Reset Password',
                        style: TextStyle(fontSize: 25, color: Colors.blue)),
                    SizedBox(height: 20),
                    (_isSuccess)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                  color: (_isError) ? Colors.red : Colors.green,
                                  width: 2,
                                )),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'QuickSand'),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  _messageToDisplay.toString()),
                                          TextSpan(text: '  Email : '),
                                          TextSpan(
                                              text: emailText.text,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold))
                                        ]),
                                  ),
                                )),
                          )
                        : Container(),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: emailText,
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Email Tidak Boleh Kosong';
                          else if (!EmailValidator.validate(value))
                            return 'Email tidak Valid';

                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Alamat email',
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Color(0xFF38b5ed),
                                width: 2,
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              )),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2,
                              )),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2,
                              )),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Container(
                          height: 50,
                          // width: screenWidth * 0.7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(
                                colors: [Color(0xFF41aaf1), Color(0xFF1c77f1)]),
                          ),
                          child: Center(
                              child: Text(
                            'Reset Password',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )),
                        ),
                      ),
                      onTap: () async {
                        if (_formKey.currentState.validate()) {
                          AuthService _auth = AuthService();
                          var _result =
                              await _auth.resetPassword(email: emailText.text);

                          if (_result is String) {
                            _messageToDisplay = _result.toString();
                            _isError = true;
                          } else {
                            _messageToDisplay =
                                'Link reset password sudah dikirim ke alamat ';
                            _isError = false;
                          }

                          setState(() {
                            _isSuccess = true;
                          });
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
