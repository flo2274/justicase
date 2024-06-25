import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/services/api_service.dart';

import 'case_state.dart';

class CaseNotifier extends StateNotifier<CaseState> {
  CaseNotifier() : super(CaseState(allCases: [], userCases: [], isLoading: true));

  Future<void> getAllCases() async {
    try {
      List<Case> allCases = await APIService.getAllCases();
      state = state.copyWith(allCases: allCases, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> getCasesByUser(int userId) async {
    try {
      List<Case> userCases = await APIService.getCasesByUser(userId: userId);
      state = state.copyWith(userCases: userCases, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> addUserToCase(int caseId, Case newCase) async {
    try {
      await APIService.addUserToCase(caseId, userId: newCase.id);
      state = state.copyWith(userCases: [...state.userCases, newCase]);
    } catch (e) {
      print('Failed to add user to case: $e');
      throw Exception('Failed to add user to case: $e');
    }
  }

  Future<void> removeUserFromCase(int caseId, Case existingCase) async {
    try {
      await APIService.removeUserFromCase(caseId, userId: existingCase.id);
      state = state.copyWith(userCases: state.userCases.where((c) => c.id != existingCase.id).toList());
    } catch (e) {
      print('Failed to remove user from case: $e');
      throw Exception('Failed to remove user from case: $e');
    }
  }

  Future<void> deleteCase(int caseId) async {
    try {
      await APIService.deleteCase(caseId);
      state = state.copyWith(
        allCases: state.allCases.where((c) => c.id != caseId).toList(),
        userCases: state.userCases.where((c) => c.id != caseId).toList(),
      );
    } catch (e) {
      throw Exception('Failed to delete case: $e');
    }
  }

  Future<void> refreshAllCases() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await getAllCases();
  }

  Future<void> refreshUserCases(int userId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await getCasesByUser(userId);
  }

  Future<void> createCaseAndUpdateUserCases(Case newCase) async {
    try {
      final bool success = await APIService.createCase(newCase);
      if (success) {
        state = state.copyWith(userCases: [...state.userCases, newCase]);
      } else {
        throw Exception('Failed to create case');
      }
    } catch (e) {
      print('Failed to create case: $e');
      throw Exception('Failed to create case: $e');
    }
  }

}

final caseProvider = StateNotifierProvider<CaseNotifier, CaseState>((ref) {
  return CaseNotifier();
});
