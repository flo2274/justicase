import 'user.dart';

class Case {
  final int id;
  final String name;
  final String? companyType;
  final String? industry;
  final DateTime createdAt;
  final List<User> users; // Liste von Benutzern, die diesem Fall zugeordnet sind

  Case({
    required this.id,
    required this.name,
    required this.companyType,
    required this.industry,
    required this.createdAt,
    required this.users,
  });

  factory Case.fromJson(Map<String, dynamic> json) {
    List<User> users = [];
    if (json['users'] != null) {
      users = List<User>.from(json['users'].map((userJson) => User.fromJson(userJson)));
    }
    return Case(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      companyType: json['companyType'],
      industry: json['industry'],
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
      users: users,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> usersJson = users.map((user) => user.toJson()).toList();
    return {
      'id': id,
      'name': name,
      'companyType': companyType,
      'industry': industry,
      'createdAt': createdAt.toIso8601String(),
      'users': usersJson,
    };
  }
}
