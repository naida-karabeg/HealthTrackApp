import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_constants.dart';

class BaseApiService {
  static const Duration _timeout = Duration(seconds: 30);
  String? _cachedToken;

  Future<String?> _getToken() async {
    // Vraćamo cached token ako postoji
    if (_cachedToken != null) return _cachedToken;
    
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      final userData = jsonDecode(userJson);
      _cachedToken = userData['token'];
      return _cachedToken;
    }
    return null;
  }

  void clearTokenCache() {
    _cachedToken = null;
  }

  Map<String, String> _getHeaders({bool includeAuth = true, String? token}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (includeAuth && token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  void _logRequest(String method, String url, {Map<String, dynamic>? body}) {
    if (kDebugMode) {
      debugPrint('[$method] $url');
      if (body != null) {
        debugPrint('Body: ${jsonEncode(body)}');
      }
    }
  }

  void _logResponse(http.Response response) {
    if (kDebugMode) {
      debugPrint('Response [${response.statusCode}]: ${response.body}');
    }
  }

  Future<T> get<T>(
    String endpoint, {
    Map<String, String>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token nije pronađen');
    }

    final uri = Uri.parse('${ApiConstants.apiUrl}$endpoint')
        .replace(queryParameters: queryParameters);

    _logRequest('GET', uri.toString());

    final response = await http.get(
      uri,
      headers: _getHeaders(token: token),
    ).timeout(_timeout);

    _logResponse(response);
    return _handleResponse<T>(response, fromJson);
  }

  Future<T> post<T>(
    String endpoint, {
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) fromJson,
    bool requiresAuth = true,
  }) async {
    String? token;
    if (requiresAuth) {
      token = await _getToken();
      if (token == null) {
        throw Exception('Token nije pronađen');
      }
    }

    final uri = Uri.parse('${ApiConstants.apiUrl}$endpoint');
    _logRequest('POST', uri.toString(), body: body);

    final response = await http.post(
      uri,
      headers: _getHeaders(includeAuth: requiresAuth, token: token),
      body: jsonEncode(body),
    ).timeout(_timeout);

    _logResponse(response);
    return _handleResponse<T>(response, fromJson);
  }

  Future<T> put<T>(
    String endpoint, {
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token nije pronađen');
    }

    final uri = Uri.parse('${ApiConstants.apiUrl}$endpoint');
    _logRequest('PUT', uri.toString(), body: body);

    final response = await http.put(
      uri,
      headers: _getHeaders(token: token),
      body: jsonEncode(body),
    ).timeout(_timeout);

    _logResponse(response);
    return _handleResponse<T>(response, fromJson);
  }

  Future<void> delete(String endpoint) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token nije pronađen');
    }

    final uri = Uri.parse('${ApiConstants.apiUrl}$endpoint');
    _logRequest('DELETE', uri.toString());

    final response = await http.delete(
      uri,
      headers: _getHeaders(token: token),
    ).timeout(_timeout);

    _logResponse(response);
    
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Brisanje nije uspjelo: ${response.statusCode}');
    }
  }

  T _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return fromJson(responseData);
    } else if (response.statusCode == 401) {
      clearTokenCache(); // Brišemo cached token
      throw Exception('Niste autorizovani');
    } else if (response.statusCode == 404) {
      throw Exception('Resurs nije pronađen');
    } else {
      // Pokušaj da parsiraš error poruku iz backend-a
      try {
        final errorData = jsonDecode(response.body);
        final message = errorData['message'] ?? errorData['title'];
        if (message != null) {
          throw Exception(message);
        }
      } catch (_) {
        // Ako parsiranje ne uspije, koristi generičku poruku
      }
      throw Exception('Greška: ${response.statusCode}');
    }
  }
}
