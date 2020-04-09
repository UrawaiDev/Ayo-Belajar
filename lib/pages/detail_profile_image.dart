import 'package:flutter/material.dart';

class ProfileImagePage extends StatelessWidget {
  final String imageFileName;

  ProfileImagePage({this.imageFileName});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Container(
            child: Hero(
              child: FadeInImage.assetNetwork(
                fadeInCurve: Curves.easeIn,
                placeholder: 'assets/images/placeholder.gif',
                image: imageFileName,
                fit: BoxFit.cover,
              ),
              tag: imageFileName,
            ),
          ),
        ),
      ),
    );
  }
}
