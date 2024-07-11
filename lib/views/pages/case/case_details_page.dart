import 'package:flutter/material.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/views/pages/case/case_details_enrolled.dart';
import 'package:mobile_anw/views/pages/case/case_details_forum.dart';

class CaseDetailsPage extends StatelessWidget {
  final Case myCase;

  const CaseDetailsPage({super.key, required this.myCase});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('JUSTICASE'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Forum'),
              Tab(text: 'Eingetragen'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CaseDetailsForum(myCase: myCase),
            CaseDetailsEnrolled(myCase: myCase),
          ],
        ),
      ),
    );
  }
}




