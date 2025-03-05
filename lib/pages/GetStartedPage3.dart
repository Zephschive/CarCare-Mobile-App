import 'package:carcare/pages/GetStartedPage2.dart';
import 'package:carcare/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:carcare/common_widgets/common_widgets.dart';
import 'package:google_fonts/google_fonts.dart'; 

class GetStartedPage3 extends StatelessWidget {
  const GetStartedPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with gradient
          Container(
            decoration: const BoxDecoration(
              gradient: CCcolours.linearColor1,
            ),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50), // Top padding

              // Skip Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GetStartedPage3()));
                      },
                    ),
                   
                  ],
                ),
              ),

              
              const Spacer(),

              // Car Image
              Center(
                child: Image.asset(
                  CarCareImages.White_Car_topview, 
                  width: 350,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20), // Space before text

              // Welcome Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  "Complete Management",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Description Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Track your vehicle’s health, stay on top of important document renewals, and request towing assistance—all in one app.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
              ),

              const Spacer(),
              
              RectangularbuttonWhite(text: "Get Started", onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
              }, Width: ScreenSize.screenWidth(context) * 0.8),

              Spacer()
              
               // Pushes content up
            ],
          ),


        ],
      ),
    );
  }
}


