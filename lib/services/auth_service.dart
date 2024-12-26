import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUp(String email, String password, String username) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      switch (e.code) {
        case 'weak-password':
          throw 'The password provided is too weak';
        case 'email-already-in-use':
          throw 'The account already exists for that email';
        case 'invalid-email':
          throw 'The email address is not valid';
        default:
          throw 'An error occurred during sign up: ${e.message}';
      }
    } catch (e) {
      throw 'An unexpected error occurred';
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw 'No user found for that email';
        case 'wrong-password':
          throw 'Wrong password provided';
        case 'invalid-email':
          throw 'The email address is not valid';
        case 'user-disabled':
          throw 'This user account has been disabled';
        default:
          throw 'An error occurred during sign in: ${e.message}';
      }
    } catch (e) {
      throw 'An unexpected error occurred';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
