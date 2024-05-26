import 'package:flutter/material.dart';

class AlertText extends StatelessWidget {
  final String text;

  const AlertText({
    Key? key,
    required this.text,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.normal,
        color: Colors.red,
      ),
    );
  }
}
