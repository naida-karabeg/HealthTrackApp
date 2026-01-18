import '../models/patient_model.dart';
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
}
