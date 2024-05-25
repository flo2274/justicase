import 'package:flutter/material.dart';
import 'package:mobile_anw/views/widgets/texts/headings/large_heading.dart';
import 'package:mobile_anw/views/widgets/texts/headings/small_heading.dart';

class CreateCasePage extends StatefulWidget {
  const CreateCasePage({Key? key}) : super(key: key);

  @override
  _CreateCasePageState createState() => _CreateCasePageState();
}

class _CreateCasePageState extends State<CreateCasePage> {
  final _formKey = GlobalKey<FormState>();
  String _companyName = '';
  String _selectedCategory = '';
  String _selectedForm = '';
  String _yourFirstName = '';
  String _yourLastName = '';
  String _yourCaseDescription = '';

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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LargeHeading(
                  text: 'Neuen Fall für Unternehmen erstellen',
                ),
                _buildCompanyInfoBox(),
                _buildCaseInfoBox(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _createCompany();
                    }
                  },
                  child: const Text('Erstelle Fall'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyInfoBox() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SmallHeading(
            text: 'Unternehmensspezifische Informationen',
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Name des Unternehmens',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bitte geben Sie den Namen des Unternehmens ein';
              }
              return null;
            },
            onSaved: (value) {
              _companyName = value!;
            },
          ),
          const SizedBox(height: 10),
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
          const SizedBox(height: 10),
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
        ],
      ),
    );
  }

  Widget _buildCaseInfoBox() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SmallHeading(
            text: 'Fallspezifische Informationen',
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Ihr Vorname',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bitte geben Sie Ihren Vornamen ein';
              }
              return null;
            },
            onSaved: (value) {
              _yourFirstName = value!;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Ihr Nachname',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bitte geben Sie Ihren Nachnamen ein';
              }
              return null;
            },
            onSaved: (value) {
              _yourLastName = value!;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Beschreibung',
            ),
            maxLines: 3,
            onChanged: (value) {
              setState(() {
                _yourCaseDescription = value;
              });
            },
          ),
        ],
      ),
    );
  }


  void _createCompany() {
    print('Company Name: $_companyName');
    print('Category: $_selectedCategory');
    print('Form: $_selectedForm');
    print('First Name: $_yourFirstName');
    print('Last Name: $_yourLastName');
  }
}
