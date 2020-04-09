import 'package:hive/hive.dart';

part 'questionsModel.g.dart';

@HiveType(typeId: 0)
class Questions {
  @HiveField(0)
  String question;

  @HiveField(1)
  String correctAnswer;

  @HiveField(2)
  String option1;

  @HiveField(3)
  String option2;

  @HiveField(4)
  String option3;

  @HiveField(5)
  String option4;

  @HiveField(6)
  int level;

  @HiveField(7)
  int categoryId;

  @HiveField(8)
  String photoUrl;

  @HiveField(9)
  String id;

  Questions({
    this.question,
    this.correctAnswer,
    this.option1,
    this.option2,
    this.option3,
    this.option4,
    this.level,
    this.categoryId,
    this.photoUrl,
    this.id,
  });
}
