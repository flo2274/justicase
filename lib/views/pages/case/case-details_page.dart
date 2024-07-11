import 'package:flutter/material.dart';

import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/models/user.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_anw/views/pages/case/case-details-enrolled.dart';
import 'package:mobile_anw/views/pages/case/case-details-forum.dart';

class CaseDetailsPage extends StatelessWidget {
  final Case myCase;

  const CaseDetailsPage({Key? key, required this.myCase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('JUSTICASE'),
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




