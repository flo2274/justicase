import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/services/api_service.dart';

import 'case_state.dart';

class CaseNotifier extends StateNotifier<CaseState> {
  CaseNotifier() : super(CaseState(allCases: [], isLoading: true));

  Future<void> getAllCases() async {
    try {
      List<Case> allCases = await APIService.getAllCases();
      state = state.copyWith(allCases: allCases, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Fehler beim Abrufen der Fälle: $e');
      // Hier keine Exception werfen, es sei denn, Sie möchten, dass sie weitergereicht wird
      // throw Exception('Failed to fetch cases: $e');
    }
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
      // Hier keine Exception werfen, es sei denn, Sie möchten, dass sie weitergereicht wird
      // throw Exception('Failed to delete case: $e');
    }
  }

  Future<void> createCaseAndUpdateUserCases(Case newCase) async {
    try {
      final bool success = await APIService.createCase(newCase);
      if (success) {
        await getAllCases(); // Refresh all cases after creation
      } else {
        state = state.copyWith(errorMessage: 'Fehler beim Erstellen des Falls');
        // throw Exception('Failed to create case');
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Fehler beim Erstellen des Falls: $e');
      // throw Exception('Failed to create case: $e');
    }
  }
}

final caseProvider = StateNotifierProvider<CaseNotifier, CaseState>((ref) {
  return CaseNotifier();
});

