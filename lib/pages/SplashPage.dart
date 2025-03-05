import 'package:carcare/pages/GetStartedPage1.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:carcare/common_widgets/common_widgets.dart';

class Splashpage extends StatefulWidget {
  const Splashpage({super.key});

  @override
  State<Splashpage> createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GetStartedPage1()));
   
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Placeholder for the image
                Container(
                  width: 200,
                  height: 200,
               
                  child: Center(
                    child: Image.asset(
                      'assets/img/carcarelogo.png',
                      scale: 1,
                    )
                  ),
                ),
                const SizedBox(height: 15),
                const CircularProgressIndicator(color: CCcolours.chatBubble,
                    strokeWidth: 10,
                  strokeAlign: 1.5,

                ),
              ],
            ),
          ),
          Container(
            child: Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Text(
                'CarCare System © 2024',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
