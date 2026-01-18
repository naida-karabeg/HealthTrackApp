class ApiConstants {
  // Promijenite ovu URL adresu u zavisnosti od toga gdje vam radi backend
  // Za lokalno testiranje na mobilnom emulatoru: 10.0.2.2
  // Za lokalno testiranje na desktop-u: localhost
  // Za stvarni uređaj: IP adresa vašeg računara
  
  static const String baseUrl = 'http://localhost:5183'; // Backend HTTP port
  static const String apiUrl = '$baseUrl/api';
  
  // Auth endpoints
  static const String loginEndpoint = '$apiUrl/Auth/login';
  static const String registerEndpoint = '$apiUrl/Auth/register';
  
  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  static Map<String, String> headersWithToken(String token) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
}
