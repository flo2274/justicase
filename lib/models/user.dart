import 'case.dart';

class User {
  final int id;
  final String username;
  final String email;
  final String password;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

/*
class User {
  final int id; // Nicht erforderlich beim Erstellen eines neuen Benutzers
  final String username;
  final String email;
  final String password;
  final DateTime createdAt;
  final List<Case> cases; // Liste von Fällen, denen der Benutzer zugeordnet ist

  User({
    required this.username,
    required this.email,
    required this.password,
    required this.createdAt,
    this.id = 0, // Standardwert 0, wird vom Server zugewiesen
    this.cases = const [], // Standardwert leere Liste
  });

  factory User.fromJson(Map<String, dynamic> json) {
    List<Case> cases = [];
    if (json['cases'] != null) {
      cases = List<Case>.from(json['cases'].map((caseJson) => Case.fromJson(caseJson)));
    }
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      cases: cases,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> casesJson = cases.map((userCase) => userCase.toJson()).toList();
    return {
    'id': id,
    'username': username,
    'email': email,
    'password': password,
    'createdAt': createdAt.toIso8601String(),
    'cases': casesJson,
    };
  }
}
*/