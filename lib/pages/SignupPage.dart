import 'package:carcare/common_widgets/RectangularbuttonColor.dart';
import 'package:carcare/pages/LoginPage.dart';
import 'package:carcare/pages/Navigator_Page.dart';
import 'package:flutter/material.dart';
import 'package:carcare/common_widgets/common_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({Key? key}) : super(key: key);

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  //–– Controllers to read input field values
  final _emailCtrl      = TextEditingController();
  final _ghanaCardCtrl  = TextEditingController();
  final _fullnameCtrl   = TextEditingController();
  final _passwordCtrl   = TextEditingController();
  final _confirmPwdCtrl = TextEditingController();

  // Loading flag to show a spinner overlay
  bool _isLoading = false;

  // List of built‐in avatar asset paths
  final List<String> avatarPaths = [
    'assets/img/avatar1.png',
    'assets/img/avatar2.png',
    'assets/img/avatar3.png',
    'assets/img/avatar4.png',
    'assets/img/avatar5.png',
  ];
  // Index of which avatar is currently selected
  int _selectedAvatar = 0;

  /// Helper to show a SnackBar message.
  /// If [error] is true, background is red; otherwise green.
  void _showSnack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: error ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Main signup logic: validates inputs, creates Firebase Auth user,
  /// writes user doc to Firestore, then navigates on success.
  Future<void> _signUpUser() async {
    final email = _emailCtrl.text.trim();
    final name  = _fullnameCtrl.text.trim();
    final card  = _ghanaCardCtrl.text.trim();
    final pwd   = _passwordCtrl.text;
    final conf  = _confirmPwdCtrl.text;

    // 1) Validate required fields
    if ([email, name, card, pwd, conf].any((s) => s.isEmpty)) {
      return _showSnack("Please fill in all fields", error: true);
    }
    // 2) Password confirmation
    if (pwd != conf) {
      return _showSnack("Passwords don't match", error: true);
    }

    // 3) Show loading overlay
    setState(() => _isLoading = true);
    try {
      // 4) Create Firebase Auth user
      var cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pwd);
      var uid = cred.user!.uid;

      // 5) Persist details to Firestore
      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        'fullname': name,
        'email': email,
        'GhanaCardNumber': card,
        'uid': uid,
        'avatarPath': avatarPaths[_selectedAvatar],
      });

      // 6) Success feedback and navigate into app
      _showSnack("Signup successful!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainNavigatorPage()),
      );
    }
    on FirebaseAuthException catch (e) {
      // 7) Catch common auth errors
      var msg = {
        'email-already-in-use': "That email is already in use.",
        'invalid-email':         "Invalid email address.",
        'weak-password':         "Password is too weak.",
      }[e.code] ?? "Signup failed, please try again.";
      _showSnack(msg, error: true);
    }
    catch (_) {
      // 8) Any other error
      _showSnack("An error occurred.", error: true);
    }
    finally {
      // 9) Hide loading overlay
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CCcolours.whiteBackground2,
      body: Stack(
        children: [
          //–– Main scrollable form
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // App logo
                Image.asset(CarCareImages.CarCareLogo, height: 80),
                const SizedBox(height: 20),
                // Page title
                const Text(
                  "Create your account",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
                const SizedBox(height: 10),
                // Subtitle
                Text(
                  "Choose an avatar and enter your details below",
                  style: GoogleFonts.atkinsonHyperlegible(
                    fontSize: 16,
                    color: Colors.grey
                  ),
                ),
                const SizedBox(height: 30),

                //–– Avatar picker row
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: avatarPaths.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (ctx, idx) {
                      final isSel = idx == _selectedAvatar;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedAvatar = idx),
                        child: CircleAvatar(
                          radius: isSel ? 36 : 32,
                          backgroundColor: isSel ? Colors.blueAccent : Colors.transparent,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(avatarPaths[idx]),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),
                //–– Input fields
                MyInputField(
                  label: "Full Name",
                  hintText: "Enter your name",
                  controller: _fullnameCtrl,
                ),
                const SizedBox(height: 16),
                MyInputField(
                  label: "Email",
                  hintText: "Enter your email",
                  controller: _emailCtrl,
                ),
                const SizedBox(height: 16),
                MyInputField(
                  label: "Ghana Card Number",
                  hintText: "GH-123-4567-89",
                  controller: _ghanaCardCtrl,
                ),
                const SizedBox(height: 16),
                MyInputField(
                  label: "Password",
                  hintText: "Enter password",
                  controller: _passwordCtrl,
                  isPassword: true,
                ),
                const SizedBox(height: 16),
                MyInputField(
                  label: "Confirm Password",
                  hintText: "Re-enter password",
                  controller: _confirmPwdCtrl,
                  isPassword: true,
                ),
                const SizedBox(height: 30),

                //–– Signup button
                RectangularbuttonColor(
                  text: "Sign Up",
                  Width: MediaQuery.of(context).size.width * 0.6,
                  BackgroundColor: CCcolours.buttonColor,
                  textColor: CCcolours.whiteTextColor,
                  onPressed: _signUpUser,
                ),
                const SizedBox(height: 16),

                //–– Navigate to login
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage())
                  ),
                  child: Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Sign In",
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),

          //–– Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black45,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
