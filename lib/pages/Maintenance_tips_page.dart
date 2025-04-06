import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carcare/common_widgets/common_widgets.dart';

class MaintenanceTipsPage extends StatefulWidget {
  @override
  State<MaintenanceTipsPage> createState() => _MaintenanceTipsPageState();
}

class _MaintenanceTipsPageState extends State<MaintenanceTipsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); 
  int selectedIndex = 1;

  void onItemSelected(int index) {
    print("Navigating to index: $index");
    setState(() {
      selectedIndex = index;
    });
    print("Updated index: $selectedIndex");
  }

  final List<Map<String, String>> tips = [
    {
      "title": "Check Tire Pressure Monthly",
      "description": "Proper tire pressure improves fuel efficiency and extends tire life. Check your tires at least once a month.",
    },
    {
      "title": "Maintain Your Vehicle Regularly",
      "description": "Ensure your vehicle is in top shape by checking the oil regularly. Follow the manufacturer’s schedule for oil changes.",
    },
    {
      "title": "Check Your Brake Fluid",
      "description": "Make it a habit to inspect your brake fluid levels. If they're low, refill them promptly to ensure your brakes work properly.",
    },
    {
      "title": "Promote Safe Driving",
      "description": "Share your knowledge about vehicle maintenance and encourage others to keep their cars in great condition.",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenuDrawer(selectedIndex: selectedIndex),
      appBar: AppBar(
        title: Text(
          "Maintenance Tips",
          style: GoogleFonts.karla(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); //
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search in service Reminder",
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.tune),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Maintenance Tips List
            Expanded(
              child: ListView.builder(
                itemCount: tips.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        tips[index]["title"]!,
                        style: GoogleFonts.karla(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        tips[index]["description"]!,
                        style: GoogleFonts.karla(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
