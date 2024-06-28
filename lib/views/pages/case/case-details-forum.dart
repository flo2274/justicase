import 'package:flutter/material.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/models/user.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_anw/views/pages/case/case-details-enrolled.dart';
import 'package:mobile_anw/views/pages/case/case-details-forum.dart';
import 'package:mobile_anw/models/case.dart';

class CaseDetailsForum extends StatelessWidget {
  final Case myCase;

  const CaseDetailsForum({Key? key, required this.myCase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.blue[50],
        child: Text(
          'Content of Forum for case: ${myCase.name}',
          style: const TextStyle(
            fontSize: 18.0,
            color: Colors.blue,
            fontFamily: 'PTSerif',
          ),
        ),
      ),
    );
  }
}