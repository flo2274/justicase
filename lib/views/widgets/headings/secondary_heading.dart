import 'package:flutter/material.dart';

class SecondaryHeading extends StatelessWidget {
  final String text;

  const SecondaryHeading({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
