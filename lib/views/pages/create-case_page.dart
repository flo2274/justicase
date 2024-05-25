import 'package:flutter/material.dart';

class CreateCasePage extends StatefulWidget {
  const CreateCasePage({Key? key}) : super(key: key);

  @override
  _CreateCasePageState createState() => _CreateCasePageState();
}

class _CreateCasePageState extends State<CreateCasePage> {
  String _companyName = '';
  String _selectedCategory = '';
  String _selectedForm = '';

  final List<String> _categories = [
    'Technologie',
    'Gesundheitswesen',
    'Bildung',
    'Finanzen',
    'Einzelhandel',
  ];

  final List<String> _forms = [
    'GmbH',
    'AG',
    'Einzelunternehmen',
    'Gesellschaft bürgerlichen Rechts (GbR)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('JUSTICASE')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Name des Unternehmens',
              ),
              onChanged: (value) {
                setState(() {
                  _companyName = value;
                });
              },
            ),
            const SizedBox(height: 30),
            DropdownButtonFormField<String>(
              value: _selectedForm.isNotEmpty ? _selectedForm : null,
              hint: const Text('Unternehmensform auswählen'),
              items: _forms.map((form) {
                return DropdownMenuItem(
                  value: form,
                  child: Text(form),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedForm = value!;
                });
              },
            ),
            const SizedBox(height: 30),
            DropdownButtonFormField<String>(
              value: _selectedCategory.isNotEmpty ? _selectedCategory : null,
              hint: const Text('Branche auswählen'),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _createCompany();
              },
              child: const Text('Erstelle Fall'),
            ),
          ],
        ),
      ),
    );
  }

  void _createCompany() {
    // Todo: Implement Logic for creating a company -> use _companyName usw
    print('Company Name: $_companyName');
    print('Category: $_selectedCategory');
    print('Form: $_selectedForm');
  }
}
