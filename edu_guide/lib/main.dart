import 'package:flutter/material.dart';
import 'themes/app_theme.dart'; // <-- Import your theme
import 'screens/onboarding_screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onboarding Demo',
      debugShowCheckedModeBanner: false,
      theme: appTheme, // <-- Use your custom theme
      home: const OnboardingScreen(),
    );
  }
}
