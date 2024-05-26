import 'package:flutter/material.dart';

class InfoText extends StatelessWidget {
  final String text;

  const InfoText({
    Key? key,
    required this.text,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: Colors.grey,
      ),
    );
  }
}