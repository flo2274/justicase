import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_anw/models/case.dart'; // Adjust import path as per your project structure
import 'package:mobile_anw/services/api_service.dart'; // Adjust import path as per your project structure

class CaseState {
  final List<Case> allCases; // List of all cases
  final bool isLoading;
  final String? errorMessage;

  CaseState({
    required this.allCases,
    required this.isLoading,
    this.errorMessage,
  });

  CaseState copyWith({
    List<Case>? allCases,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CaseState(
      allCases: allCases ?? this.allCases,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
