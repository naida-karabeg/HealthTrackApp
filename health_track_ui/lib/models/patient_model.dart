class PatientModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime dateOfBirth;
  final String? address;
  final String? phoneNumber;
  final String? gender;
  final String? emergencyContact;
  final String? bloodType;
  final bool isActive;

  PatientModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dateOfBirth,
    this.address,
    this.phoneNumber,
    this.gender,
    this.emergencyContact,
    this.bloodType,
    required this.isActive,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['patientId']?.toString() ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      emergencyContact: json['emergencyContact'],
      bloodType: json['bloodType'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'address': address,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'emergencyContact': emergencyContact,
      'bloodType': bloodType,
      'isActive': isActive,
    };
  }

  String get fullName => '$firstName $lastName';
  
  String get statusText => isActive ? 'Aktivni' : 'Neaktivni';
}
