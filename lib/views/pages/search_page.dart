import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';

class Company {
  final String name;

  Company({required this.name});
}

class CompanyPage extends StatelessWidget {
  final Company company;

  const CompanyPage({required this.company});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(company.name),
      ),
      body: Center(
        child: Text('Details about ${company.name}'),
      ),
    );
  }
}

class CompanyService {
  static List<Company> find(String search) {
    // Simulated search function
    return _companies
        .where((company) => company.name.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }

  static final List<Company> _companies = [
    Company(name: 'Apple'),
    Company(name: 'Google'),
    Company(name: 'Microsoft'),
    Company(name: 'Amazon'),
    Company(name: 'Facebook'),
    Company(name: 'Tesla'),
    Company(name: 'Twitter'),
    Company(name: 'Netflix'),
    Company(name: 'Disney'),
    Company(name: 'Intel'),
  ];
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
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
            TypeAheadField<Company>(
              suggestionsCallback: (search) => CompanyService.find(search),
              itemBuilder: (context, Company suggestion) {
                return ListTile(
                  title: Text(suggestion.name),
                );
              },
              onSelected: (Company suggestion) {
                Navigator.of(context).push<void>(
                  MaterialPageRoute(
                    builder: (context) => CompanyPage(company: suggestion),
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
                    labelText: 'Search...',
                  ),
                );
              },
            ),
            Center(//Todo: Remove because only temporary to show routing
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Screen',
                      style: Theme.of(context).textTheme.titleLarge),
                  const Padding(padding: EdgeInsets.all(4)),
                  TextButton(
                    onPressed: () => context.go('/case/grouping'), // /case/grouping oder /search/grouping
                    child: const Text('View details'),
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
