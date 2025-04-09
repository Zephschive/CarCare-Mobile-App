
import 'package:flutter/material.dart';
import 'package:carcare/common_widgets/common_widgets.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({Key? key}) : super(key: key);

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  int selectedIndex = 6;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      drawer: SideMenuDrawer(selectedIndex: selectedIndex),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            _scaffoldkey.currentState?.openDrawer();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/avatar.jpg'), // Replace with NetworkImage if needed
                  ),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey[200],
                    child: const Icon(Icons.edit, size: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Alex Hioeiwje",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 30),
            buildLabel("Name"),
            buildTextField("Alex Hioeiwje"),
            buildLabel("ID Number"),
            buildTextField("GH-220-3827-87"),
            buildLabel("Plate Number", note: "(edit Plate number)"),
            Stack(
              children: [
                buildTextField("GH 2203-87"),
                Positioned(
                  right: 10,
                  top: 15,
                  child: Icon(Icons.edit, size: 18, color: Colors.grey[700]),
                ),
              ],
            ),
            buildLabel("Password"),
            buildTextField("***************", obscureText: true),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Change password?",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget buildLabel(String label, {String? note}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 18),
      child: RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          children: [
            if (note != null)
              TextSpan(
                text: ' $note',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String value, {bool obscureText = false}) {
    return TextFormField(
      obscureText: obscureText,
      initialValue: value,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      ),
    );
  }
}
