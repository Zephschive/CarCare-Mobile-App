import 'package:flutter/material.dart';


Widget TipCard(String title, String subtitle, bool isDark) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDark ? Colors.white : Colors.black12,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFB3B2B2)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.black : Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            maxLines: 1,                      // <- only one line
            overflow: TextOverflow.ellipsis,   // <- ellipsis if too long
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.grey : Colors.white60,
            ),
          ),
        ],
      ),
    ),
  );
}
