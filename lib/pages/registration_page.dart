import 'package:flutter/material.dart';

class RegistrationPage extends StatelessWidget {
  @override
  final Key? key;

  const RegistrationPage({this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Just'),
      ),
      body: const Center(
        child: Text(
          'Content of the page',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake_outlined),
            label: '',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false, // Keine ausgewählten Labels anzeigen
        showUnselectedLabels: false, // Keine nicht ausgewählten Labels anzeigen
      ),
    );
  }
}