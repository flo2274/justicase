import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_anw/utils/configs/text_theme_config.dart';
import 'package:mobile_anw/models/case.dart';
import '../../../state/notifiers/case_notifier.dart';
import '../../sections/all-cases_section.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

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
        title: const Text('JUSTICASE'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
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
                            'Keinen Fall gefunden. Erstelle einen neuen Fall',
                            style: TextThemeConfig.alertText,
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
                const AllCasesSection(),
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 50.0,
            right: 50.0,
            child: ElevatedButton.icon(
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.go('/case/createCase');
                });
              },
              icon: const Icon(Icons.add),
              label: const Text(
                'Erstelle einen neuen Fall',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

