import 'package:firebase_auth/firebase_auth.dart';

import 'auth_user.dart';

class LoginService {
  final AuthService _authService = AuthService();

  Future<UserCredential?> login(String email, String password) async {
    try {
      return await _authService.login(email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> loginWithGoogle() async {
    try {
      return await _authService.loginWithGoogle();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkIfUserExists(String email) async {
    try {
      return await _authService.checkIfUserExists(email);
    } catch (e) {
      rethrow;
    }
  }
}
