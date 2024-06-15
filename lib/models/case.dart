import 'user.dart';

class Case {
  final int? id;
  late final String? name;
  late final String? companyType;
  late final String? industry;
  final DateTime? createdAt;
  final List<User>? users; // List of users associated with this case

  Case({
    this.id,
    this.name,
    this.companyType,
    this.industry,
    this.createdAt,
    this.users,
  });

  factory Case.fromJson(Map<String, dynamic> json) {
    List<User>? usersList = [];
    if (json['users'] != null) {
      usersList = List<User>.from(json['users'].map((userJson) => User.fromJson(userJson)));
    }
    return Case(
      id: json['id'],
      name: json['name'],
      companyType: json['companyType'],
      industry: json['industry'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      users: usersList,
    );
  }

  set description(String description) {}

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>>? usersJson = users?.map((u) => u.toJson()).toList();
    return {
      'id': id,
      'name': name,
      'companyType': companyType,
      'industry': industry,
      'createdAt': createdAt?.toIso8601String(),
      'users': usersJson,
    };
  }
}
