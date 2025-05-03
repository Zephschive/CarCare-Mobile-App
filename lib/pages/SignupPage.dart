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
  // controllers
  final _emailCtrl      = TextEditingController();
  final _ghanaCardCtrl  = TextEditingController();
  final _fullnameCtrl   = TextEditingController();
  final _passwordCtrl   = TextEditingController();
  final _confirmPwdCtrl = TextEditingController();

  bool _isLoading = false;

  // five asset avatars
  final List<String> avatarPaths = [
    'assets/img/avatar1.png',
    'assets/img/avatar2.png',
    'assets/img/avatar3.png',
    'assets/img/avatar4.png',
    'assets/img/avatar5.png',
  ];
  int _selectedAvatar = 0;

  void _showSnack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _signUpUser() async {
    final email = _emailCtrl.text.trim();
    final name  = _fullnameCtrl.text.trim();
    final card  = _ghanaCardCtrl.text.trim();
    final pwd   = _passwordCtrl.text;
    final conf  = _confirmPwdCtrl.text;

    if ([email, name, card, pwd, conf].any((s) => s.isEmpty)) {
      return _showSnack("Please fill in all fields", error: true);
    }
    if (pwd != conf) {
      return _showSnack("Passwords don't match", error: true);
    }

    setState(() => _isLoading = true);
    try {
      var cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pwd);
      var uid = cred.user!.uid;

      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        'fullname': name,
        'email': email,
        'GhanaCardNumber': card,
        'uid': uid,
        'avatarPath': avatarPaths[_selectedAvatar],
      });

      _showSnack("Signup successful!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainNavigatorPage()),
      );
    } on FirebaseAuthException catch (e) {
      var msg = {
        'email-already-in-use': "That email is already in use.",
        'invalid-email': "Invalid email address.",
        'weak-password': "Password is too weak.",
      }[e.code] ?? "Signup failed, please try again.";
      _showSnack(msg, error: true);
    } catch (_) {
      _showSnack("An error occurred.", error: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CCcolours.whiteBackground2,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Image.asset(CarCareImages.CarCareLogo, height: 80),
                const SizedBox(height: 20),
                Text("Create your account",
                    style:
                        const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text("Choose an avatar and enter your details below",
                    style: GoogleFonts.atkinsonHyperlegible(fontSize: 16)),
                const SizedBox(height: 30),

                // AVATAR SELECTION ROW
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
                          backgroundColor:
                              isSel ? Colors.blueAccent : Colors.transparent,
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
                RectangularbuttonColor(
                  text: "Sign Up",
                  Width: MediaQuery.of(context).size.width * 0.6,
                  BackgroundColor: CCcolours.buttonColor,
                  textColor: CCcolours.whiteTextColor,
                  onPressed: _signUpUser,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage())),
                  child: Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                            text: "Sign In",
                            style: const TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),

          // LOADING OVERLAY
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
