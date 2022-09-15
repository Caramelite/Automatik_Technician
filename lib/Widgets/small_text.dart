import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  double height;

  SmallText({Key? key,
    this.color = Colors.black,
    required this.text,
    this.size = 13,
    this.height = 1.2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color:  color,
        fontSize: size,
        fontWeight: FontWeight.w400,
        height: height,
      ),
    );
  }
}