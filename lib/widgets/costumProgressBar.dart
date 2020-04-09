import 'package:flutter/material.dart';

class CostumProgressBar extends StatelessWidget {
  final double width;
  final int currentValue;
  final int totalValue;

  CostumProgressBar({this.width, this.currentValue, this.totalValue});

  @override
  Widget build(BuildContext context) {
    double ratio = currentValue / totalValue;
    return Stack(
      children: <Widget>[
        Container(
          width: width,
          height: 13,
          color: Colors.grey,
        ),
        Material(
          elevation: 4,
          child: AnimatedContainer(
            width: width * ratio,
            height: 13,
            color: (ratio) < 0.3
                ? Colors.red[300]
                : (ratio) <= 0.5 ? Colors.yellow[300] : Colors.lightBlueAccent,
            duration: Duration(milliseconds: 300),
          ),
        )
      ],
    );
  }
}
