import 'package:carcare/pages/GetStartedPage1.dart';
import 'package:carcare/pages/LoginPage.dart';
import 'package:carcare/common_widgets/Navigation_Menu.dart';
import 'package:carcare/theme_provider/themeprovider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({Key? key}) : super(key: key);

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  int selectedIndex = 6;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ghanaCardController = TextEditingController();

  bool isEditing = false;
  bool showSave = false;
  bool isLoading = true;
  String? avatarPath;

  // List of available avatar asset paths
  final List<String> avatarOptions = [
    'assets/img/avatar1.png',
    'assets/img/avatar2.png',
    'assets/img/avatar3.png',
    'assets/img/avatar4.png',
    'assets/img/avatar5.png',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      nameController.text = data['fullname'] ?? '';
      emailController.text = data['email'] ?? '';
      ghanaCardController.text = data['GhanaCardNumber'] ?? '';
      avatarPath = data['avatarPath'] as String?;
    }

    setState(() => isLoading = false);
  }

  void startEditing() {
    setState(() {
      isEditing = true;
      showSave = false;
    });
    // Show save button when any field changes
    [nameController, emailController, ghanaCardController]
        .forEach((c) => c.addListener(() => setState(() => showSave = true)));
  }

  Future<void> saveChanges() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Are you sure?"),
        content: const Text("You’re about to update your profile."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Yes, Update")),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'fullname': nameController.text.trim(),
        'email': emailController.text.trim(),
        'GhanaCardNumber': ghanaCardController.text.trim(),
        if (avatarPath != null) 'avatarPath': avatarPath!,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully",style: TextStyle(color: Colors.white),),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        isEditing = false;
        showSave = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error updating profile: $e"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> pickAvatar() async {
    final choice = await showDialog<String>(
      context: context,
      builder: (_) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: avatarOptions.map((path) {
              return GestureDetector(
                onTap: () => Navigator.pop(context, path),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(path),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
    if (choice != null) {
      setState(() {
        avatarPath = choice;
        showSave = true;
      });
    }
  }

  Widget buildLabel(bool isDark, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 18),
      child: Text(
        label,
        style: GoogleFonts.lexendDeca(
          color: isDark ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildTextField(
      String label, TextEditingController controller, bool readOnly) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(isDark, label),
        TextField(
          controller: controller,
          readOnly: readOnly,
          style: TextStyle(color: isDark ? Colors.black : Colors.white),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide:
                  BorderSide(color: isDark ? Colors.black : Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
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
                child:
                    const Text("Edit", style: TextStyle(color: Colors.blue)))
          else if (showSave)
            TextButton(
                onPressed: saveChanges,
                child:
                    const Text("Save", style: TextStyle(color: Colors.blue)))
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Avatar with edit icon overlay
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GestureDetector(
                        onTap: isEditing ? pickAvatar : null,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: avatarPath != null
                              ? AssetImage(avatarPath!)
                              : const AssetImage('assets/img/Avatar.png'),
                        ),
                      ),
                      if (isEditing)
                        Positioned(
                          right: 4,
                          bottom: 4,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon:
                                  const Icon(Icons.edit, size: 18, color: Colors.white),
                              onPressed: pickAvatar,
                            ),
                          ),
                        ),
                    ],
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
                  buildTextField("Name", nameController, !isEditing),
                  buildTextField("Email", emailController, !isEditing),
                  buildTextField(
                      "Ghana Card Number", ghanaCardController, !isEditing),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => GetStartedPage1()));
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text("Log out", style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
