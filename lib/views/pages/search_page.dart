import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_anw/views/widgets/texts/alert_text.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/services/api_service.dart';

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
                  context.go('/case/grouping', extra: suggestion);
                },
                emptyBuilder: (context) {
                  return InkWell(
                    onTap: () {
                      context.go('/search/createCase');
                    },
                    child: const ListTile(
                      title: AlertText(text: 'Kein Fall gefunden. Neu erstellen'),
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
                      labelText: ' Search...',
                    ),
                  );
                },
              ),
            ),
          ],
      ),
    ),
    );
  }
}
