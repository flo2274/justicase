import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_anw/utils/text_theme_config.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:mobile_anw/views/widgets/cards/middle_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Case> _cases = [];

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchCases();
  }

  void _fetchCases() async {
    try {
      List<Case> cases = await APIService.getAllCases();
      setState(() {
        _cases = cases;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Abrufen der Fälle: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('JUSTICASE')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TypeAheadField<Case>(
                suggestionsCallback: (search) {
                  if (search.isEmpty) {
                    return _cases.where((c) => c.name!.toLowerCase().contains(search.toLowerCase())).toList();
                  }
                  return _cases.where((c) => c.name!.toLowerCase().contains(search.toLowerCase())).toList();
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
                      title: Text('Kein Fall gefunden. Neu erstellen', style: MyTextStyles.alertText,),
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
            SizedBox(height: 600),
            GestureDetector(
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
                        'Neuen Fall erstellen',
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
      ),
    );
  }
}
