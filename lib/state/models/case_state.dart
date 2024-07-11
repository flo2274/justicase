import 'package:mobile_anw/models/case.dart';

class CaseState {
  final List<Case> allCases;
  final List<Case> userCases;
  final bool isLoading;
  final String? errorMessage;

  CaseState({
    required this.allCases,
    required this.userCases,
    required this.isLoading,
    this.errorMessage,
  });

  CaseState copyWith({
    List<Case>? allCases,
    List<Case>? userCases,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CaseState(
      allCases: allCases ?? this.allCases,
      userCases: userCases ?? this.userCases,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
