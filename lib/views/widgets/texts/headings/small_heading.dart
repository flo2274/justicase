import 'package:flutter/material.dart';

class SmallHeading extends StatelessWidget {
  final String text;

  const SmallHeading({
    Key? key,
    required this.text,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
    );
  }
}
