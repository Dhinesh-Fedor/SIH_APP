import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../utils/snackbar_util.dart';

import 'home_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Periodically refresh user to check email verification
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload(); // refresh user data

        if (user.emailVerified) {
          _timer?.cancel(); // <-- CRITICAL FIX: Cancel the timer immediately
          if (mounted) setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // User is logged out
      _timer
          ?.cancel(); // Ensure timer is canceled if we navigate back to LoginScreen
      return const LoginScreen();
    }

    if (!user.emailVerified) {
      // Waiting for email verification
      return Scaffold(
        body: Center(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Verify Your Email",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "A verification email has been sent to your email address. "
                    "Please click the link in the email to continue.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 200, // fixed width button
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        await user.sendEmailVerification();
                        SnackbarUtils.showSnackbar(
                          context,
                          "Verification email resent.",
                        );
                      },
                      child: const Text("Resend Email"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Email verified → check profile once
    _timer
        ?.cancel(); // Ensure timer is canceled before checking profile/navigating
    return FutureBuilder<DatabaseEvent>(
      future: FirebaseDatabase.instance.ref('users/${user.uid}').once(),
      builder: (context, profileSnapshot) {
        if (profileSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (profileSnapshot.data?.snapshot.value == null) {
          // Profile not set → redirect to ProfileScreen
          return const ProfileScreen();
        } else {
          // Profile exists → go to HomeScreen
          return const HomeScreen();
        }
      },
    );
  }
}
