import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carcare/common_widgets/common_widgets.dart';
import 'package:carcare/common_widgets/RectangularbuttonColor.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _securityAnswerController = TextEditingController();
  bool _isLoading = false;

  void _showSnack(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _sendPasswordReset() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showSnack("Please enter your email", error: true);
      return;
    }

    setState(() => _isLoading = true);

  


    try {
      // Check if the account exists
      final userQuery = await FirebaseFirestore.instance
    .collection('users')
    .where('email', isEqualTo: email)
    .limit(1)
    .get();

      if (userQuery.docs.isEmpty) {
      _showSnack("Account Not found", error: true);
        return;
        }

    
      

      // Count number of cars (or 0 if field doesn't exist)
      final userData = userQuery.docs.first.data();
      final carsArray = userData['cars'] as List<dynamic>?; 
      final int numberOfCars = carsArray?.length ?? 0;

      // Show security question dialog
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Security Question"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("How many cars do you have?"),
              const SizedBox(height: 10),
              TextField(
                controller: _securityAnswerController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "Enter number"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final enteredAnswer = int.tryParse(_securityAnswerController.text.trim());
                Navigator.pop(context);

                if (enteredAnswer == numberOfCars) {
                  FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                  _showSnack("Password reset link sent. Check your inbox.");
                } else {
                  _showSnack("Incorrect answer", error: true);
                }
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      _showSnack(e.message ?? "Something went wrong", error: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CCcolours.whiteBackground2,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Forgot Password",
          style: TextStyle(color: CCcolours.whiteTextColor, fontWeight: FontWeight.w500),
        ),
        backgroundColor: CCcolours.buttonColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                "Enter your email to receive a password reset link",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              MyInputField(
                label: "Email",
                hintText: "Enter your email",
                controller: _emailController,
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : RectangularbuttonColor(
                      text: "Send Reset Link",
                      Width: MediaQuery.of(context).size.width * 0.6,
                      BackgroundColor: CCcolours.buttonColor,
                      textColor: CCcolours.whiteTextColor,
                      onPressed: _sendPasswordReset,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
