import 'dart:math';
import 'package:carcare/pages/serviceunavailablepage.dart';
import 'package:carcare/theme_provider/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:carcare/common_widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class TowingRequestPage extends StatefulWidget {
  @override
  _TowingRequestPageState createState() => _TowingRequestPageState();
}

class _TowingRequestPageState extends State<TowingRequestPage> {
  String? selectedVehicleType;
  String? selectedServiceType;
  String? selectedLocation;

  int selectedIndex = 2;
  bool showBottomSheet = true;
  bool isLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> ghanaLocations = [
    "Accra", "Kumasi", "Tamale", "Cape Coast", "Takoradi", "Sunyani",
    "Ho", "Wa", "Koforidua", "Bolgatanga"
  ];

  String getRandomLocation() {
    final rand = Random();
    return ghanaLocations[rand.nextInt(ghanaLocations.length)];
  }

  final List<String> serviceTypes = [
    "Towing", "Battery Boost", "Flat Tyre", "Locked Car", "Fuel Delivery",
    "Engine Issue", "Accident Assistance"
  ];

  @override
  Widget build(BuildContext context) {
     bool isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenuDrawer(selectedIndex: selectedIndex),
      body: Stack(
        children: [
          /// 📍 Fullscreen map placeholder
          Positioned.fill(
            child: Image.asset(
              "assets/img/MapAccra.png",
              fit: BoxFit.cover,
            ),
          ),

          /// 📍 Menu icon
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
          ),

          /// 📍 Loading indicator
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),

          /// 📍 Bottom Sheet
          if (showBottomSheet)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white : Colors.black87,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Towing Request", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: isDark ? Colors.black : Colors.white)),
                    SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                  value: selectedLocation,
                   style: TextStyle(color: isDark ? Colors.black : Colors.white),
                  items: ghanaLocations
                     .map((location) => DropdownMenuItem(
                            value: location,
                            child: Text(location),
                          ))
                     .toList(),
                 onChanged: (val) => setState(() => selectedLocation = val),
                  decoration: InputDecoration(labelText: "Select Location" , labelStyle: TextStyle(color: isDark ? Colors.black : Colors.white )),
                ),
             SizedBox(height: 10),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedVehicleType,
                      dropdownColor: isDark?Colors.white: Colors.black,
                      style: TextStyle(color: isDark ? Colors.black : Colors.white),
                      items: ["Saloon", "SUV", "Truck", "Van", "Motorbike"]
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) => setState(() => selectedVehicleType = val),
                      decoration: InputDecoration(labelText: "Select Vehicle Type", labelStyle: TextStyle(color: isDark ? Colors.black : Colors.white )),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedServiceType,
                      style: TextStyle(color: isDark ? Colors.black : Colors.white),
                      items: serviceTypes
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) => setState(() => selectedServiceType = val),
                      decoration: InputDecoration(labelText: "Service Type", labelStyle: TextStyle(color: isDark ? Colors.black : Colors.white )),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                          showBottomSheet = false;
                        });

                        await Future.delayed(Duration(seconds: 2));
                        setState(() => isLoading = false);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ServiceUnavailablePage()),
                        );
                      },
                      child: Text("Confirm", style: TextStyle( color:  Colors.white )),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
