import 'package:flutter/material.dart';

class BodyText extends StatelessWidget {
  final String text;

  const BodyText({
    Key? key,
    required this.text,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
    );
  }
}