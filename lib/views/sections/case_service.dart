import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/services/api_config.dart';


Future<List<Case>> fetchCasesWithMostEnrolledUsers() async {
  final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/cases/most-enrolled'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Case.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load suggested cases');
  }
}
