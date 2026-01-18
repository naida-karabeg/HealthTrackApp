import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/patient_model.dart';
import './../utils/api_constants.dart';

class PatientService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      final userData = jsonDecode(userJson);
      return userData['token'];
    }
    return null;
  }

  Future<List<PatientModel>> getPatients() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token nije pronađen');
      }

      final url = Uri.parse('${ApiConstants.baseUrl}/Patient');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final List<dynamic> items = responseData['resultList'] as List<dynamic>;
        return items.map((json) => PatientModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Niste autorizovani');
      } else {
        throw Exception('Greška pri učitavanju pacijenata: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Greška: $e');
    }
  }
}
