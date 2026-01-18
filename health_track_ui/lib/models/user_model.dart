class UserModel {
  final String userId;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String token;
  final DateTime expiresAt;

  UserModel({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.token,
    required this.expiresAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      role: json['role'] ?? '',
      token: json['token'] ?? '',
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'token': token,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  bool get isAdmin => role.toLowerCase() == 'admin';
  bool get isDoctor => role.toLowerCase() == 'doctor';
  bool get isPatient => role.toLowerCase() == 'patient';

  bool get hasDesktopAccess => isAdmin || isDoctor;
  bool get hasMobileAccess => true; // Svi imaju pristup mobilnoj, ali će biti različite funkcionalnosti
}
