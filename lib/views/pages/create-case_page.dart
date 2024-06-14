import 'package:flutter/material.dart';
import 'package:mobile_anw/views/widgets/texts/headings/large_heading.dart';
import 'package:mobile_anw/views/widgets/texts/headings/small_heading.dart';
import 'package:mobile_anw/views/widgets/texts/info_text.dart';
import 'package:mobile_anw/services/api_service.dart';

class CreateCasePage extends StatefulWidget {
  const CreateCasePage({Key? key}) : super(key: key);

  @override
  _CreateCasePageState createState() => _CreateCasePageState();
}

class _CreateCasePageState extends State<CreateCasePage> {
  final _formKey = GlobalKey<FormState>();
  String _companyName = '';
  String _selectedIndustry = '';
  String _selectedCompanyType = '';
  String _yourCaseDescription = '';

  // Todo make global
  final List<String> _industries = [
    'Technologie',
    'Gesundheit',
    'Bildung',
    'Finanzen',
    'Einzelhandel',
    'Online',
  ];

  final List<String> _companyTypes = [
    'GmbH',
    'AG',
    'Einzelunternehmen',
    'GbR',
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
                  text: 'Neuen Fall erstellen',
                ),
                _buildCompanyInfoBox(),
                _buildCaseInfoBox(),
                const SizedBox(height: 10),
                const InfoText(text: 'Die mit * gekennzeichneten Felder sind Pflichtfelder'),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _createCase();
                      }
                    },
                    child: const Text('Erstellen'),
                  ),
                ),
                const SizedBox(height: 20),
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
        color: Colors.white,
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
              labelText: '*Name des Unternehmens',
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
            value: _selectedCompanyType.isNotEmpty ? _selectedCompanyType : null,
            hint: const Text('*Unternehmensform auswählen'),
            items: _companyTypes.map((companyType) {
              return DropdownMenuItem(
                value: companyType,
                child: Text(companyType),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCompanyType = value!;
              });
            },
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _selectedIndustry.isNotEmpty ? _selectedIndustry : null,
            hint: const Text('*Branche auswählen'),
            items: _industries.map((industry) {
              return DropdownMenuItem(
                value: industry,
                child: Text(industry),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedIndustry = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCaseInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SmallHeading(
            text: 'Ihre Informationen',
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Beschreibung des Falls für das Forum',
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

  void _createCase() async {
    try {
      final bool success = await APIService.createCase(
        _companyName,
        _selectedCompanyType,
        _selectedIndustry,
      );
      if (success) {
        // Case successfully created
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fall erfolgreich erstellt'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Failed to create case
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fehler beim Erstellen des Falls'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Error during API call
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
