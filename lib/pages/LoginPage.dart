import 'package:carcare/common_widgets/RectangularbuttonColor.dart';
import 'package:carcare/pages/SignupPage.dart';
import 'package:flutter/material.dart';
import 'package:carcare/common_widgets/common_widgets.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CCcolours.whiteBackground2,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Image.asset(CarCareImages.CarCareLogo, height: 80),
              const SizedBox(height: 20),
              const Text(
                "Welcome back!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text("Enter your details below to log into your account"),
              const SizedBox(height: 20),
              
              MyInputField(
                label: "E-mail",
                hintText: "Enter your email here",
                controller: emailController,
              ),
              const SizedBox(height: 20),
          
              MyInputField(
                label: "Password",
                hintText: "Enter your password",
                controller: passwordController,
                isPassword: true,
              ),
              
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Forgot your password?"),
                ),
              ),
              
              const SizedBox(height: 20),
          
              RectangularbuttonColor(
                text: "Login",
                Width: ScreenSize.screenWidth(context)*0.5,
                BackgroundColor: CCcolours.buttonColor,
                textColor: CCcolours.whiteTextColor,
                onPressed: () {
                  // Handle login
                },
              ),
          
              const SizedBox(height: 20),
          
              GestureDetector(
                onTap: () {
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Signuppage()));
                },
                child: const Text(
                  "Don't have an account? Create an account!",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
