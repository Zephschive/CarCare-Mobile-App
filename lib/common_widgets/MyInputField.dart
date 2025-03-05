import 'package:flutter/material.dart';

class MyInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final String? Function(String?)? validator; // Custom validator

  const MyInputField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.validator, // Accept custom validator
  }) : super(key: key);

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<MyInputField> {
  String? errorText; // Holds error message

  void validateInput(String value) {
    setState(() {
      if (widget.validator != null) {
        errorText = widget.validator!(value); // Use custom validator
      } else {
        errorText = _defaultValidator(value); // Use default validation
      }
    });
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "This field cannot be empty";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword,
          onChanged: validateInput, // Validate on text change
          decoration: InputDecoration(
            hintText: widget.hintText,
            errorText: errorText, // Show error message
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFB3B2B2)), // Custom border color
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFB3B2B2)), // Default border color
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue, width: 2), // Highlighted border
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }
}
