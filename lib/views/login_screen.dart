import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// A screen that allows users to authenticate using their email and password.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Whether the "Remember Me" checkbox is checked.
  bool isChecked = false;

  /// Controllers for handling email and password input.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// Indicates whether an authentication request is currently in progress.
  bool isLoading = false;

  /// Attempts to sign in the user with the provided email and password.
  /// 
  /// Navigates to the main navigation screen on success or shows an error message on failure.
  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/bottom_nav');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Failed: $e")),
        );
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Login",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// Branding or profile placeholder image.
            Center(
              child: Image.asset(
                "lib/assets/profile.png",
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 20),

            /// Email input field.
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Password input field.
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Login button or loading indicator.
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
            
            const SizedBox(height: 10),

            /// Link to navigate to the registration screen.
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register_screen');
              },
              child: const Text(
                "Create New Account",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
