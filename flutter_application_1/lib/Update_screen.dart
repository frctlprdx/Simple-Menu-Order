import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/Login_screen.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String successMessage = '';

  Future<void> _updateCredentials() async {
    final newEmail = emailController.text;
    final newPassword = passwordController.text;

    if (newEmail.isNotEmpty && newPassword.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', newEmail);
      await prefs.setString('password', newPassword);

      setState(() {
        successMessage = 'Email and password updated successfully.';
      });

      // Redirect back to LoginScreen after a short delay
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      setState(() {
        successMessage = 'Please fill both fields.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF008080),
      body: Column(
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "New Email",
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
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "New Password",
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
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color(0xFF008080),
              backgroundColor: const Color(0xFFFF6F61),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text("Update"),
            onPressed: _updateCredentials,
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          if (successMessage.isNotEmpty) ...[
            Text(
              successMessage,
              style: const TextStyle(color: Colors.green),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
