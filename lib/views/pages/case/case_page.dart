import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/utils/emoji_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/case_notifier.dart';
import '../../../utils/case_state.dart';

class CasePage extends ConsumerStatefulWidget {
  const CasePage({
    required this.label,
    Key? key,
  }) : super(key: key);

  final String label;

  @override
  _CasePageState createState() => _CasePageState();
}

class _CasePageState extends ConsumerState<CasePage> {
  int? _userId; // Variable to store user ID

  @override
  void initState() {
    super.initState();
    _fetchUserIdAndLoadUserCases();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure _fetchUserIdAndLoadUserCases is called again when re-entering the page
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _fetchUserIdAndLoadUserCases();
    });
  }

  Future<void> _fetchUserIdAndLoadUserCases() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');

    setState(() {
      _userId = userId;
    });

    if (_userId != null) {
      ref.read(caseProvider.notifier).getCasesByUser(_userId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final caseState = ref.watch(caseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('JUSTICASE')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: caseState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : caseState.errorMessage != null
                  ? Center(child: Text(caseState.errorMessage!))
                  : caseState.userCases.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                        'Sie haben sich in keinen Fall eingetragen.'),
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
                          width:
                          MediaQuery.of(context).size.width / 1.5,
                          height: 60,
                          padding: const EdgeInsets.all(16.0),
                          child: const Row(
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
                  await _fetchUserIdAndLoadUserCases();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: caseState.userCases.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          EmojiHelper.getIndustryIcon(
                              caseState.userCases[index].industry ?? ''),
                          size: 30, // Icon size
                        ),
                        title: Text(caseState.userCases[index].name!),
                        subtitle: Text(
                            caseState.userCases[index].companyType ?? 'Kein Unternehmen'),
                        onTap: () {
                          // Navigate to GroupingPage with the selected case
                          context.go(
                            '/case/caseDetails',
                            extra: caseState.userCases[index],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
