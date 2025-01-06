import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String successMessage = '';
  String errorMessage = '';

  Future<void> _updateCredentials() async {
    final newEmail = emailController.text.trim();
    final newPassword = passwordController.text.trim();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Update email jika field email tidak kosong
        if (newEmail.isNotEmpty) {
          await user.verifyBeforeUpdateEmail(newEmail);
          setState(() {
            successMessage = "Account updated successfully!";
          });
        }

        // Update password jika field password tidak kosong
        if (newPassword.isNotEmpty) {
          await user.updatePassword(newPassword);
          setState(() {
            successMessage = "Account updated successfully!";
          });
        }

        // Refresh user token setelah update
        await user.reload();
        FirebaseAuth.instance.currentUser;

        setState(() {
          successMessage = "Account updated successfully!";
          errorMessage = '';
        });
      } catch (e) {
        setState(() {
          errorMessage = "Error: ${e.toString()}";
          successMessage = '';
        });
      }
    } else {
      setState(() {
        errorMessage = "No user is signed in.";
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
            onPressed: _updateCredentials,
            child: const Text("Update"),
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          if (successMessage.isNotEmpty) ...[
            Text(
              successMessage,
              style: const TextStyle(color: Colors.green),
            ),
            const SizedBox(height: 10),
          ],
          if (errorMessage.isNotEmpty) ...[
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
