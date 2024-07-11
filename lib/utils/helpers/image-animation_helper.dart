import 'package:flutter/material.dart';
import 'dart:async';

class ImageAnimationHelper extends StatefulWidget {
  const ImageAnimationHelper({super.key});

  @override
  _ImageAnimationHelperState createState() => _ImageAnimationHelperState();
}

class _ImageAnimationHelperState extends State<ImageAnimationHelper> {
  int _imageIndex = 0;
  final List<String> _imageAssets = [
    'assets/images/logo_icon02.png',
    'assets/images/logo_icon01.png',
    'assets/images/logo_icon03.png',
    'assets/images/logo_icon04.png',
  ];

  late Timer _timer;
  bool _isLastImage = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: _isLastImage ? 1000 : 500), (timer) {
      setState(() {
        _imageIndex = (_imageIndex + 1) % _imageAssets.length;
        if (_imageIndex == _imageAssets.length - 1) {
          _isLastImage = true;
        } else {
          _isLastImage = false;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      width: double.infinity,
      height: 170.0,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: _isLastImage ? 600 : 800),
        child: Image.asset(
          _imageAssets[_imageIndex],
          key: Key(_imageAssets[_imageIndex]),
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
