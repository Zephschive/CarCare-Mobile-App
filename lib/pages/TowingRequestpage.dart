import 'package:flutter/material.dart';
import 'package:carcare/common_widgets/common_widgets.dart';

class TowingRequestPage extends StatefulWidget {
  @override
  _TowingRequestPageState createState() => _TowingRequestPageState();
}

class _TowingRequestPageState extends State<TowingRequestPage> {
  String? selectedVehicleType;
  String? selectedServiceType;
  int selectedIndex = 2;
  bool showBottomSheet = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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

          /// 📍 Top menu icon (hamburger)
          Positioned(
            top: 40, // adjust as needed for spacing below status bar
            left: 16,
            child: IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
          ),

          /// 📍 Bottom Sheet
          if (showBottomSheet)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Towing Request", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    SizedBox(height: 10),
                    TextField(
                      readOnly: true,
                      controller: TextEditingController(text: "Alex Hioeiwje"),
                      decoration: InputDecoration(labelText: "Location"),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedVehicleType,
                      items: ["Saloon", "SUV", "Truck"]
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) => setState(() => selectedVehicleType = val),
                      decoration: InputDecoration(labelText: "Select Vehicle Type"),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedServiceType,
                      items: ["Towing", "Battery Boost", "Flat Tyre"]
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) => setState(() => selectedServiceType = val),
                      decoration: InputDecoration(labelText: "Service Type"),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => showBottomSheet = false);
                      },
                      child: Text("Confirm"),
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
