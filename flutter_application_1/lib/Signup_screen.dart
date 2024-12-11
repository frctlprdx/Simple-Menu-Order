import 'package:flutter/material.dart';
import 'package:flutter_application_1/blank_screen.dart';
import 'package:flutter_application_1/login_screen.dart';

class Signupscreen extends StatelessWidget {
  const Signupscreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController numberController = TextEditingController();
    TextEditingController nameController = TextEditingController();

    return Scaffold(
      backgroundColor: Color(0xFF008080),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              "assets/images/signup.png",
              width: 200.0,
              height: 100.0,
              fit: BoxFit.contain,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Insert Name",
                labelStyle: TextStyle(color: Color(0xFFFF6F61)),
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
              controller: numberController,
              decoration: InputDecoration(
                labelText: "Insert Phone Number",
                labelStyle: TextStyle(color: Color(0xFFFF6F61)),
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
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Insert Email",
                labelStyle: TextStyle(color: Color(0xFFFF6F61)),
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
              obscureText: true, // Hide text for password input
              decoration: InputDecoration(
                labelText: "Insert Password",
                labelStyle: TextStyle(color: Color(0xFFFF6F61)),
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
              backgroundColor: const Color(0xFFFF6F61), // Button text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
            child: const Text("Sign Up"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Blankscreen()),
              );
            },
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text(
                "Already Have Account? Sign In Here",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFFF6F61),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
