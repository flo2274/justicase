import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_anw/utils/text_theme_config.dart';
import 'package:mobile_anw/models/case.dart';

import '../../utils/case_notifier.dart';
import '../../utils/case_state.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {

  @override
  Widget build(BuildContext context) {
    final caseState = ref.watch(caseProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('JUSTICASE'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (caseState.isLoading) ...[
              const Center(child: CircularProgressIndicator())
            ] else if (caseState.errorMessage != null) ...[
              Center(child: Text(caseState.errorMessage!))
            ] else ...[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TypeAheadField<Case>(
                          suggestionsCallback: (search) {
                            if (search.isEmpty) {
                              return caseState.allCases.where((c) => c.name!.toLowerCase().contains(search.toLowerCase())).toList();
                            }
                            return caseState.allCases.where((c) => c.name!.toLowerCase().contains(search.toLowerCase())).toList();
                          },
                          itemBuilder: (context, Case suggestion) {
                            return ListTile(
                              title: Text(suggestion.name!),
                            );
                          },
                          onSelected: (Case suggestion) {
                            // Use goRouter to navigate to the grouping page with case info
                            context.go('/case/caseDetails', extra: suggestion);
                          },
                          emptyBuilder: (context) {
                            return InkWell(
                              onTap: () {
                                context.go('/search/createCase');
                              },
                              child: const ListTile(
                                title: Text('Kein Fall gefunden. Erstelle einen neuen Fall', style: MyTextStyles.alertText,),
                              ),
                            );
                          },
                          builder: (context, controller, focusNode) {
                            return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              autofocus: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: ' Suche nach einem Fall...',
                                prefixIcon: Icon(Icons.search),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    context.go('/search/createCase');
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
                          Icon(Icons.add, color: Colors.blue),
                          SizedBox(width: 10),
                          Text(
                            'Erstelle einen neuen Fall',
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
              ),
            ],
          ],
        ),
      ),
    );
  }
}