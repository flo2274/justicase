import 'package:flutter/material.dart';

class FieldText extends StatelessWidget {
  final String text;

  const FieldText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}