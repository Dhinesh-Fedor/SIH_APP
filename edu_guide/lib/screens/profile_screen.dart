import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../utils/snackbar_util.dart';
// Removed all external location package imports
// import 'home_screen.dart'; // No longer strictly needed but kept for context

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _classController = TextEditingController();

  // New controllers for State and City (Manual Input)
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();

  String? _selectedGender;
  bool _isLoading = false;
  bool _isFetching = true;

  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _classController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserProfile() async {
    setState(() => _isFetching = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseDatabase.instance
            .ref('users/${user.uid}')
            .get();
        if (snapshot.exists) {
          final data = snapshot.value as Map<dynamic, dynamic>;
          _nameController.text = data['name'] ?? '';
          _ageController.text = (data['age'] ?? '').toString();
          _selectedGender = data['gender'];
          _classController.text = data['current_class'] ?? '';

          // Load selected state and city into text controllers
          _stateController.text = data['location_state'] ?? '';
          _cityController.text = data['location_city'] ?? '';
        }
      }
    } catch (e) {
      SnackbarUtils.showSnackbar(
        context,
        'Failed to load profile data: $e',
        color: Colors.red,
      );
    } finally {
      if (mounted) setState(() => _isFetching = false);
    }
  }

  Future<void> _saveProfile() async {
    // Validation check for empty fields
    if (_stateController.text.trim().isEmpty ||
        _cityController.text.trim().isEmpty) {
      SnackbarUtils.showSnackbar(
        context,
        'Please enter your state and city.',
        color: Colors.orange,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User is not logged in');

      final profileData = {
        'name': _nameController.text.trim(),
        'age': int.tryParse(_ageController.text),
        'gender': _selectedGender,
        'current_class': _classController.text.trim(),
        'location_country': 'India', // Value remains constant
        'location_state': _stateController.text.trim(),
        'location_city': _cityController.text.trim(),
      };

      await FirebaseDatabase.instance
          .ref('users/${user.uid}')
          .update(profileData);

      SnackbarUtils.showSnackbar(
        context,
        'Profile updated successfully!',
        color: Colors.green,
      );

      // Navigate back to the previous screen (SettingsScreen)
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      SnackbarUtils.showSnackbar(
        context,
        'Failed to save profile: $e',
        color: Colors.red,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isFetching)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text('Profile Setup'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personal Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text('Help us understand you better.'),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(),
                      ),
                      items: _genders
                          .map(
                            (gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedGender = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _classController,
                decoration: const InputDecoration(
                  labelText: 'Current Class (10th or 12th)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Manual State and City TextFields
              Row(
                children: [
                  // State TextField
                  Expanded(
                    child: TextField(
                      controller: _stateController,
                      decoration: const InputDecoration(
                        labelText: 'State',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // City TextField
                  Expanded(
                    child: TextField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _saveProfile,
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text('Save & Continue', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
