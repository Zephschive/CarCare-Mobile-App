import 'package:carcare/pages/GetStartedPage2.dart';
import 'package:flutter/material.dart';
import 'package:carcare/common_widgets/common_widgets.dart';
import 'package:google_fonts/google_fonts.dart'; 

class GetStartedPage1 extends StatelessWidget {
  const GetStartedPage1({super.key});

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
                        // Handle back action
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle skip action
                      },
                      child: const Text(
                        "Skip »",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              
              const Spacer(),

              // Car Image
              Center(
                child: Image.asset(
                  CarCareImages.White_Car_Frontview, 
                  width: 250,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20), // Space before text

              // Welcome Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  "Welcome to CarCare",
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
                  "Your All-in-One Vehicle Monitoring Solution. Drive with confidence and convenience, every time.",
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
            child: InkWell(
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>GetStartedPage2() ));
              },
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
                      fontSize: 20, fontWeight: FontWeight.w800
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
class QuarterCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.arcToPoint(Offset(size.width, 0), radius: Radius.circular(size.width));
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
