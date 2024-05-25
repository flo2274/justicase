import 'package:flutter/material.dart';

class LargeHeading extends StatelessWidget {
  final String text;

  const LargeHeading({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.normal,
      ),
    );
  }
}

