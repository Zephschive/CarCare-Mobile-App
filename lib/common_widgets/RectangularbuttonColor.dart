import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RectangularbuttonColor extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double Width;
  final Color BackgroundColor;
  final Color textColor;

  const RectangularbuttonColor({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.Width,
    required this.BackgroundColor,
    required this.textColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Width, // Full-width button
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: BackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.karla(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
