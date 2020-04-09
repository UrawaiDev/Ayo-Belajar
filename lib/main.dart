import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import 'package:math_quiz/pages/services/auth.dart';
import 'package:math_quiz/pages/services/gateKepeer.dart';

import 'package:math_quiz/provider/Timer.dart';

import 'package:math_quiz/provider/answer.dart';
import 'package:math_quiz/provider/generalState.dart';

import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path;

import 'models/questionsModel.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  var appDirectory = await path.getApplicationDocumentsDirectory();
  Hive.init(appDirectory.path);
  Hive.registerAdapter(QuestionsAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Answer()),
        ChangeNotifierProvider.value(value: TimerApp()),
        ChangeNotifierProvider.value(value: GeneralState()),
      ],
      child: StreamProvider<User>.value(
        value: AuthService().user,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Quicksand'),
          home: GateKeeper(),
        ),
      ),
    );
  }
}
