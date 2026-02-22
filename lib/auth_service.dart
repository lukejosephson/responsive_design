import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // we keep the instance private so only this class handles auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign in method
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      // handle specific firebase errors (uppe rlevel requirement)
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Password is incorrect.');
      } else {
        throw Exception(e.message ?? 'An unknown error occurred.');
      }
    } catch (e) {
      throw Exception('System error: $e');
    }
  }

  // sign out method
  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase signup errors
      if (e.code == 'email-already-in-use') {
        throw Exception('Email already registered. Please log in.');
      } else if (e.code == 'weak-password') {
        throw Exception('Password is too weak.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Invalid email address.');
      } else {
        throw Exception(e.message ?? 'An unknown error occurred.');
      }
    } catch (e) {
      throw Exception('System error: $e');
    }
  }
}
