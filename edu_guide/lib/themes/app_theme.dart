import 'package:flutter/material.dart';

// --- Color Palette ---
const Color kPrimaryColor = Color(0xFF1E88E5);
const Color kLightBackgroundColor = Color(0xFFF0F4F8);
const Color kDarkGrayColor = Color(0xFF333333);
const Color kMediumGrayColor = Color(0xFF555555);
const Color kPlaceholderColor = Color(0xFFF1EBE6);
const Color kPlaceholderTextColor = Color(0xFF4D4D4D);

// --- Font Family ---
const String kFontFamily = 'Inter';

// --- Size Constants ---
const double kPadding = 16.0;
const double kLargePadding = 32.0;
const double kBorderRadius = 30.0;
const double kImageSize = 0.55; // Increased image size
const double kTitleFontSize = 0.055; // Reduced header size
const double kDescFontSize = 0.035; // Reduced body text size

// --- Responsive Helper ---
class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
  }

  static double wp(double percent) => screenWidth * percent;
  static double hp(double percent) => screenHeight * percent;
}

// --- Reusable App Theme ---
final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.blue,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: kFontFamily,
  scaffoldBackgroundColor: kLightBackgroundColor,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kPrimaryColor,
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: kPrimaryColor),
  ),
  // Add other reusable themes here
);
