import 'package:flutter/material.dart';
import 'package:mobile_anw/views/pages/case_page.dart';
import 'package:mobile_anw/views/pages/forum_page.dart';
import 'package:mobile_anw/views/pages/home_page.dart';
import 'package:mobile_anw/views/pages/person-enrolled_page.dart';
import 'package:mobile_anw/views/pages/search_page.dart';

class ScreenBackground extends StatefulWidget {
  @override
  _ScreenBackgroundState createState() => _ScreenBackgroundState();
}

class _ScreenBackgroundState extends State<ScreenBackground> {
  late PageController _pageController;
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: const <Widget>[
          HomePage(),
          SearchPage(),
          CasePage(),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Theme.of(context).primaryColor,
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
          primaryColor: Theme.of(context).colorScheme.secondary,
          textTheme: Theme.of(context).textTheme.copyWith(
            bodySmall: TextStyle(color: Colors.grey[500]),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '', // Add label text here
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '', // Add label text here
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.balance),
              label: '', // Add label text here
            ),
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }
}
