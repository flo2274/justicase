import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../../../utils/emoji_helper.dart';
import '../../widgets/case_item.dart';
import 'case-details-enrolled.dart';
import 'package:mobile_anw/utils/case_notifier.dart'; // Adjust import path as per your project structure

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
  @override
  void initState() {
    super.initState();
    ref.read(caseProvider.notifier).fetchUserCases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JUSTICASE'),
        centerTitle: true,
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final state = ref.watch(caseProvider);

          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state.userCases.isEmpty) {
            return Center(
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
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(caseProvider.notifier).fetchUserCases(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.userCases.length,
              itemBuilder: (BuildContext context, int index) {
                return CaseItem(caseInfo: state.userCases[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
