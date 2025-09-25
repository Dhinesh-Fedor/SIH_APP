import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'settings_screen.dart';
import '../themes/app_theme.dart';

// --- HomeTabContent (Fetches Name and Implements Dashboard/Quiz Navigation) ---
class HomeTabContent extends StatefulWidget {
  final ValueSetter<int> onNavigate;

  const HomeTabContent({super.key, required this.onNavigate});

  @override
  State<HomeTabContent> createState() => _HomeTabContentState();
}

class _HomeTabContentState extends State<HomeTabContent> {
  String _userName = 'User';
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Fetch the 'name' from the profile setup
    final userRef = FirebaseDatabase.instance.ref('users/${user.uid}/name');
    final snapshot = await userRef.get();

    if (snapshot.exists) {
      final fullName = snapshot.value.toString();
      // Use the first word of the name
      final firstName = fullName.split(' ')[0];
      if (mounted) {
        setState(() {
          _userName = firstName;
        });
      }
    }
  }

  Widget _buildQuickAccessCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    int?
    navigateToIndex, // Index of the tab to navigate to (Quiz is 1, Colleges 2, Careers 3)
  ) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          if (navigateToIndex != null) {
            widget.onNavigate(navigateToIndex); // Navigate to the selected tab
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 30),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kDarkGrayColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: kMediumGrayColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('EduPath'),
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: kDarkGrayColor),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- Welcome Section (Uses fetched user name) ---
          Text(
            'Hello, $_userName',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: kDarkGrayColor,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Welcome back to your personalized learning journey.',
            style: TextStyle(fontSize: 16, color: kMediumGrayColor),
          ),
          const SizedBox(height: 24),

          // --- Quick Access Section ---
          const Text(
            'Quick Access',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kDarkGrayColor,
            ),
          ),
          const SizedBox(height: 16),

          // Grid Layout for Quick Access Cards
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.85,
            children: [
              _buildQuickAccessCard(
                context,
                'Take Aptitude Quiz',
                'Assess your strengths',
                Icons.quiz,
                Colors.orange.shade400,
                1, // Navigate to Quiz Tab
              ),
              _buildQuickAccessCard(
                context,
                'Explore Courses',
                'Discover programs',
                Icons.explore,
                Colors.green.shade400,
                2, // Navigate to Colleges Tab (Courses is part of Colleges/Programs)
              ),
              _buildQuickAccessCard(
                context,
                'Find Colleges Nearby',
                'Locate institutions',
                Icons.location_on,
                Colors.blue.shade400,
                2, // Navigate to Colleges Tab
              ),
              _buildQuickAccessCard(
                context,
                'Track Deadlines',
                'Important dates',
                Icons.calendar_today,
                Colors.purple.shade400,
                null, // No specific tab
              ),
              _buildQuickAccessCard(
                context,
                'AI Chatbot',
                'Get instant help',
                Icons.smart_toy,
                Colors.teal.shade400,
                null, // No specific tab
              ),
              _buildQuickAccessCard(
                context,
                'Career Paths',
                'Career options',
                Icons.work,
                Colors.red.shade400,
                3, // Navigate to Careers Tab
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Other Widgets (PlaceholderScreen, HomeScreen) ---
class PlaceholderScreen extends StatelessWidget {
  final String screenName;
  const PlaceholderScreen({super.key, required this.screenName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        screenName,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index < _widgetOptions.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // The list of widgets shown when a tab is selected.
  late final List<Widget> _widgetOptions = <Widget>[
    // Pass the navigation function to the HomeTabContent
    HomeTabContent(onNavigate: _onItemTapped),

    const PlaceholderScreen(screenName: 'Quiz Screen'),
    const PlaceholderScreen(screenName: 'Colleges Screen'),
    const PlaceholderScreen(screenName: 'Careers Screen'),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quiz'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Colleges'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Careers'),
          // Index 4
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
