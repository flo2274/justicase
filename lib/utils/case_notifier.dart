import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../models/case.dart';
import '../services/api_service.dart';
import 'case_state.dart';

class CaseNotifier extends StateNotifier<CaseState> {
  CaseNotifier() : super(CaseState(allCases: [], userCases: [], isLoading: true));

  Future<void> fetchAllCases() async {
    try {
      List<Case> allCases = await APIService.getAllCases();
      state = state.copyWith(allCases: allCases, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Fehler beim Abrufen der Fälle: $e');
    }
  }

  Future<void> fetchUserCases() async {
    try {
      List<Case> userCases = await APIService.getCasesByUser();
      state = state.copyWith(userCases: userCases, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Fehler beim Abrufen der Fälle: $e');
    }
  }

  Future<void> clearErrorMessage() async {
    state = state.copyWith(errorMessage: null);
  }

  Future<void> deleteCase(int caseId) async {
    try {
      await APIService.deleteCase(caseId);
      state = state.copyWith(
        allCases: state.allCases.where((c) => c.id != caseId).toList(),
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Fehler beim Löschen des Falls: $e',
      );
    }
  }

  Future<bool?> createCase(Case newCase) async {
    try {
      final bool success = await APIService.createCase(newCase);
      if (success) {
        return success;
      } else {
        state = state.copyWith(errorMessage: 'Fehler beim Erstellen des Falls');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Fehler beim Erstellen des Falls: $e');
    }
    return null;
  }
}

final caseProvider = StateNotifierProvider<CaseNotifier, CaseState>((ref) {
  return CaseNotifier();
});
