// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../components/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child("Users");
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }

  Future<UserCredential?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        return userCredential;
      }
    } catch (e) {
      print("Google Sign-In error: $e");
    }
    return null;
  }

  Future<bool> checkIfUserExists(String email) async {
    DataSnapshot dataSnapshot;
    try {
      dataSnapshot = await _dbRef
          .orderByChild("email")
          .equalTo(email)
          .once()
          .then((event) {
        return event.snapshot;
      });
    } catch (error) {
      print("Error fetching data: $error");
      return false;
    }
    Object? values = dataSnapshot.value;
    return values != null;
  }

  Future<UserCredential?> register(
      String email, String password, String username) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        await user.sendEmailVerification();
        UserDetail userDetail = UserDetail(
          uid: user.uid,
          email: email,
          name: username,
        );
        await _dbRef.child(user.uid).set(userDetail.toMap());
      }
      return userCredential;
    } catch (e) {
      print("Registration error: $e");
      return null;
    }
  }
}
