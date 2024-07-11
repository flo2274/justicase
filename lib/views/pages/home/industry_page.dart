import 'package:flutter/material.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/services/api_service.dart';
import '../../../utils/configs/text_theme_config.dart';
import '../../items/long_case_item.dart';

class IndustryCasesPage extends StatefulWidget {
  final String industry;

  const IndustryCasesPage({super.key, required this.industry});

  @override
  IndustryCasesPageState createState() => IndustryCasesPageState();
}

class IndustryCasesPageState extends State<IndustryCasesPage> {
  List<Case> cases = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchCasesByIndustry();
  }

  Future<void> fetchCasesByIndustry() async {
    try {
      var fetchedCases = await APIService.getCasesByIndustry(widget.industry);
      List<Case> updatedCases = [];
      for (var caseJson in fetchedCases) {
        Case caseInfo = Case.fromJson(caseJson);
        int enrolledUsersCount = await APIService.getEnrolledUsersCount(caseInfo.id!);
        caseInfo.userCount = enrolledUsersCount;
        updatedCases.add(caseInfo);
      }
      setState(() {
        cases = updatedCases;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load cases';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JUSTICASE'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text(error))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.industry,
              style: TextThemeConfig.smallHeading,
            ),
            const SizedBox(height: 5.0),
            Expanded(
              child: ListView.builder(
                itemCount: cases.length,
                itemBuilder: (context, index) {
                  var caseInfo = cases[index];
                  return LongCaseItem(caseInfo: caseInfo);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
