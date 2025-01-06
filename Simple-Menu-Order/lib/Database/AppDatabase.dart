import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppDatabase {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Register User
  Future<User?> registerUser(String email, String password) async {
    try {
      // Membuat user baru di Firebase Authentication
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Memastikan user berhasil dibuat
      if (result.user != null) {
        // Menggunakan UID sebagai ID dokumen
        final String uid = result.user!.uid;
        final db = FirebaseFirestore.instance;
        final data = {"role": 0};
        await db.collection("users").doc(uid).set(data);
      }

      // Mengembalikan user yang berhasil dibuat
      return result.user;
    } catch (e) {
      print('Register Error: $e');
      return null;
    }
  }

  /// Logout User
  Future<void> logoutUser() async {
    try {
      await _auth.signOut();
      print('User logged out successfully');
    } catch (e) {
      print('Logout Error: $e');
    }
  }

  /// Check User Login State
  User? get currentUser {
    return _auth.currentUser;
  }


}
