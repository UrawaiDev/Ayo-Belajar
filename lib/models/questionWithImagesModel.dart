class QuestionsWithImages {
  final String imageUrl;
  final String question;
  final correctAnswer;
  final option1;
  final option2;
  final option3;
  final option4;

  QuestionsWithImages(
      {this.imageUrl,
      this.question,
      this.correctAnswer,
      this.option1,
      this.option2,
      this.option3,
      this.option4});

  List<QuestionsWithImages> fetchQuestion(int count) {
    List<QuestionsWithImages> myQuestion = [
      QuestionsWithImages(
          imageUrl: 'assets/images/elephant.png',
          question: 'Gambar Hewan Apakah ini ? ',
          correctAnswer: 'gajah',
          option1: 'ikan',
          option2: 'buaya',
          option3: 'gajah',
          option4: 'musang'),
      QuestionsWithImages(
          imageUrl: 'assets/images/shark.png',
          question: 'Gambar Ikan Apakah ini ? ',
          correctAnswer: 'hiu',
          option1: 'Barongan',
          option2: 'Kuwe',
          option3: 'hiu',
          option4: 'Nemo'),
      QuestionsWithImages(
          imageUrl: 'assets/images/buaya.png',
          question: 'Gambar Hewan Apakah ini ? ',
          correctAnswer: 'buaya',
          option1: 'bunaya',
          option2: 'buaya',
          option3: 'bunina',
          option4: 'bulaya'),
      QuestionsWithImages(
          imageUrl: 'assets/images/kelinci.png',
          question: 'Gambar Hewan Apakah ini ? ',
          correctAnswer: 'kelinci',
          option1: 'kalinco',
          option2: 'keloncu',
          option3: 'kelunco',
          option4: 'kelinci'),
      QuestionsWithImages(
          imageUrl: 'assets/images/kuda.png',
          question: 'Gambar Hewan Apakah ini ? ',
          correctAnswer: 'kuda',
          option1: 'kuman',
          option2: 'kuda',
          option3: 'kopi',
          option4: 'cacing'),
      QuestionsWithImages(
          imageUrl: 'assets/images/ular.jpg',
          question: 'Gambar Hewan Apakah ini ? ',
          correctAnswer: 'ular',
          option1: 'udang',
          option2: 'unta',
          option3: 'ular',
          option4: 'umang'),
      QuestionsWithImages(
          imageUrl: 'assets/images/bajumerah.jpg',
          question: 'Warna apakah bajunya ? ',
          correctAnswer: 'merah',
          option1: 'biru',
          option2: 'kuning',
          option3: 'merah',
          option4: 'coklat'),
      QuestionsWithImages(
          imageUrl: 'assets/images/jeruk.jpg',
          question: 'Gambar buah apakah ini ? ',
          correctAnswer: 'jeruk',
          option1: 'apel',
          option2: 'jeruk',
          option3: 'jambu',
          option4: 'pisang'),
      QuestionsWithImages(
          imageUrl: 'assets/images/apel.jpg',
          question: 'Gambar buah apakah ini ? ',
          correctAnswer: 'apel',
          option1: 'jeruk',
          option2: 'nenas',
          option3: 'apel',
          option4: 'anggur'),
      QuestionsWithImages(
          imageUrl: 'assets/images/semangka.jpg',
          question: 'Gambar buah apakah ini ? ',
          correctAnswer: 'semangka',
          option1: 'kelapa',
          option2: 'manggis',
          option3: 'salak',
          option4: 'semangka'),
    ];

    myQuestion.shuffle();
    myQuestion.length = count;

    return myQuestion;
  }
}
