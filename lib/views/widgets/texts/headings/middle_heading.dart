import 'package:flutter/material.dart';

class MiddleHeading extends StatelessWidget {
  final String text;

  const MiddleHeading({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}