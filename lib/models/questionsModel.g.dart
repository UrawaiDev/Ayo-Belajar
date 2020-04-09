// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionsModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionsAdapter extends TypeAdapter<Questions> {
  @override
  final typeId = 0;

  @override
  Questions read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Questions(
      question: fields[0] as String,
      correctAnswer: fields[1] as String,
      option1: fields[2] as String,
      option2: fields[3] as String,
      option3: fields[4] as String,
      option4: fields[5] as String,
      level: fields[6] as int,
      categoryId: fields[7] as int,
      photoUrl: fields[8] as String,
      id: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Questions obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.question)
      ..writeByte(1)
      ..write(obj.correctAnswer)
      ..writeByte(2)
      ..write(obj.option1)
      ..writeByte(3)
      ..write(obj.option2)
      ..writeByte(4)
      ..write(obj.option3)
      ..writeByte(5)
      ..write(obj.option4)
      ..writeByte(6)
      ..write(obj.level)
      ..writeByte(7)
      ..write(obj.categoryId)
      ..writeByte(8)
      ..write(obj.photoUrl)
      ..writeByte(9)
      ..write(obj.id);
  }
}
