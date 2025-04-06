import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:google_fonts/google_fonts.dart';

class AddCarModal extends StatefulWidget {
  const AddCarModal({super.key});

  @override
  State<AddCarModal> createState() => _AddCarModalState();
}

class _AddCarModalState extends State<AddCarModal> {
  final TextEditingController licensePlateController = TextEditingController();
  final TextEditingController customModelController = TextEditingController();

  String? selectedBrand;
  String? selectedType;
  String? selectedModel;
  bool isCustomModel = false;

  final List<String> carBrands = ["Toyota", "Honda", "BMW", "Mercedes"];
  final List<String> carTypes = ["SUV", "Sedan", "Truck", "Coupe"];
  final Map<String, List<String>> carModels = {
    "Toyota": ["Corolla", "Camry", "RAV4"],
    "Honda": ["Civic", "Accord", "CR-V"],
    "BMW": ["X5", "X3", "3 Series"],
    "Mercedes": ["C-Class", "E-Class", "GLA"],
  };

  

  void _submitCar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String finalModel =
        isCustomModel ? customModelController.text.trim() : selectedModel ?? "";

    if (licensePlateController.text.isEmpty ||
        selectedBrand == null ||
        selectedType == null ||
        finalModel.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection("users").doc(user.email).update({
      "cars": FieldValue.arrayUnion([
        {
          "license_plate": licensePlateController.text.trim(),
          "brand": selectedBrand,
          "type": selectedType,
          "model": finalModel,
          "timestamp": FieldValue.serverTimestamp(),
        }
      ])
    });

    Navigator.pop(context);
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
                onPressed: _submitCar,
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
