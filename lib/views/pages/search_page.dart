import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_anw/utils/text_theme_config.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/views/widgets/sections/all-cases_section.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/case_notifier.dart';
import '../../utils/case_state.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  @override
  void initState() {
    super.initState();
    ref.read(caseProvider.notifier).fetchAllCases();
  }

  @override
  Widget build(BuildContext context) {
    final caseState = ref.watch(caseProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('JUSTICASE'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TypeAheadField<Case>(
                suggestionsCallback: (search) {
                  if (search.isEmpty) {
                    return [];
                  }
                  return caseState.allCases
                      .where((c) => c.name!.toLowerCase().contains(search.toLowerCase()))
                      .toList();
                },
                itemBuilder: (context, Case suggestion) {
                  return ListTile(
                    title: Text(suggestion.name!),
                  );
                },
                onSelected: (Case suggestion) {
                  context.go('/case/caseDetails', extra: suggestion);
                },
                emptyBuilder: (context) {
                  return InkWell(
                    onTap: () {
                      context.go('/case/createCase');
                    },
                    child: const ListTile(
                      title: Text(
                        'Kein Fall gefunden. Erstelle einen neuen Fall',
                        style: MyTextStyles.alertText,
                      ),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AllCasesSection(),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            context.go('/case/createCase');
                          });
                        },
                        icon: Icon(Icons.add),
                        label: Text('Erstelle einen neuen Fall'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}