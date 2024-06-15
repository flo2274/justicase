import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/services/api_service.dart';

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

  @override
  void initState() {
    super.initState();
    _loadCases();
  }

  Future<void> _loadCases() async {
    try {
      List<Case> myCases = await APIService.getMyCases();
      print('Loaded cases: $myCases'); // Debugging-Ausgabe der geladenen Fälle
      setState(() {
        _myCases = myCases;
      });
    } catch (e) {
      print(
          'Failed to load cases: $e'); // Fehlerbehandlung und Debugging-Ausgabe
      // Zeigen Sie eine Fehlermeldung an oder führen Sie andere Maßnahmen durch
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('JUSTICASE')),
      ),
      body: ListView.builder(
        itemCount: _myCases.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_myCases[index].name!),
            subtitle: Text(_myCases[index].companyType ?? ''),
            onTap: () {
              context.go(
                '/case/grouping',
                extra: _myCases[index],
              );
            },
          );
        },
      ),
    );
  }
}
