import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:mobile_anw/utils/emoji_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<Case> _myCases = [];
  bool _isLoading = true;
  String? _errorMessage;
  int? _userId; // New variable to store user ID

  @override
  void initState() {
    super.initState();
    _fetchUserIdAndLoadCases();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure _loadCases is called again when re-entering the page
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _fetchUserIdAndLoadCases();
    });
  }

  Future<void> _fetchUserIdAndLoadCases() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');

    setState(() {
      _userId = userId;
    });

    _loadCases();
  }

  Future<void> _loadCases() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      List<Case> myCases = await APIService.getCasesByUser(userId: _userId);
      setState(() {
        _myCases = myCases;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load cases: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('JUSTICASE')),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : _myCases.isEmpty
          ? Center(child: Text('Keine Fälle gefunden'))
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _myCases.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              leading: Icon(
                EmojiHelper.getIndustryIcon(
                    _myCases[index].industry ?? ''),
                size: 30, // Icon size
              ),
              title: Text(_myCases[index].name!),
              subtitle: Text(
                  _myCases[index].companyType ?? 'Kein Unternehmen'),
              onTap: () {
                // Navigate to GroupingPage with the selected case
                context.go(
                  '/case/caseDetails',
                  extra: _myCases[index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
