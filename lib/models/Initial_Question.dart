import 'package:hive/hive.dart';
import 'package:math_quiz/models/questionsModel.dart';

class InitialData {
  List<Questions> matematika = [
    Questions(
      id: '0',
      question: ' 2 + 1 = ',
      correctAnswer: '3',
      option1: '3',
      option2: '4',
      option3: '5',
      option4: '6',
      level: 1,
      categoryId: 1,
    ),
    Questions(
      id: '1',
      question: ' 2 + 2 = ',
      correctAnswer: '4',
      option1: '4',
      option2: '7',
      option3: '5',
      option4: '6',
      level: 1,
      categoryId: 1,
    ),
    Questions(
      id: '2',
      question: ' 4 + 2 = ',
      correctAnswer: '6',
      option1: '6',
      option2: '7',
      option3: '5',
      option4: '9',
      level: 1,
      categoryId: 1,
    ),
    Questions(
      id: '3',
      question: ' 14 + 7 = ',
      correctAnswer: '21',
      option1: '21',
      option2: '22',
      option3: '23',
      option4: '24',
      level: 2,
      categoryId: 1,
    ),
    Questions(
      id: '4',
      question: ' 22 + 8 = ',
      correctAnswer: '30',
      option1: '30',
      option2: '31',
      option3: '32',
      option4: '33',
      level: 2,
      categoryId: 1,
    ),
    Questions(
      id: '5',
      question: ' 47 + 12 = ',
      correctAnswer: '59',
      option1: '59',
      option2: '54',
      option3: '52',
      option4: '51',
      level: 2,
      categoryId: 1,
    ),
    Questions(
      id: '6',
      question: ' 120 + 56 = ',
      correctAnswer: '176',
      option1: '176',
      option2: '156',
      option3: '146',
      option4: '186',
      level: 3,
      categoryId: 1,
    ),
    Questions(
      id: '7',
      question: ' 134 + 76 = ',
      correctAnswer: '210',
      option1: '210',
      option2: '110',
      option3: '310',
      option4: '212',
      level: 3,
      categoryId: 1,
    ),
    Questions(
      id: '8',
      question: ' 188 + 154 = ',
      correctAnswer: '342',
      option1: '342',
      option2: '242',
      option3: '424',
      option4: '324',
      level: 3,
      categoryId: 1,
    ),
  ];

  List<Questions> membaca = [
    Questions(
      id: '0',
      question: 'BUDI SENANG BERMAIN BOLA DI .. ',
      correctAnswer: 'LAPANGAN',
      option1: 'LAPANGAN',
      option2: 'SAWAH',
      option3: 'GEDUNG',
      option4: 'SUNGAI',
      level: 1,
      categoryId: 2,
    ),
    Questions(
      id: '1',
      question: 'JUMLAH KAKI SAPI ADA ...',
      correctAnswer: 'EMPAT',
      option1: 'EMPAT',
      option2: 'LIMA',
      option3: 'TIGA',
      option4: 'DUA',
      level: 1,
      categoryId: 2,
    ),
  ];

  initialSoalMatematika(String uid) {
    Hive.openBox('Questions');
    var questionBox = Hive.box(uid);

    int key = 0;

    matematika.forEach((data) {
      questionBox.put(key.toString(), data);
      key++;
    });
  }

  initialSoalMembaca(String uid) {
    Hive.openBox('Questions');
    var questionBox = Hive.box(uid);

    int key = 0;

    membaca.forEach((data) {
      questionBox.put(key.toString(), data);
      key++;
    });
  }
}
