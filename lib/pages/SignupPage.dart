import 'package:carcare/common_widgets/RectangularbuttonColor.dart';
import 'package:carcare/pages/LoginPage.dart';
import 'package:carcare/pages/Navigator_Page.dart';
import 'package:flutter/material.dart';
import 'package:carcare/common_widgets/common_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'HomePage.dart'; // Make sure this exists in your project

class Signuppage extends StatefulWidget {
  Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController GhanaCardController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController = TextEditingController();

  // Loading state indicator
  bool isLoading = false;

  // Function to show snackbar messages
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating, ),
    );
  }
  void showSnackBarError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating,backgroundColor: Colors.red, ),
    );
  }

   void showSnackBarSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating,backgroundColor: Colors.green, ),
    );
  }

  Future<void> signUpUser() async {
    // Basic validations
    if (fullnameController.text.isEmpty ||
        emailController.text.isEmpty ||
        GhanaCardController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmpasswordController.text.isEmpty) {
      showSnackBarError("Please fill in all fields.");
      return;
    }
    if (passwordController.text != confirmpasswordController.text) {
      showSnackBarError("Passwords do not match.");
      return;
    }
    
    // Start loading
    setState(() {
      isLoading = true;
    });

    try {
      // Create the user with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
      User? user = userCredential.user;

      if (user != null) {
        // Save user data to Firestore under the 'users' collection
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          'fullname': fullnameController.text.trim(),
          'email': emailController.text.trim(),
          'GhanaCardNumber': GhanaCardController.text.trim(),
          'uid': user.uid,
        });

        // End loading and show success notification
        setState(() {
          isLoading = false;
        });
        showSnackBarSuccess("Signup successful!");

        // Navigate to the HomePage (ensure HomePage widget is defined)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainNavigatorPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case "email-already-in-use":
          errorMessage = "The email is already in use.";
          break;
        case "invalid-email":
          errorMessage = "The email address is invalid.";
          break;
        case "weak-password":
          errorMessage = "The password is too weak.";
          break;
        default:
          errorMessage = "Signup failed. Please try again.";
      }
      // End loading and show error notification
      setState(() {
        isLoading = false;
      });
      showSnackBarError(errorMessage);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBarError("An error occurred. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CCcolours.whiteBackground2,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Image.asset(CarCareImages.CarCareLogo, height: 80),
                  const SizedBox(height: 20),
                  const Text(
                    "Welcome back!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Enter your details below to Signup",
                    style: GoogleFonts.atkinsonHyperlegible(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  MyInputField(
                    label: "Fullname",
                    hintText: "Enter your name",
                    controller: fullnameController,
                  ),
                  const SizedBox(height: 20),
                  MyInputField(
                    label: "E-mail",
                    hintText: "Enter your email here",
                    controller: emailController,
                  ), MyInputField(
                    label: "Ghana Card",
                    hintText: "Enter your email here",
                    controller: GhanaCardController,
                  ),
                  const SizedBox(height: 20),
                  MyInputField(
                    label: "Password",
                    hintText: "Enter your password",
                    controller: passwordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
                  MyInputField(
                    label: "Confirm Password",
                    hintText: "Confirm your password",
                    controller: confirmpasswordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
                  RectangularbuttonColor(
                    text: "SignUp",
                    Width: ScreenSize.screenWidth(context) * 0.5,
                    BackgroundColor: CCcolours.buttonColor,
                    textColor: CCcolours.whiteTextColor,
                    onPressed: () {
                      signUpUser();
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: "Have an Account? ",
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: "Sign in",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ".....",
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
          // Loading indicator overlay
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
