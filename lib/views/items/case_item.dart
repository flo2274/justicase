import 'package:flutter/material.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/services/api_service.dart'; // Import your API service class
import 'package:mobile_anw/utils/helpers/emoji_helper.dart';
import 'package:go_router/go_router.dart';

class CaseItem extends StatefulWidget {
  final Case caseInfo;

  const CaseItem({Key? key, required this.caseInfo}) : super(key: key);

  @override
  _CaseItemState createState() => _CaseItemState();
}

class _CaseItemState extends State<CaseItem> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double progress = widget.caseInfo.userCount != null
        ? widget.caseInfo.userCount / 50.0 // Todo: make 50 constant global variable
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
              color: Colors.blue,
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
