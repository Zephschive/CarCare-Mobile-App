import 'package:carcare/theme_provider/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    this.validator,
  }) : super(key: key);

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<MyInputField> {
  String? errorText; // Holds error message

  void validateInput(String value) {
    setState(() {
      if (widget.validator != null) {
        errorText = widget.validator!(value);
      } else {
        errorText = _defaultValidator(value);
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
    // We’ll keep the input & error text always dark, for readability.
    final textColor = Colors.black;
    final errorColor = Colors.red.shade700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword,
          onChanged: validateInput,
          style: TextStyle(color: textColor),            // force input text color
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
            errorText: errorText,
            errorStyle: TextStyle(color: errorColor),    // force error text color
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: textColor.withOpacity(0.4)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: textColor.withOpacity(0.4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }
}
