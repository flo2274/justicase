import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_anw/state/notifiers/case_notifier.dart';
import '../../../utils/configs/text_theme_config.dart';
import '../../items/long-case_item.dart';

class CasePage extends ConsumerStatefulWidget {
  const CasePage({
    required this.label,
    super.key,
  });

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
        title: const Text('JUSTICASE'),
        centerTitle: true,
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final caseState = ref.watch(caseProvider);

          if (caseState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (caseState.userCases.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Sie haben sich in keinen Fall eingetragen.'),
                  const SizedBox(height: 20),
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Deine Fälle', style: TextThemeConfig.smallHeading),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: caseState.userCases.length,
                      itemBuilder: (BuildContext context, int index) {
                        final caseInfo = caseState.userCases[index];
                        return FutureBuilder<int>(
                          future: APIService.getEnrolledUsersCount(caseInfo.id!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else {
                              caseInfo.userCount = snapshot.data ?? 0;
                              return LongCaseItem(caseInfo: caseInfo);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
