import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:carcare/common_widgets/common_widgets.dart';

class Documentspage extends StatefulWidget {
  const Documentspage({super.key});

  @override
  State<Documentspage> createState() => _DocumentspageState();
}

class _DocumentspageState extends State<Documentspage> with SingleTickerProviderStateMixin {

  int selectedIndex= 4;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); 
  
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }



Future<void> _pickFileFor(String docType) async {
  Navigator.pop(context); // Close bottom sheet first

  final result = await FilePicker.platform.pickFiles(type: FileType.any);

  if (result != null) {
    final file = result.files.first;
    // Handle upload logic here (e.g., send to backend, Firebase, etc.)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$docType uploaded: ${file.name}")),
    );
  } else {
    // User canceled the picker
  }
}


  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenuDrawer(selectedIndex: selectedIndex),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(icon: Icon(Icons.menu, color: Colors.black), onPressed: () {
           _scaffoldKey.currentState?.openDrawer();
        }),
                Text("Documents", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),

            // Grid of documents
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  _buildDocumentCard("Driver’s License", "assets/img/driver's.png", "Up to date", Colors.green),
                  _buildDocumentCard("Insurance", "assets/img/Insurance.png", "Up to date", Colors.green),
                  _buildDocumentCard("RoadWorthy", "assets/img/RoadWorthy.png", "Renewal in 2 days", Colors.orange),
                  _buildDocumentCard("ECOWAS ID Card", "assets/img/GhanaCard.png", "Expired", Colors.red),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Tabs for Tire info and Tire Checker
            TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
              tabs: [
                Tab(text: "Tire info"),
                Tab(text: "Tire Checker"),
              ],
            ),
            SizedBox(height: 12),

            // Tire Info Form (static tab view for now)
            if (_tabController.index == 0)
              Column(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: "Tire’s Brand"),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(labelText: "Tire’s Manufacturer"),
                  ),
                ],
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildUploadOption("Insurance"),
          _buildUploadOption("RoadWorthy"),
          _buildUploadOption("ECOWAS ID"),
          _buildUploadOption("Drivers License"),
        ],
      ),
    ),
  );
},

        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildDocumentCard(String title, String imagePath, String status, Color statusColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(status, style: TextStyle(color: statusColor)),
      ],
    );
  }


  Widget _buildUploadOption(String title) {
  return InkWell(
    onTap: () => _pickFileFor(title),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16)),
          Icon(Icons.upload_outlined, color: Colors.blue),
        ],
      ),
    ),
  );
}

}
