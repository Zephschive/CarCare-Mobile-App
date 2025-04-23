import 'package:carcare/theme_provider/themeprovider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
  
  
  
  Widget TipCard(String title, String subtitle, bool isDark) {
    ;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isDark ? Colors.white: Colors.black12,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFB3B2B2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:  TextStyle(fontWeight: FontWeight.bold , color: isDark ? Colors.black: Colors.white ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: TextStyle(fontWeight: FontWeight.bold , color: isDark ? Colors.grey :Colors.white60 ),
            ),
          ],
        ),
      ),
    );
  }
