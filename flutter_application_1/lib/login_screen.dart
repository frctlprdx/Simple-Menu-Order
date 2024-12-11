import 'package:flutter/material.dart';
import 'package:flutter_application_1/blank_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeDefaultCredentials();
  }

  Future<void> _initializeDefaultCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('email') == null &&
        prefs.getString('password') == null) {
      await prefs.setString('email', 'ivan@gmail.com');
      await prefs.setString('password', 'ivan123');
    }
  }

  Future<void> _login() async {
    final email = emailController.text;
    final password = passwordController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email') ?? '';
    final savedPassword = prefs.getString('password') ?? '';

    if (email == savedEmail && password == savedPassword) {
      await prefs.setBool('isLoggedIn', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Blankscreen()),
      );
    } else {
      setState(() {
        errorMessage = 'Invalid email or password. Please try again.';
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
                labelText: "Email",
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
                labelText: "Password",
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
            child: const Text("Login"),
            onPressed: _login,
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
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
