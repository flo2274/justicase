import 'package:flutter/material.dart';

class SmallHeading extends StatelessWidget {
  final String text;

  const SmallHeading({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
