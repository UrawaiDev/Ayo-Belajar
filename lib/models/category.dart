import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Category {
  int id;
  String categoryName;
  IconData leadingIcon;
  IconData trailingIcon;
  Color beginColor;
  Color endColor;

  Category({
    this.id,
    this.categoryName,
    this.leadingIcon,
    this.trailingIcon,
    this.beginColor,
    this.endColor,
  });

  List<Category> getDefaultCategory() {
    List<Category> category = [];

    category.add(Category(
      id: 1,
      categoryName: 'Matematika',
      leadingIcon: FontAwesomeIcons.calculator,
      trailingIcon: FontAwesomeIcons.playCircle,
      beginColor: Color(0xFF814374),
      endColor: Color(0xFF814333),
    ));

    category.add(Category(
      id: 2,
      categoryName: 'Membaca',
      leadingIcon: FontAwesomeIcons.bookOpen,
      trailingIcon: FontAwesomeIcons.playCircle,
      beginColor: Color(0xFF51A39D),
      endColor: Color(0xFF0f57f1),
    ));
    category.add(Category(
      id: 3,
      categoryName: 'Tebak Gambar',
      leadingIcon: FontAwesomeIcons.image,
      trailingIcon: FontAwesomeIcons.playCircle,
      beginColor: Color(0xFFCDBB79),
      endColor: Color(0xFFCDBB8F),
    ));
    category.add(Category(
      id: 4,
      categoryName: 'Pengetahuan Umum',
      leadingIcon: FontAwesomeIcons.layerGroup,
      trailingIcon: FontAwesomeIcons.playCircle,
      beginColor: Color(0xFF814374),
      endColor: Color(0xFF814379),
    ));
    category.add(Category(
      id: 5,
      categoryName: 'Bahasa Inggris',
      leadingIcon: FontAwesomeIcons.language,
      trailingIcon: FontAwesomeIcons.playCircle,
      beginColor: Color(0xFF49e585),
      endColor: Color(0xFF2be503),
    ));

    return category;
  }
}
