import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return NavigationDrawer(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
          child: Text(
            'Runners Social',
            style: theme.textTheme.titleLarge,
          ),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: const Text('Home'),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.directions_run_outlined),
          selectedIcon: const Icon(Icons.directions_run),
          label: const Text('Runs'),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.feed_outlined),
          selectedIcon: const Icon(Icons.feed),
          label: const Text('Feed'),
        ),
        const Divider(),
        NavigationDrawerDestination(
          icon: const Icon(Icons.person_outline),
          selectedIcon: const Icon(Icons.person),
          label: const Text('Profile'),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: const Text('Settings'),
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
    );
  }
}
