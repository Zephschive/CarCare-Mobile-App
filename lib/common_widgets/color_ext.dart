import 'package:flutter/material.dart';

class CCcolrs {
  static const Color whiteBackground = Color(0xFFF6F6F6);
  static const Color whiteTextColor = Color(0xFFEEEDED);
  static const Color blueBackground = Color(0xFF2F80ED);
  static const Color calendarBackground = Color(0xFFE3EFFF);
  static const Color buttonColor = Color(0xFF2D9EE0);
  static const Color chatBubble = Color(0xFF2D9EE0);

  // Linear gradient 1
  static const LinearGradient linearColor1 = LinearGradient(
    colors: [
      Color(0xFF1E88E5), // Position 0%
      Color(0xFF2F80ED), // Position 50%
      Color(0xFF2D9EE0), // Position 100%
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Linear gradient 2
  static const LinearGradient linearColor2 = LinearGradient(
    colors: [
      Color(0xFF1E88E5), // Position 0%
      Color(0xFF000000), // Position 85%
      Color(0xFF000000), // Position 100%
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
