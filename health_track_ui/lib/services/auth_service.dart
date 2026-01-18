import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../utils/api_constants.dart';

class AuthService {
  Future<UserModel> login(LoginRequest request) async {
    try {
      debugPrint('Login URL: ${ApiConstants.loginEndpoint}');
      debugPrint('Request body: ${jsonEncode(request.toJson())}');
      
      final response = await http.post(
        Uri.parse(ApiConstants.loginEndpoint),
        headers: ApiConstants.headers,
        body: jsonEncode(request.toJson()),
      );

      debugPrint('Status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      debugPrint('Response headers: ${response.headers}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw Exception('Server vratio prazan odgovor');
        }
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Neispravni kredencijali');
      } else if (response.statusCode >= 300 && response.statusCode < 400) {
        throw Exception('Server redirect greška (${response.statusCode})');
      } else {
        if (response.body.isEmpty) {
          throw Exception('Greška (${response.statusCode})');
        }
        try {
          final error = jsonDecode(response.body);
          throw Exception(error['message'] ?? 'Greška prilikom prijave');
        } catch (e) {
          throw Exception('Greška prilikom prijave (${response.statusCode})');
        }
      }
    } catch (e) {
      debugPrint('Login error: $e');
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Greška pri povezivanju: $e');
    }
  }

  Future<UserModel> register(RegisterRequest request) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.registerEndpoint),
        headers: ApiConstants.headers,
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        
        // Obrada različitih tipova grešaka
        if (error['errors'] != null) {
          final errors = error['errors'] as List;
          throw Exception(errors.join(', '));
        } else if (error['message'] != null) {
          throw Exception(error['message']);
        } else {
          throw Exception('Greška prilikom registracije');
        }
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Greška pri povezivanju sa serverom: $e');
    }
  }

  Future<void> logout() async {
    // Ovdje možete dodati poziv backend-u ako imate logout endpoint
    // Za sada samo čistimo lokalno stanje
    return;
  }
}
