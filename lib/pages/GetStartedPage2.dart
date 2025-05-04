import 'package:carcare/pages/GetStartedPage1.dart';
import 'package:carcare/pages/GetStartedPage3.dart';
import 'package:flutter/material.dart';
import 'package:carcare/common_widgets/common_widgets.dart';
import 'package:google_fonts/google_fonts.dart'; 

class GetStartedPage2 extends StatelessWidget {
  const GetStartedPage2({super.key});

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
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> GetStartedPage1()));
                      },
                    ),
                     TextButton(onPressed: 
                  (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> GetStartedPage3()));
                  }, child: Row(
                    children: [
                      Text("Skip", style: GoogleFonts.karla(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: CCcolours.whiteTextColor
                      ),),
                      Icon(Icons.keyboard_double_arrow_right,
                      color: CCcolours.whiteTextColor,)
                    ],
                  ),
                  style: ButtonStyle(
                    padding:WidgetStatePropertyAll(EdgeInsets.all(10)),
                    shape: WidgetStatePropertyAll(OvalBorder())
                  ),
                  
                  
                    ),
                  ],
                ),
              ),

              
              const Spacer(),

              // Car Image
              Center(
                child: Image.asset(
                  CarCareImages.White_Car_turned_back, 
                  width: 350,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20), // Space before text

              // Welcome Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  "Smart Maintenance",
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
                  "Stay on top of your car's health with real-time diagnostics, personalized maintenance tips, and service reminders.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
              ),

              const Spacer(), // Pushes content up
            ],
          ),

          // Next Button (Bottom Right)
          Positioned(
            bottom: 0,
            right: 0,
            child: InkResponse(
              onTap: (){
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>GetStartedPage3() ));
              },
              radius: 30,
              hoverColor: Colors.lightBlue,
              child: ClipPath(
                clipper: QuarterCircleClipper(),
                child: Container(
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                    child: Text("Next", style: GoogleFonts.karla(
                      fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black
                    ),),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Clipper for Quarter Circle

