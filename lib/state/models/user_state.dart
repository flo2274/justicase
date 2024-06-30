import 'package:mobile_anw/models/user.dart';

class UserState {
  final List<User> allUsers; // List of all users
  final bool isLoading;
  final String? errorMessage;

  UserState({
    required this.allUsers,
    required this.isLoading,
    this.errorMessage,
  });

  UserState copyWith({
    List<User>? allUsers,
    bool? isLoading,
    String? errorMessage,
  }){
    return UserState(
      allUsers: allUsers ?? this.allUsers,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
