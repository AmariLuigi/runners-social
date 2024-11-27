import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:runners_social/core/widgets/navigation_drawer.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: // Home
        context.router.pushNamed('/home');
        break;
      case 1: // Runs
        context.router.pushNamed('/run');
        break;
      case 2: // Feed
        context.router.pushNamed('/feed');
        break;
      case 3: // Profile
        context.router.pushNamed('/profile');
        break;
      case 4: // Settings
        // TODO: Navigate to settings
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Runners Social'),
      ),
      body: const Center(
        child: Text('Welcome to Runners Social!'),
      ),
      drawer: NavigationDrawer(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 28, 16, 16),
            child: Text(
              'Runners Social',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: Text('Home'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.directions_run_outlined),
            selectedIcon: Icon(Icons.directions_run),
            label: Text('Runs'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.feed_outlined),
            selectedIcon: Icon(Icons.feed),
            label: Text('Feed'),
          ),
          const Divider(),
          const NavigationDrawerDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: Text('Profile'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: Text('Settings'),
          ),
          const Spacer(),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Implement logout
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}
