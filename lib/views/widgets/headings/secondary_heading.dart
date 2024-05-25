import 'package:flutter/material.dart';

class SecondaryHeading extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  const SecondaryHeading({
    Key? key,
    required this.text,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.bold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
