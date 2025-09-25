import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../themes/app_theme.dart';
import '../services/authentication_service.dart';
import '../utils/snackbar_util.dart';
import 'auth_check_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  bool isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  Future<void> _onButtonPressed() async {
    setState(() {
      isLoading = true;
    });

    try {
      Map<String, dynamic> response;
      if (isLogin) {
        response = await _apiService.login(
          _emailController.text,
          _passwordController.text,
        );
      } else {
        response = await _apiService.signup(
          _emailController.text,
          _passwordController.text,
        );
      }

      if (response['success'] == true) {
        if (isLogin) {
          if (!mounted) return;
          SnackbarUtils.showSnackbar(
            context,
            'Login successful!',
            color: Colors.green,
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AuthCheckScreen()),
          );
        } else {
          if (!mounted) return;
          SnackbarUtils.showSnackbar(
            context,
            'Signup successful! Please verify your email to log in.',
            color: Colors.green,
          );
        }
      } else {
        if (!mounted) return;
        SnackbarUtils.showSnackbar(
          context,
          response['message'] ?? 'Authentication failed',
          color: Colors.red,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      SnackbarUtils.showSnackbar(
        context,
        e.message ?? 'An error occurred during authentication.',
        color: Colors.red,
      );
    } catch (e) {
      if (!mounted) return;
      SnackbarUtils.showSnackbar(
        context,
        'An unexpected error occurred. Please try again.',
        color: Colors.red,
      );
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text;
    if (email.isEmpty) {
      if (!mounted) return;
      SnackbarUtils.showSnackbar(
        context,
        'Please enter your email to reset the password.',
        color: Colors.orange,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await _apiService.forgotPassword(email);
      if (!mounted) return;
      SnackbarUtils.showSnackbar(
        context,
        'Password reset email sent. Check your inbox.',
        color: Colors.green,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      SnackbarUtils.showSnackbar(
        context,
        e.message ?? 'Failed to send password reset email.',
        color: Colors.red,
      );
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(kPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  SizeConfig.screenHeight -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    isLogin ? 'Welcome Back' : 'Join Our Community',
                    style: TextStyle(
                      fontSize: SizeConfig.wp(kTitleFontSize),
                      fontWeight: FontWeight.bold,
                      color: kDarkGrayColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isLogin
                        ? 'Sign in to your account'
                        : 'Create a new account',
                    style: TextStyle(
                      fontSize: SizeConfig.wp(kDescFontSize),
                      color: kMediumGrayColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (isLogin)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: isLoading ? null : _forgotPassword,
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: isLoading ? null : _onButtonPressed,
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            isLogin ? 'Sign In' : 'Sign Up',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                    child: Text(
                      isLogin
                          ? "Don't have an account? Sign Up"
                          : "Already have an account? Sign In",
                      style: const TextStyle(color: kPrimaryColor),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
