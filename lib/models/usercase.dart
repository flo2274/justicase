class UserCase {
  final int userId;
  final int caseId;

  UserCase({
    required this.userId,
    required this.caseId,
  });

  factory UserCase.fromJson(Map<String, dynamic> json) {
    return UserCase(
      userId: json['userId'] as int,
      caseId: json['caseId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'caseId': caseId,
    };
  }} // Todo: delete if unused