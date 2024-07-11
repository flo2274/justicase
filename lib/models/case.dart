class Case {
  final int? id;
  String? name;
  String? companyType;
  String? industry;
  final DateTime? createdAt;
  int userCount;

  Case({
    this.id,
    this.name,
    this.companyType,
    this.industry,
    this.createdAt,
    this.userCount = 0,
  });

  factory Case.fromJson(Map<String, dynamic> json) {
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

