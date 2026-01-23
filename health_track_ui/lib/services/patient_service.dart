import '../models/patient_model.dart';
import '../models/patient_insert_request.dart';
import 'base_api_service.dart';

class PatientService extends BaseApiService {
  Future<List<PatientModel>> getPatients() async {
    return get<List<PatientModel>>(
      '/Patient',
      fromJson: (json) {
        final List<dynamic> items = json['resultList'] as List<dynamic>;
        return items.map((item) => PatientModel.fromJson(item)).toList();
      },
    );
  }

  Future<PatientModel> createPatient(PatientInsertRequest request) async {
    return post<PatientModel>(
      '/Patient',
      body: request.toJson(),
      fromJson: (json) => PatientModel.fromJson(json),
    );
  }

  Future<PatientModel> getPatientById(String id) async {
    return get<PatientModel>(
      '/Patient/$id',
      fromJson: (json) => PatientModel.fromJson(json),
    );
  }

  Future<PatientModel> updatePatient(String id, PatientInsertRequest request) async {
    return put<PatientModel>(
      '/Patient/$id',
      body: request.toJson(),
      fromJson: (json) => PatientModel.fromJson(json),
    );
  }

  Future<PatientModel> togglePatientStatus(PatientModel patient) async {
    // Kreiramo request sa svim postojećim podacima, samo mijenjamo isActive
    final request = PatientInsertRequest(
      firstName: patient.firstName,
      lastName: patient.lastName,
      dateOfBirth: patient.dateOfBirth,
      address: patient.address,
      gender: patient.gender ?? 'O',
      emergencyContact: patient.emergencyContact,
      bloodType: patient.bloodType,
      email: patient.email,
      phoneNumber: patient.phoneNumber ?? '',
      userName: patient.email.split('@').first,
      isActive: !patient.isActive, // Toggle status
    );

    return updatePatient(patient.id, request);
  }
}
