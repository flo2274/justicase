import 'package:flutter/material.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/services/api_service.dart'; // Import your API service class
import 'package:mobile_anw/utils/emoji_helper.dart';
import 'package:go_router/go_router.dart';
import '../pages/case/case-details-enrolled.dart'; // Adjust import path as per your project structure

class CaseItem extends StatefulWidget {
  final Case caseInfo;

  const CaseItem({Key? key, required this.caseInfo}) : super(key: key);

  @override
  _CaseItemState createState() => _CaseItemState();
}

class _CaseItemState extends State<CaseItem> {
  int? _enrolledUsersCount; // Variable to store enrolled users count

  @override
  void initState() {
    super.initState();
    _fetchEnrolledUsersCount(widget.caseInfo.id!);
  }

  Future<void> _fetchEnrolledUsersCount(int caseId) async {
    try {
      int count = await APIService.getEnrolledUsersCount(caseId);
      setState(() {
        _enrolledUsersCount = count;
      });
    } catch (e) {
      print('Error fetching enrolled users count: $e');
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = _enrolledUsersCount != null
        ? _enrolledUsersCount! / 50.0 // Todo: make 50 constant global variable
        : 0.0;

    return Card(
      child: InkWell(
        onTap: () {
          context.go('/case/caseDetails', extra: widget.caseInfo);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Icon(
              EmojiHelper.getIndustryIcon(widget.caseInfo.industry ?? ''),
              size: 30,
            ),
            title: Text(widget.caseInfo.name ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.caseInfo.companyType ?? 'Kein Unternehmen'),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  minHeight: 10,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      progress >= 1.0 ? Colors.green : Colors.blue), // Adjust colors as needed
                ),
              ],
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: 16), // Small arrow icon
          ),
        ),
      ),
    );
  }
}
