import 'package:carcare/common_widgets/RectangularbuttonColor.dart';
import 'package:carcare/pages/Homepage.dart';
import 'package:carcare/pages/Navigator_Page.dart';
import 'package:carcare/pages/SignupPage.dart';
import 'package:carcare/theme_provider/themeprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carcare/common_widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Form Key
  bool _isLoading = false; // Loading state

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      
      // Show success message & navigate
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: const Text("Login successful!", style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to home page (replace with your actual home page)
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigatorPage()));

    } on FirebaseAuthException catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Login failed"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
      bool isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Scaffold(
      backgroundColor: CCcolours.whiteBackground2,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Assign form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                Image.asset(CarCareImages.CarCareLogo, height: 80),
                const SizedBox(height: 20),
                 Text(
                  "Welcome back!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.black :Colors.black ),
                ),
                const SizedBox(height: 10),
                 Text("Enter your details below to log into your account" , style: TextStyle(color: isDark ? Colors.grey :Colors.grey ),),
                const SizedBox(height: 20),

                // Email Field
                MyInputField(
                  label: "E-mail",
                  hintText: "Enter your email here",
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password Field
                MyInputField(
                  label: "Password",
                  hintText: "Enter your password",
                  controller: passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),

                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      // Handle forgot password
                    },
                    child: Text("Forgot your password?" ,style: TextStyle(color: isDark ? Colors.purple :Colors.purple),),
                  ),
                ),

                const SizedBox(height: 20),

                // Login Button
                _isLoading
                    ? const CircularProgressIndicator()
                    : RectangularbuttonColor(
                        text: "Login",
                        Width: ScreenSize.screenWidth(context) * 0.5,
                        BackgroundColor: CCcolours.buttonColor,
                        textColor: CCcolours.whiteTextColor,
                        onPressed: _login, // Call login function
                      ),

                const SizedBox(height: 20),

                // Sign Up Link
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Signuppage()),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Create an account!",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
