import 'package:flutter/material.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:mobile_anw/views/widgets/texts/headings/large_heading.dart';
import 'package:mobile_anw/views/widgets/texts/headings/small_heading.dart';
import 'package:mobile_anw/views/widgets/texts/info_text.dart';
import 'package:mobile_anw/data/case_data.dart';
import 'package:mobile_anw/views/widgets/texts/field_text.dart';
import 'package:go_router/go_router.dart';

class CreateCasePage extends StatefulWidget {
  const CreateCasePage({Key? key}) : super(key: key);

  @override
  _CreateCasePageState createState() => _CreateCasePageState();
}

class _CreateCasePageState extends State<CreateCasePage> {
  final _formKey = GlobalKey<FormState>();
  String _yourCaseDescription = '';
  Case _newCase = Case(companyType: '', industry: '');
  bool _isLoading = false;

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
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Center(
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
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 1.5,
            spreadRadius: 0.2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SmallHeading(
            text: 'Unternehmensspezifische Informationen',
          ),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: _newCase.name ?? '',
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
              _newCase.name = value!;
            },
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _newCase.companyType?.isNotEmpty == true ? _newCase.companyType : null,
            hint: const FieldText(text: '*Unternehmensform auswählen'),
            items: CaseData.companyTypes.map((companyType) {
              return DropdownMenuItem(
                value: companyType,
                child: Text(
                  companyType,
                  style: Theme.of(context).textTheme.bodyMedium,),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _newCase.companyType = value ?? ''; // Handle null case
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bitte wählen Sie eine Unternehmensform aus';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _newCase.industry?.isNotEmpty == true ? _newCase.industry : null,
            hint: const FieldText(text: '*Branche auswählen'),
            items: CaseData.industries.map((industry) {
              return DropdownMenuItem(
                value: industry,
                child: Text(
                  industry,
                  style: Theme.of(context).textTheme.bodyMedium,),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _newCase.industry = value ?? ''; // Handle null case
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bitte wählen Sie eine Branche aus';
              }
              return null;
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
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 1.5,
            spreadRadius: 0.2,
            offset: Offset(0, 1),
          ),
        ],
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
    setState(() {
      _isLoading = true;
    });

    try {
      final bool success = await APIService.createCase(_newCase);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fall erfolgreich erstellt'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/case');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fehler beim Erstellen des Falls'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
