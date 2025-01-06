import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Views/blank_screen.dart';
import 'package:flutter_application_1/AuthenticationViews/signup_screen.dart';
import 'package:flutter_application_1/Views/input_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = '';

  Future<void> _loginUser(String email, String password) async {
    try {
      // Login menggunakan Firebase Authentication
      UserCredential result =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Pastikan user berhasil login
      if (result.user != null) {
        final userId = result.user!.uid; // Ambil userId dari Firebase Auth
        final usersCollection = FirebaseFirestore.instance.collection('users');
        final userDoc = await usersCollection.doc(userId).get();

        if (userDoc.exists) {
          final role = userDoc['role'] as int;

          // Navigasi berdasarkan role
          if (role == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MenuScreen()),
            );
          } else if (role == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const InputScreen()),
            );
          } else {
            // Role tidak valid
            setState(() {
              errorMessage = 'Invalid role detected. Please contact support.';
            });
          }
        } else {
          // Pengguna tidak ditemukan di Firestore
          setState(() {
            errorMessage = 'User not found in database!';
          });
        }
      }
    } catch (e) {
      // Menangani error saat login
      setState(() {
        errorMessage = 'Login failed: ${e.toString()}';
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // User canceled the sign-in
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      await _auth.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MenuScreen()),
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Google Sign-In failed: ${e.toString()}';
      });
    }
  }

  void _navigateToSignup() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Signupscreen()),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Color(0xFFFF6F61)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: const BorderSide(color: Color(0xFFFF6F61)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: const BorderSide(color: Color(0xFFFF6F61)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: const BorderSide(color: Color(0xFFFF6F61)),
          ),
        ),
        style: const TextStyle(color: Color(0xFFFF6F61)),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $labelText';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF008080),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/welcome.png",
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                  _buildTextField(
                    labelText: "Email",
                    controller: emailController,
                  ),
                  _buildTextField(
                    labelText: "Password",
                    controller: passwordController,
                    isPassword: true,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFF008080),
                      backgroundColor: const Color(0xFFFF6F61),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();
                        _loginUser(email, password);
                      }
                    },
                    child: const Text("Login"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFF008080),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: _navigateToSignup,
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Color(0xFFFF6F61)),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF008080),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: _signInWithGoogle,
                    child: const Text("Login with Google"),
                  ),
                  if (errorMessage.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
