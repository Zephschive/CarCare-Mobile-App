import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carcare/common_widgets/common_widgets.dart';
import 'package:carcare/theme_provider/themeprovider.dart';
import 'package:provider/provider.dart';

class Documentspage extends StatefulWidget {
  const Documentspage({super.key});
  @override
  _DocumentspageState createState() => _DocumentspageState();
}

class _DocumentspageState extends State<Documentspage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _firestore = FirebaseFirestore.instance;
  int selectedIndex = 4;

  bool _isImageFile(String path) {
  final lower = path.toLowerCase();
  return lower.endsWith('.png') ||
      lower.endsWith('.jpg') ||
      lower.endsWith('.jpeg') ||
      lower.endsWith('.gif') ||
      lower.endsWith('.bmp') ||
      lower.endsWith('.webp');
}


  // The four fixed document types
  final List<String> _docTypes = [
    "Driver’s License",
    "Insurance",
    "RoadWorthy",
    "ECOWAS ID Card"
  ];

  Future<void> _startAddFlow() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // 1) fetch already uploaded types
    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('documents')
        .get();
    final existing = snapshot.docs
        .map((d) => (d.data()! as Map<String, dynamic>)['docType'] as String)
        .toSet();

    // 2) only show the types not yet uploaded
    final available = _docTypes.where((t) => !existing.contains(t)).toList();

    if (available.isEmpty) {
      // nothing left
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("All Documents Uploaded"),
          content: const Text(
              "You have already uploaded all required documents."),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"))
          ],
        ),
      );
      return;
    }

    // 3) ask which one to add
    final choice = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: available
              .map((t) => ListTile(
                    title: Text(t),
                    onTap: () => Navigator.of(context).pop(t),
                  ))
              .toList(),
        ),
      ),
    );

    if (choice != null) {
      await _addDocumentOfType(choice);
    }
  }

  Future<void> _addDocumentOfType(String docType) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // pick file
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result == null) return;
    final raw = result.files.first;

    // pick issued date
    final issued = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select Issued Date',
      fieldLabelText: 'Issued',
    );
    if (issued == null) return;

    // pick expiry date
    final expiry = await showDatePicker(
      context: context,
      initialDate: issued.add(const Duration(days: 365)),
      firstDate: issued,
      lastDate: DateTime(2100),
      helpText: 'Select Expiry Date',
      fieldLabelText: 'Expiry',
    );
    if (expiry == null) return;

    // copy locally
    final dir = await getApplicationDocumentsDirectory();
    final ext = raw.extension != null ? '.${raw.extension}' : '';
    final filename = const Uuid().v4() + ext;
    final saved = await File(raw.path!).copy('${dir.path}/$filename');

    // upload metadata
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('documents')
        .add({
      'docType': docType,
      'fileName': raw.name,
      'localPath': saved.path,
      'issued': issued.toIso8601String(),
      'expiry': expiry.toIso8601String(),
      'uploadedAt': DateTime.now().toIso8601String(),
    });
  }

  Color _borderColor(DateTime expiry) {
    final now = DateTime.now();
    if (expiry.isBefore(now)) return Colors.red;
    if (expiry.isBefore(now.add(const Duration(days: 7)))) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? Colors.white : Colors.black87,
      drawer: SideMenuDrawer(selectedIndex: selectedIndex),
      appBar: AppBar(
        backgroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: isDark ? Colors.black : Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          "My Documents",
          style: GoogleFonts.karla(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.black : Colors.white,
          ),
        ),
      ),
      body: user == null
          ? Center(
              child: Text(
                "Please sign in",
                style:
                    TextStyle(color: isDark ? Colors.black : Colors.white),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('users')
                  .doc(user.uid)
                  .collection('documents')
                  .orderBy('uploadedAt', descending: true)
                  .snapshots(),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snap.data?.docs ?? [];
                if (docs.isEmpty) {
                  return Center(
                    child: Text("No documents uploaded yet.",
                        style: TextStyle(
                            color:
                                isDark ? Colors.black : Colors.white)),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    itemCount: docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (ctx, i) {
                      final data =
                          docs[i].data()! as Map<String, dynamic>;
                      final issued =
                          DateTime.parse(data['issued']);
                      final expiry =
                          DateTime.parse(data['expiry']);
                      final borderC = _borderColor(expiry);
                      final docType =
                          data['docType'] as String? ?? "";

                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DocumentDetailPage(
                              filePath: data['localPath'],
                              fileName: data['fileName'],
                              issued: issued,
                              expiry: expiry,
                              docType: docType,
                            ),
                          ),
                        ),
                         onLongPress: () async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Document"),
        content: const Text("Are you sure you want to delete this document?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // Delete Firestore document
        await docs[i].reference.delete();

        // Delete local file
        final localPath = data['localPath'];
        final file = File(localPath);
        if (await file.exists()) {
          await file.delete();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Document deleted")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete: $e")),
        );
      }}},
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.grey[200]
                                : Colors.grey[800],
                            border: Border.all(color: borderC, width: 3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: borderC,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  docType,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                             Expanded(
  child: Center(
    child: _isImageFile(data['localPath'])
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(data['localPath']),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, __, ___) => Icon(Icons.broken_image, color: borderC, size: 60),
            ),
          )
        : Icon(
            Icons.insert_drive_file,
            size: 60,
            color: borderC,
          ),
  ),
),

                              Text(
                                data['fileName'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Issued: ${issued.toLocal().toIso8601String().split('T').first}",
                                style: TextStyle(
                                    color: isDark
                                        ? Colors.black
                                        : Colors.white),
                              ),
                              Text(
                                "Expiry: ${expiry.toLocal().toIso8601String().split('T').first}",
                                style: TextStyle(
                                    color: isDark
                                        ? Colors.black
                                        : Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startAddFlow,
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Full-screen detail view with zoomable image support
class DocumentDetailPage extends StatelessWidget {
  final String filePath;
  final String fileName;
  final DateTime issued;
  final DateTime expiry;
  final String docType;

  const DocumentDetailPage({
    super.key,
    required this.filePath,
    required this.fileName,
    required this.issued,
    required this.expiry,
    required this.docType,
  });

  bool get _isImage {
    final lower = filePath.toLowerCase();
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.bmp') ||
        lower.endsWith('.webp');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text("$docType: $fileName")),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _isImage
                  ? InteractiveViewer(
                      panEnabled: true,
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: Image.file(
                        File(filePath),
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        "Preview not available.\nFile location:\n$filePath",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text("Document Type"),
            trailing: Text(docType),
          ),
          ListTile(
            title: const Text("Date Issued"),
            trailing:
                Text(issued.toLocal().toIso8601String().split('T').first),
          ),
          ListTile(
            title: const Text("Date Expiry"),
            trailing:
                Text(expiry.toLocal().toIso8601String().split('T').first),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
