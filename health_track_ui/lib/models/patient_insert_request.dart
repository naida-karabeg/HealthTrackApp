class PatientInsertRequest {
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String? address;
  final String gender;
  final String? emergencyContact;
  final String? bloodType;
  final String email;
  final String phoneNumber;
  final String userName;
  final bool isActive;

  PatientInsertRequest({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    this.address,
    required this.gender,
    this.emergencyContact,
    this.bloodType,
    required this.email,
    required this.phoneNumber,
    required this.userName,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'address': address,
      'gender': gender,
      'emergencyContact': emergencyContact,
      'bloodType': bloodType,
      'email': email,
      'phoneNumber': phoneNumber,
      'userName': userName,
      'isActive': isActive,
    };
  }
}
