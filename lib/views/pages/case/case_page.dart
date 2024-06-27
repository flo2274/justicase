import 'package:flutter/material.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/case_item.dart';
import 'case-details-enrolled.dart';

class CasePage extends StatefulWidget {
  const CasePage({
    required this.label,
    Key? key,
  }) : super(key: key);

  final String label;

  @override
  _CasePageState createState() => _CasePageState();
}

class _CasePageState extends State<CasePage> {
  int? _userId; // Variable to store user ID
  List<Case> _userCases = []; // List to store user cases

  @override
  void initState() {
    super.initState();
    _fetchUserCases();
  }

  Future<void> _fetchUserCases() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');

    setState(() {
      _userId = userId;
    });

    if (_userId != null) {
      try {
        List<Case> userCases = await APIService.getCasesByUser(userId: _userId!);
        setState(() {
          _userCases = userCases;
        });
      } catch (e) {
        print('Error fetching user cases: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JUSTICASE'),
        centerTitle: true,
      ),
      body: _userCases.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Sie haben sich in keinen Fall eingetragen.'),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                context.go('/search');
              },
              child: Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: 60,
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(
                        'Suche nach einem Fall',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: () async {
          await _fetchUserCases();
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _userCases.length,
          itemBuilder: (BuildContext context, int index) {
            return CaseItem(caseInfo: _userCases[index]);
          },
        ),
      ),
    );
  }
}
