import 'package:mobile_anw/models/user.dart';

class UserState {
  final List<User> allUsers; // List of all users
  final List<User> caseUsers; // List of users associated with a specific case
  final bool isLoading;
  final String? errorMessage;

  UserState({
    required this.allUsers,
    required this.isLoading,
    this.errorMessage,
    List<User>? caseUsers,
  }) : caseUsers = caseUsers ?? []; // Initialize caseUsers to an empty list if not provided

  UserState copyWith({
    List<User>? allUsers,
    List<User>? caseUsers,
    bool? isLoading,
    String? errorMessage,
  }) {
    return UserState(
      allUsers: allUsers ?? this.allUsers,
      caseUsers: caseUsers ?? this.caseUsers,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
