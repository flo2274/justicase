import 'package:flutter/material.dart';
import 'dart:async';

class ImageSwitcher extends StatefulWidget {
  @override
  _ImageSwitcherState createState() => _ImageSwitcherState();
}

class _ImageSwitcherState extends State<ImageSwitcher> {
  int _imageIndex = 0;
  List<String> _imageUrls = [
    'logo', // Beispiel URL 1
    'https://via.placeholder.com/300/0000FF/808080' // Beispiel URL 2
  ];

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Starte einen Timer, der alle 2 Sekunden das Bild wechselt
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        _imageIndex = (_imageIndex + 1) % _imageUrls.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Timer abbrechen, um Speicherlecks zu vermeiden
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      width: double.infinity,
      height: 200.0,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: Image.network(
          _imageUrls[_imageIndex],
          key: Key(_imageUrls[_imageIndex]), // Verwende Key, um zwischen Bildern zu unterscheiden
          fit: BoxFit.cover,
        ),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}