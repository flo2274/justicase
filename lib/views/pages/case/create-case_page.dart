import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:mobile_anw/state/notifiers/case_notifier.dart'; // Adjust import path as per your project structure
import 'package:mobile_anw/utils/configs/text_theme_config.dart';
import 'package:go_router/go_router.dart';
import '../../../data/constants/case_data.dart';

class CreateCasePage extends ConsumerStatefulWidget {
  const CreateCasePage({Key? key}) : super(key: key);

  @override
  _CreateCasePageState createState() => _CreateCasePageState();
}

class _CreateCasePageState extends ConsumerState<CreateCasePage> {
  final _formKey = GlobalKey<FormState>();
  String _yourCaseDescription = '';
  Case _newCase = Case(companyType: '', industry: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JUSTICASE'),
        centerTitle: true,
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final caseState = ref.watch(caseProvider);

          if (caseState.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Neuen Fall erstellen',
                          style: TextThemeConfig.largeHeading,
                        ),
                        _buildCompanyInfoBox(),
                        _buildCaseInfoBox(),
                        const SizedBox(height: 10),
                        const Text(
                          'Die mit * gekennzeichneten Felder sind Pflichtfelder',
                          style: TextThemeConfig.infoText,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _createCase(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Erstellen'),
                  ),
                ),
              ),
            ],
          );
        },
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
          Text(
            'Unternehmensspezifische Informationen',
            style: TextThemeConfig.smallHeading,
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
              if (value.length > 50) {
                return 'Der Name des Unternehmens darf maximal 50 Zeichen lang sein';
              }
              return null;
            },
            onSaved: (value) {
              _newCase.name = value!;
            },
            maxLength: 50,
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _newCase.companyType?.isNotEmpty == true
                ? _newCase.companyType
                : null,
            hint: const Text('*Unternehmensform auswählen'),
            items: CaseData.companyTypes.map((companyType) {
              return DropdownMenuItem(
                value: companyType,
                child: Text(
                  companyType,
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _newCase.companyType = value ?? '';
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
            value: _newCase.industry?.isNotEmpty == true
                ? _newCase.industry
                : null,
            hint: const Text('*Branche auswählen'),
            items: CaseData.industries.map((industry) {
              return DropdownMenuItem(
                  value: industry,
                  child: Text(
                    industry,
                  ));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _newCase.industry = value ?? '';
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
          Text(
            'Ihre Informationen',
            style: TextThemeConfig.smallHeading,
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

  void _createCase(BuildContext context) async {
    try {
      await ref.read(caseProvider.notifier).createCase(_newCase);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: const Text('Fall erfolgreich erstellt'),
        backgroundColor: Colors.green,
      ));
      ref.read(caseProvider.notifier).fetchUserCases();
      context.go('/case');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Fehler beim Erstellen des Falls: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
