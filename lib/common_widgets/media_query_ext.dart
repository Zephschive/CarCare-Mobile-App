import 'package:flutter/material.dart';

class ScreenSize {
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
  static double statusBarHeight(BuildContext context) => MediaQuery.of(context).padding.top;
  static double bottomInset(BuildContext context) => MediaQuery.of(context).viewInsets.bottom;
}
