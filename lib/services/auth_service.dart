import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseService _db = DatabaseService();

  Future<void> signUp(String email, String password, String username) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      
      // 保存用户信息到 Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 保存登录状态到 SQLite
      if (userCredential.user != null) {
        await _db.saveUserAuth(userCredential.user!);
      }
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
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // 登录成功后保存用户信息到 SQLite
      if (result.user != null) {
        await _db.saveUserAuth(result.user!);
      }
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
    // 清除本地存储的登录信息
    await _db.clearUserAuth();
  }

  // 检查本地缓存的登录状态
  Future<User?> checkLocalAuth() async {
    // 首先检查 Firebase 当前用户
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      // 更新本地存储
      await _db.saveUserAuth(currentUser);
      return currentUser;
    }

    // 如果 Firebase 没有当前用户，检查本地数据库
    final userData = await _db.getLastUser();
    if (userData != null) {
      try {
        // 尝试重新获取 Firebase 认证状态
        await _auth.signInWithCustomToken(userData['uid']);
        return _auth.currentUser;
      } catch (e) {
        print('Auto login failed: $e');
        await _db.clearUserAuth();
        return null;
      }
    }
    return null;
  }
}
