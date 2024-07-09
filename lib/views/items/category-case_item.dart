import 'package:flutter/material.dart';
import 'package:mobile_anw/utils/helpers/emoji_helper.dart';

class CategoryCaseItem extends StatelessWidget {
  final String name;

CategoryCaseItem({required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: 120,
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 13.0),
              textAlign: TextAlign.start,
            ),
            Icon(
              EmojiHelper.getIndustryIcon(name),
              size: 18.0,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
