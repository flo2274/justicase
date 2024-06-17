import 'package:flutter/material.dart';

class CaseWidget extends StatelessWidget {
  final String companyName;
  final String companyForm;
  final String companyDescription;
  final int currentPeople;
  final int minPeople;
  final String? imageUrl;

  const CaseWidget({
    Key? key,
    required this.companyName,
    required this.companyForm,
    required this.companyDescription,
    required this.currentPeople,
    required this.minPeople,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = (currentPeople / minPeople).clamp(0.0, 1.0);

    return Column(
      children: [
        Divider(thickness: 1),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
                child: imageUrl == null
                    ? Icon(Icons.person, color: Colors.black, size: 30)
                    : null,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      companyForm,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      companyName,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      companyDescription,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '$currentPeople von mind. $minPeople Personen eingetragen',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 4),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}