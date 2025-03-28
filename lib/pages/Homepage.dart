import 'package:carcare/common_widgets/Navigation_Menu.dart';
import 'package:carcare/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  void onItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open drawer
            },
          ),
        ),
      ),
      drawer: SideMenuDrawer(
        selectedIndex: selectedIndex,
        onItemSelected: onItemSelected,
      ),

      body: SingleChildScrollView( // Makes the entire page scrollable
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    "Welcome Alex!",
                    style: GoogleFonts.karla(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Toyota xxxxx",
                    style: GoogleFonts.karla(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Image.asset(
                      CarCareImages.White_Car_topview, // Replace with actual image
                      height: 230,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Upcoming Reminders Section (Curved White Container)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), // Curved top-left
                  topRight: Radius.circular(30), // Curved top-right
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Upcoming Reminders",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(4, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFFB3B2B2)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: const Icon(Icons.notifications, color: Colors.red)),
                                const SizedBox(height: 5),
                                const Text("Tire Change"),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

            // Daily Tips Section
            // Daily Tips Section (Scrollable)
Container(
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Daily Tips",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      SizedBox(
        height: 250, // Adjust height as needed
        child: ListView(
          physics: const BouncingScrollPhysics(), // Enables smooth scrolling
          children: [
            TipCard("Insurance Renewal", "Your insurance will be..."),
            TipCard("Insurance Renewal Reminder", "Please don't forget to r..."),
            TipCard("Urgent Insurance Renewal", "Consider updating you..."),
            TipCard("Renewal Notification", "Protect yourself and y..."),
            TipCard("Insurance Renewal Alert", "Stay secure and renew..."),
          ],
        ),
      ),
    ],
  ),
),

          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for adding a new reminder
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
