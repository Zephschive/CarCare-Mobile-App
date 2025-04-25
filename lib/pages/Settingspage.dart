import 'package:carcare/theme_provider/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:carcare/common_widgets/common_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({Key? key}) : super(key: key);

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  int selectedIndex = 6;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController  GhanaCardController= TextEditingController();
  final TextEditingController plateController = TextEditingController();

  bool isEditing = false;
  bool showSave = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      nameController.text = data['fullname'] ?? '';
      EmailController.text = data['email'] ?? '';
      GhanaCardController.text = data['GhanaCardNumber'] ?? '';
      plateController.text = data['plate'] ?? '';
    }

    setState(() => isLoading = false);
  }

  void startEditing() {
    setState(() {
      isEditing = true;
      showSave = false;
    });

    nameController.addListener(_checkIfChanged);
    GhanaCardController.addListener(_checkIfChanged);
    plateController.addListener(_checkIfChanged);
  }

  void _checkIfChanged() {
    setState(() => showSave = true);
  }

  void saveChanges() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Are you sure?"),
        content: const Text("You’re about to update your profile."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid != null) {
                await FirebaseFirestore.instance.collection('users').doc(uid).update({
                  'fullname': nameController.text.trim(),
                  'GhanaCardNumber': GhanaCardController.text.trim(),
                  'email': EmailController.text.trim(),
                });
              }
              Navigator.pop(context);
              setState(() {
                isEditing = false;
                showSave = false;
              });
            },
            child: const Text("Yes, Update"),
          )
        ],
      ),
    );
  }

  Widget buildLabel(bool isDark, String label, {String? note}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 18),
      child: RichText(
        text: TextSpan(
          text: label,
          style: GoogleFonts.lexendDeca(
              color: isDark ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold),
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

  Widget buildTextField(String label, TextEditingController controller) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(isDark, label),
        TextField(
          controller: controller,
          readOnly: !isEditing,
          style: GoogleFonts.lexendDeca(
            color: isDark ? Colors.black : Colors.white,
          ),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(
                color: isDark ? Colors.black : Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? Colors.white : Colors.black87,
      key: _scaffoldkey,
      drawer: SideMenuDrawer(selectedIndex: selectedIndex),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? Colors.white : Colors.black87,
        leading: IconButton(
          icon: Icon(Icons.menu, color: isDark ? Colors.black : Colors.white),
          onPressed: () => _scaffoldkey.currentState?.openDrawer(),
        ),
        actions: [
          if (!isEditing)
            TextButton(
              onPressed: startEditing,
              child: const Text("Edit", style: TextStyle(color: Colors.blue)),
            )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/avatar.jpg'),
                        ),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey[200],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    nameController.text,
                    style: GoogleFonts.lexendDeca(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.black : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  buildTextField("Name", nameController),
                  buildTextField("Email", EmailController),
                  buildTextField("Ghana Card Number", GhanaCardController),
                  const SizedBox(height: 20),
                  if (showSave)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: saveChanges,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        child: const Text("Save", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }
}
