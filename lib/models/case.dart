import 'user.dart';

class Case {
  final int? id;
  String? name;
  String? companyType;
  String? industry;
  final DateTime? createdAt;

  Case({
    this.id,
    this.name,
    this.companyType,
    this.industry,
    this.createdAt,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'companyType': companyType,
      'industry': industry,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

