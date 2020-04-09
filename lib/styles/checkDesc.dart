class CheckDescription {
  String name;

  String cekLevel(int id) {
    switch (id) {
      case 1:
        return 'Mudah';
        break;
      case 2:
        return 'Menengah';
        break;
      case 3:
        return 'Sulit';
        break;

      default:
        return 'UnKnown';
        break;
    }
  }

  String cekCategory(int id) {
    switch (id) {
      case 1:
        return 'Matematika';
        break;
      case 2:
        return 'Membaca';
        break;
      case 3:
        return 'Tebak Gambar';
        break;
      case 4:
        return 'Pengetahuan Umum';
        break;
      case 5:
        return 'Bahasa Inggris';
        break;

      default:
        return 'UnKnown';
        break;
    }
  }
}
