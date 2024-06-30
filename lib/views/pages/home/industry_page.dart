import 'package:flutter/material.dart';

import '../../../services/api_service.dart';

class IndustryCasesPage extends StatefulWidget {
  final String industry;

  IndustryCasesPage({required this.industry});

  @override
  _IndustryCasesPageState createState() => _IndustryCasesPageState();
}

class _IndustryCasesPageState extends State<IndustryCasesPage> {
  List<dynamic> cases = [];
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
      setState(() {
        cases = fetchedCases;
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
        title: Text('Cases by Industry: ${widget.industry}'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text(error))
          : ListView.builder(
        itemCount: cases.length,
        itemBuilder: (context, index) {
          var caseItem = cases[index];
          return ListTile(
            title: Text(caseItem['name']), // Adjust based on your case object structure
            subtitle: Text(caseItem['companyType']), // Adjust based on your case object structure
            // Add more widgets to display other case details as needed
          );
        },
      ),
    );
  }
}
