import 'package:flutter/material.dart';
import 'package:mobile_anw/utils/emoji_helper.dart'; // Importiere die EmojiHelper-Klasse

class MiniCard extends StatelessWidget {
  final String name;

  MiniCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0, // Höhe des Schattens
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Optionale Abrundung der Ecken
      ),
      child: Container(
        width: 120,
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 12.0), // Padding für den Inhalt der Karte
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
