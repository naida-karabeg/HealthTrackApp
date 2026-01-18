class RegisterRequest {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String? address;
  final String? phoneNumber;
  final String role;
  
  // Patient specific fields
  final String? gender;
  final String? emergencyContact;
  final String? bloodType;
  
  // Doctor specific fields
  final String? specialization;
  final String? department;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    this.address,
    this.phoneNumber,
    required this.role,
    this.gender,
    this.emergencyContact,
    this.bloodType,
    this.specialization,
    this.department,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'role': role,
    };

    if (address != null) json['address'] = address;
    if (phoneNumber != null) json['phoneNumber'] = phoneNumber;
    
    // Patient fields
    if (gender != null) json['gender'] = gender;
    if (emergencyContact != null) json['emergencyContact'] = emergencyContact;
    if (bloodType != null) json['bloodType'] = bloodType;
    
    // Doctor fields
    if (specialization != null) json['specialization'] = specialization;
    if (department != null) json['department'] = department;

    return json;
  }
}
