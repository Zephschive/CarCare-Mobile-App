// Import statements for required packages and modules
import 'package:carcare/common_widgets/Navigation_Menu.dart'; // Custom side menu drawer widget
import 'package:carcare/theme_provider/themeprovider.dart';   // Theme provider for light/dark mode
import 'package:flutter/material.dart';                       // Flutter UI toolkit
import 'package:google_fonts/google_fonts.dart';             // Google Fonts for custom typography
import 'package:provider/provider.dart';                      // Provider for state management
class MaintenanceTipsPage extends StatefulWidget {
  @override
  State<MaintenanceTipsPage> createState() => _MaintenanceTipsPageState();
}

class _MaintenanceTipsPageState extends State<MaintenanceTipsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedIndex = 1;

  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = 'All';

 final List<Map<String, String>> allTips = [
  // Tires
  {"title": "Rotate Tires", "description": "Rotate every 5,000–7,500 miles to promote even wear.", "category": "Tires"},
  {"title": "Check Tire Pressure", "description": "Monthly tire pressure checks improve safety and mileage.", "category": "Tires"},
  {"title": "Inspect Tread Depth", "description": "Use a tread gauge to avoid driving on bald tires.", "category": "Tires"},
  {"title": "Look for Uneven Wear", "description": "Uneven wear can indicate alignment or suspension issues.", "category": "Tires"},
  {"title": "Keep Tires Aligned", "description": "Proper alignment prevents premature wear.", "category": "Tires"},

  // Fluids
  {"title": "Check Oil Level", "description": "Monitor engine oil weekly and change as recommended.", "category": "Fluids"},
  {"title": "Change Engine Oil", "description": "Change oil every 3,000–7,500 miles based on your vehicle.", "category": "Fluids"},
  {"title": "Inspect Coolant", "description": "Ensure coolant is at proper level and not expired.", "category": "Fluids"},
  {"title": "Top up Brake Fluid", "description": "Refill if low; leaking brake fluid is dangerous.", "category": "Fluids"},
  {"title": "Replace Transmission Fluid", "description": "Follow manufacturer schedule for transmission fluid changes.", "category": "Fluids"},
  {"title": "Use Proper Washer Fluid", "description": "Windshield washer fluid won’t freeze or streak.", "category": "Fluids"},

  // Brakes
  {"title": "Check Brake Pads", "description": "Replace worn pads to avoid damaging the rotors.", "category": "Brakes"},
  {"title": "Test Brake Response", "description": "Spongy brakes may signal air or leaks.", "category": "Brakes"},
  {"title": "Inspect Brake Lines", "description": "Look for leaks or corrosion in brake lines.", "category": "Brakes"},
  {"title": "Listen for Grinding", "description": "Grinding when braking indicates worn discs or pads.", "category": "Brakes"},
  {"title": "Monitor Brake Fluid Clarity", "description": "Dark fluid may contain moisture; replace if needed.", "category": "Brakes"},

  // Engine
  {"title": "Replace Air Filter", "description": "Do this annually or every 12,000 miles.", "category": "Engine"},
  {"title": "Listen for Engine Knocks", "description": "Unusual knocking sounds should be diagnosed immediately.", "category": "Engine"},
  {"title": "Check for Oil Leaks", "description": "Look under the engine for fresh oil spots.", "category": "Engine"},
  {"title": "Monitor Engine Temp", "description": "Watch gauge for overheating.", "category": "Engine"},
  {"title": "Replace Spark Plugs", "description": "Change per manufacturer schedule for efficiency.", "category": "Engine"},

  // General
  {"title": "Wash Car Regularly", "description": "Removes dirt and prevents paint damage.", "category": "General"},
  {"title": "Wax Every 3 Months", "description": "Protects paint and adds shine.", "category": "General"},
  {"title": "Keep Maintenance Records", "description": "Track services for resale value.", "category": "General"},
  {"title": "Drive Smoothly", "description": "Gentle acceleration extends component life.", "category": "General"},
  {"title": "Park in Shade", "description": "Reduces sun damage to interior and paint.", "category": "General"},

  // Lights
  {"title": "Test Headlights Monthly", "description": "Ensure proper visibility at night.", "category": "Lights"},
  {"title": "Replace Dim Bulbs", "description": "Maintains even lighting.", "category": "Lights"},
  {"title": "Clean Headlight Covers", "description": "Removes haze for better output.", "category": "Lights"},
  {"title": "Check Brake Lights", "description": "Ensures safety signals to drivers behind.", "category": "Lights"},
  {"title": "Inspect Dashboard Lights", "description": "Watch for warning indicator failures.", "category": "Lights"},

  // Suspension
  {"title": "Inspect Shocks & Struts", "description": "Replace if leaking or damaged.", "category": "Suspension"},
  {"title": "Listen for Clunks", "description": "Noises over bumps indicate wear.", "category": "Suspension"},
  {"title": "Test for Excessive Bounce", "description": "Push down corner; car should settle quickly.", "category": "Suspension"},
  {"title": "Check Bushings", "description": "Worn bushings lead to poor handling.", "category": "Suspension"},
  {"title": "Look for Leaks", "description": "Fluid on shocks means replacement needed.", "category": "Suspension"},

  // AC
  {"title": "Run AC Year-Round", "description": "Keeps seals lubricated even in winter.", "category": "AC"},
  {"title": "Replace Cabin Filter", "description": "Improves air quality and flow.", "category": "AC"},
  {"title": "Check Refrigerant", "description": "Low charge reduces cooling efficiency.", "category": "AC"},
  {"title": "Listen for Compressor Noise", "description": "Grinding may indicate failure.", "category": "AC"},
  {"title": "Ensure Even Airflow", "description": "Blocked vents reduce performance.", "category": "AC"},

  // Wipers
  {"title": "Replace Blades Annually", "description": "Prevents streaking and noise.", "category": "Wipers"},
  {"title": "Clean Blades Weekly", "description": "Wipes away dirt that causes wear.", "category": "Wipers"},
  {"title": "Use Washer Fluid", "description": "Cleaner than plain water.", "category": "Wipers"},
  {"title": "Check Blade Contact", "description": "Ensure full windshield coverage.", "category": "Wipers"},
  {"title": "Avoid Dry Wiping", "description": "Damages both blades and glass.", "category": "Wipers"},

  // Battery
  {"title": "Clean Terminals Biannually", "description": "Prevents corrosion build-up.", "category": "Battery"},
  {"title": "Test Voltage Monthly", "description": "Ensures healthy starting power.", "category": "Battery"},
  {"title": "Replace Every 3–5 Years", "description": "Avoid unexpected failures.", "category": "Battery"},
  {"title": "Secure Battery Mount", "description": "Prevents vibration damage.", "category": "Battery"},
  {"title": "Don’t Drain Battery", "description": "Turn off lights and accessories when parked.", "category": "Battery"},

  // Transmission
  {"title": "Flush Transmission Fluid", "description": "As per schedule to extend life.", "category": "Transmission"},
  {"title": "Monitor Shift Quality", "description": "Delayed shifts can signal issues.", "category": "Transmission"},
  {"title": "Avoid Towing in Overdrive", "description": "Prevents overheating transmission.", "category": "Transmission"},
  {"title": "Check for Leaks", "description": "Red fluid under car indicates leak.", "category": "Transmission"},
  {"title": "Use Correct Fluid", "description": "Manufacturer spec is critical.", "category": "Transmission"},

  // Steering
  {"title": "Check Power Fluid", "description": "Top off if low to prevent pump wear.", "category": "Steering"},
  {"title": "Listen for Whines", "description": "Indicates low steering fluid or pump problem.", "category": "Steering"},
  {"title": "Inspect Tie Rods", "description": "Worn rods cause loose steering.", "category": "Steering"},
  {"title": "Get Wheel Alignment", "description": "Prevents pulling to one side.", "category": "Steering"},
  {"title": "Avoid Hitting Curbs", "description": "Protects both tires and steering components.", "category": "Steering"},

  // Exhaust
  {"title": "Inspect Muffler for Holes", "description": "Prevents excessive noise and leaks.", "category": "Exhaust"},
  {"title": "Listen for Rattles", "description": "Loose hangers or broken parts cause noise.", "category": "Exhaust"},
  {"title": "Check for Soot", "description": "Black soot at tailpipe may imply rich running.", "category": "Exhaust"},
  {"title": "Monitor Fuel Economy", "description": "Drops can signal exhaust blockages.", "category": "Exhaust"},
  {"title": "Repair Leaks Promptly", "description": "Avoids fumes entering cabin.", "category": "Exhaust"},

  // Interior
  {"title": "Vacuum Weekly", "description": "Keeps carpets and seats clean.", "category": "Interior"},
  {"title": "Condition Leather", "description": "Prevents cracks in seats.", "category": "Interior"},
  {"title": "Use Sunshades", "description": "Protects dashboard from UV damage.", "category": "Interior"},
  {"title": "Clean Air Vents", "description": "Prevents dust buildup.", "category": "Interior"},
  {"title": "Organize Essentials", "description": "Keep documents and tools handy.", "category": "Interior"},

  // Exterior
  {"title": "Rinse Undercarriage", "description": "Removes salt after winter driving.", "category": "Exterior"},
  {"title": "Touch Up Paint Chips", "description": "Prevents rust from forming.", "category": "Exterior"},
  {"title": "Inspect Wheel Wells", "description": "Check for rust and debris.", "category": "Exterior"},
  {"title": "Polish Headlights", "description": "Restores clarity and brightness.", "category": "Exterior"},
  {"title": "Lubricate Hinges", "description": "Prevents squeaks and rust.", "category": "Exterior"},

  // Fuel System
  {"title": "Use Injector Cleaner", "description": "Every 3,000 miles to maintain performance.", "category": "Fuel System"},
  {"title": "Avoid Running Low", "description": "Prevents sediment from clogging filter.", "category": "Fuel System"},
  {"title": "Replace Fuel Filter", "description": "As per manufacturer recommendation.", "category": "Fuel System"},
  {"title": "Monitor Fuel Economy", "description": "Drops can signal fuel system issues.", "category": "Fuel System"},
  {"title": "Check for Smells", "description": "Fuel odors may indicate leaks.", "category": "Fuel System"},

  // Belts & Hoses
  {"title": "Inspect Serpentine Belt", "description": "Look for cracks and wear.", "category": "Belts & Hoses"},
  {"title": "Replace Timing Belt", "description": "Per schedule to avoid engine damage.", "category": "Belts & Hoses"},
  {"title": "Squeeze Hoses", "description": "Firm but not brittle or mushy indicates good condition.", "category": "Belts & Hoses"},
  {"title": "Check for Leaks", "description": "Around hose connections and clamps.", "category": "Belts & Hoses"},
  {"title": "Tighten Clamps", "description": "Prevents coolant and oil leaks.", "category": "Belts & Hoses"},

  // Electrical
  {"title": "Test Horn and Lights", "description": "Ensure all signals work correctly.", "category": "Electrical"},
  {"title": "Inspect Wiring", "description": "Look for exposed or frayed wires.", "category": "Electrical"},
  {"title": "Replace Blown Fuses", "description": "Keep spares in glovebox.", "category": "Electrical"},
  {"title": "Avoid Overloading", "description": "Don’t plug too many accessories into one outlet.", "category": "Electrical"},
  {"title": "Check Alternator Output", "description": "Ensures battery stays charged.", "category": "Electrical"},

  // Diagnostics
  {"title": "Use OBD2 Scanner", "description": "Read check-engine codes for troubleshooting.", "category": "Diagnostics"},
  {"title": "Record Recurring Codes", "description": "Helps mechanic diagnose persistent issues.", "category": "Diagnostics"},
  {"title": "Don’t Ignore Warnings", "description": "Early fixes cost less than major repairs.", "category": "Diagnostics"},
  {"title": "Clear Codes After Repair", "description": "Verify the issue is resolved.", "category": "Diagnostics"},
  {"title": "Consult a Mechanic", "description": "For codes you can’t fix yourself.", "category": "Diagnostics"},
];
   /// Computes the list of tips filtered by search text and selected category
  List<Map<String, String>> get filteredTips {
    final search = _searchController.text.toLowerCase();
    return allTips.where((tip) {
      final matchesSearch = tip['title']!.toLowerCase().contains(search)
        || tip['description']!.toLowerCase().contains(search);
      final matchesCategory = selectedCategory == 'All'
        || tip['category'] == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _showTipDetail(Map<String, String> tip, bool isDark) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: isDark ? Colors.white : Colors.black87,
        insetPadding: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                tip['title']!,
                style: GoogleFonts.karla(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.black : Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                tip['description']!,
                style: GoogleFonts.karla(
                  fontSize: 16,
                  color: isDark ? Colors.black87 : Colors.white70,
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "CLOSE",
                    style: TextStyle(
                      color: isDark ? Colors.blue : Colors.lightBlueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? Colors.white : Colors.black87,
      drawer: SideMenuDrawer(selectedIndex: selectedIndex),
      appBar: AppBar(
        backgroundColor: isDark ? Colors.blue : Colors.black87,
        title: Text(
          "Maintenance Tips",
          style: GoogleFonts.karla(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search + Filter row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    style: TextStyle(color: isDark ? Colors.black : Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search tips",
                      hintStyle: GoogleFonts.lexendDeca(
                        color: isDark ? Colors.grey : Colors.white70,
                      ),
                      prefixIcon: Icon(Icons.search, color: isDark ? Colors.black : Colors.white),
                      filled: true,
                      fillColor: isDark ? Colors.grey[100] : Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                 // Category filter popup menu
                PopupMenuButton<String>(
                  icon: Icon(Icons.filter_list, color: isDark ? Colors.black : Colors.white),
                  color: isDark ? Colors.white : Colors.black87,
                  onSelected: (value) => setState(() => selectedCategory = value),
                  itemBuilder: (_) => [
        "All",
        "Tires",
        "Fluids",
        "Brakes",
        "Engine",
        "General",
        "Lights",
        "Suspension",
        "AC",
        "Wipers",
        "Battery",
        "Transmission",
        "Steering",
        "Exhaust",
        "Interior",
        "Exterior",
        "Fuel System",
        "Belts & Hoses",
        "Electrical",
        "Diagnostics"
      ].map((cat) {
                    return PopupMenuItem(
                      value: cat,
                      child: Text(cat, style: TextStyle(color: isDark ? Colors.black : Colors.white)),
                    );
                  }).toList(),
                ),
              ],
            ),

            const SizedBox(height: 16),

             // List of filtered tips
            Expanded(
              child: ListView.builder(
                itemCount: filteredTips.length,
                itemBuilder: (context, i) {
                  final tip = filteredTips[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _showTipDetail(tip, isDark),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[200] : Colors.grey[800],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: isDark ? Colors.black12 : Colors.black54,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: Text(
                            tip['title']!,
                            style: GoogleFonts.karla(
                              color: isDark ? Colors.black87 : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            tip['description']!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.karla(
                              color: isDark ? Colors.black54 : Colors.white70,
                            ),
                          ),
                          trailing: Icon(Icons.chevron_right, color: isDark ? Colors.black54 : Colors.white70),
                        ),
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
