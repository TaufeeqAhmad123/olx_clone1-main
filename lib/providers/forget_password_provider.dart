import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }
}
