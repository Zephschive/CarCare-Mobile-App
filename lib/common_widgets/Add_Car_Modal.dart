import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class AddCarModal extends StatefulWidget {
     final VoidCallback onCarAdded;
  const AddCarModal({Key? key, required this.onCarAdded}) : super(key: key);

  @override
  State<AddCarModal> createState() => _AddCarModalState();
}

class _AddCarModalState extends State<AddCarModal> {
  final TextEditingController licensePlateController = TextEditingController();
  final TextEditingController customModelController = TextEditingController();

  String? selectedBrand;
  String? selectedType;
  String? selectedModel;
  String? _UserUID;
  bool isCustomModel = false;

   final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 final List<String> carBrands = [
  "Toyota",
  "Honda",
  "BMW",
  "Mercedes",
  "Nissan",
  "Hyundai",
  "Kia",
  "Ford",
  "Chevrolet",
  "Volkswagen"
];

final List<String> carTypes = [
  "SUV",
  "Sedan",
  "Truck",
  "Coupe",
  "Hatchback",
  "Van",
  "Pickup"
];

final Map<String, List<String>> carModels = {
  "Toyota": [
    "Corolla",
    "Camry",
    "Yaris",
    "Vitz",
    "RAV4",
    "Fortuner",
    "Prado",
    "Land Cruiser",
    "Hilux",
    "Yaris Cross"
  ],
  "Honda": [
    "Civic",
    "Accord",
    "Fit",
    "City",
    "CR-V",
    "HR-V",
    "BR-V"
  ],
  "BMW": [
    "1 Series",
    "2 Series",
    "3 Series",
    "5 Series",
    "7 Series",
    "X1",
    "X3",
    "X5",
    "X6",
    "X7"
  ],
  "Mercedes": [
    "A-Class",
    "C-Class",
    "E-Class",
    "S-Class",
    "GLA",
    "GLC",
    "GLE",
    "GLS",
    "Sprinter"
  ],
  "Nissan": [
    "Micra",
    "Almera",
    "Sentra",
    "Altima",
    "Maxima",
    "Juke",
    "Qashqai",
    "X-Trail",
    "Patrol",
    "Navara",
    "Leaf"
  ],
  "Hyundai": [
    "i10",
    "i20",
    "i30",
    "Accent",
    "Elantra",
    "Kona",
    "Tucson",
    "Santa Fe",
    "Palisade"
  ],
  "Kia": [
    "Picanto",
    "Rio",
    "Stonic",
    "Seltos",
    "Sportage",
    "Sorento",
    "Carnival"
  ],
  "Ford": [
    "Fiesta",
    "Focus",
    "EcoSport",
    "Escape",
    "Edge",
    "Explorer",
    "Ranger",
    "F-150"
  ],
  "Chevrolet": [
    "Spark",
    "Aveo",
    "Cruze",
    "Malibu",
    "Equinox",
    "Trailblazer",
    "Tahoe",
    "Suburban"
  ],
  "Volkswagen": [
    "Polo",
    "Golf",
    "Jetta",
    "Passat",
    "Tiguan",
    "Touareg"
  ]
};

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _fetchUserUid();
  }

 void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
  User? _currentUser ;


    Future<void> _fetchUserUid() async {


    if (_currentUser == null) return;
    try {
      final email = _currentUser!.email;
      if (email == null) return;

      QuerySnapshot querySnapshot = await _firestore
          .collection("users")
          .where("email", isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        setState(() {
          _UserUID = userDoc.get("uid") as String?;
        });
       
      }
    } catch (e) {
      debugPrint("Error fetching full name: $e");
    }
  }


void _submitCar() async {
  FocusScope.of(context).unfocus(); // close keyboard


   if (licensePlateController.text.isEmpty || selectedBrand == null || selectedType == null || (isCustomModel ? customModelController.text.isEmpty : selectedModel == null)) {
      _showErrorDialog("Please fill in all fields");
      return;
    }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  String finalModel =
      isCustomModel ? customModelController.text.trim() : selectedModel ?? "";

  if (licensePlateController.text.isEmpty ||
      selectedBrand == null ||
      selectedType == null ||
      finalModel.isEmpty) {
    Navigator.pop(context); // Close loading
    ScaffoldMessenger.of(Navigator.of(context).overlay!.context).showSnackBar(
      const SnackBar(content: Text("Please fill all fields")),
    );
    return;
  }

  await _fetchUserUid();

  print(_UserUID);

  try {
    await _firestore.collection("users").doc(_UserUID).set({
      "cars": FieldValue.arrayUnion([
        {
          "license_plate": licensePlateController.text.trim(),
          "brand": selectedBrand,
          "type": selectedType,
          "model": finalModel,
          "timestamp": "hbk "
        }
      ])
    }, SetOptions(merge: true));
    widget.onCarAdded();

    Navigator.pop(context); // close loading
    Navigator.pop(context); // close modal

  

    ScaffoldMessenger.of(Navigator.of(context).overlay!.context).showSnackBar(
      SnackBar(
        content: const Text("Car added successfully", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    Navigator.pop(context); // close loading
    ScaffoldMessenger.of(Navigator.of(context).overlay!.context).showSnackBar(
      SnackBar(content: Text("Something went wrong: $e")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add Car",
              style:
                  GoogleFonts.karla(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // License Plate Number
            TextField(
              controller: licensePlateController,
              decoration: const InputDecoration(
                labelText: "License Plate Number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // Car Brand (Searchable Dropdown)
            DropdownButtonFormField<String>(
  value: selectedBrand,
  decoration: InputDecoration(
    labelText: "Select Car Brand",
    border: OutlineInputBorder(),
  ),
  items: carBrands.map((brand) {
    return DropdownMenuItem(
      value: brand,
      child: Text(brand),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      selectedBrand = value;
      selectedModel = null;
      isCustomModel = false;
    });
  },
),


            const SizedBox(height: 10),

            // Car Type (Searchable Dropdown)
           DropdownButtonFormField<String>(
  value: selectedType,
  decoration: InputDecoration(
    labelText: "Select Car Type",
    border: OutlineInputBorder(),
  ),
  items: carTypes.map((type) {
    return DropdownMenuItem(
      value: type,
      child: Text(type),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      selectedType = value;
    });
  },
),

            const SizedBox(height: 10),

            // Car Model (Dropdown or TextField)
            if (selectedBrand != null) ...[
  DropdownButtonFormField<String>(
    value: selectedModel,
    decoration: InputDecoration(
      labelText: "Select Car Model",
      border: OutlineInputBorder(),
    ),
    items: (carModels[selectedBrand] ?? []).map((model) {
      return DropdownMenuItem(
        value: model,
        child: Text(model),
      );
    }).toList(),
    onChanged: (value) {
      setState(() {
        selectedModel = value;
        isCustomModel = false;
      });
    },
  ),
  const SizedBox(height: 10),
  TextButton(
    onPressed: () => setState(() => isCustomModel = true),
    child: const Text("Can't find your model? Add manually"),
  ),
]
,

            if (isCustomModel) ...[
              TextField(
                controller: customModelController,
                decoration: const InputDecoration(
                  labelText: "Enter Car Model",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
            ],

            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: (){
                  _submitCar();
                },
                child:
                    const Text("Confirm", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
