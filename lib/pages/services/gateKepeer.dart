import 'package:flutter/material.dart';
import 'package:math_quiz/models/user.dart';
import 'package:math_quiz/pages/admin/login.dart';
import 'package:math_quiz/pages/mainMenu.dart';
import 'package:provider/provider.dart';

class GateKeeper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null)
      return LoginPage();
    else
      return MainMenu(
        userId: user.uid,
        displayName: user.displayName,
        email: user.email,
      );
  }
}
