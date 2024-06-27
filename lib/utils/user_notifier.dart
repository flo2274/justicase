import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_anw/models/user.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'user_state.dart';

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState(allUsers: [], isLoading: true));

  Future<void> getAllUsers() async {
    try {
      List<User> allUsers = await APIService.getUsers();
      state = state.copyWith(allUsers: allUsers, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      await APIService.deleteUser(userId);
      state = state.copyWith(
        allUsers: state.allUsers.where((user) => user.id != userId).toList(),
      );
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  Future<void> refreshAllUsers() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await getAllUsers();
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
