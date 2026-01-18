import '../models/user_model.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import 'base_api_service.dart';

class AuthService extends BaseApiService {
  Future<UserModel> login(LoginRequest request) async {
    return await post<UserModel>(
      '/Auth/login',
      body: request.toJson(),
      fromJson: (json) => UserModel.fromJson(json),
      requiresAuth: false,
    );
  }

  Future<UserModel> register(RegisterRequest request) async {
    return await post<UserModel>(
      '/Auth/register',
      body: request.toJson(),
      fromJson: (json) => UserModel.fromJson(json),
      requiresAuth: false,
    );
  }

  Future<void> logout() async {
    // Ovdje možete dodati poziv backend-u ako imate logout endpoint
    // Za sada samo čistimo lokalno stanje
    return;
  }
}
