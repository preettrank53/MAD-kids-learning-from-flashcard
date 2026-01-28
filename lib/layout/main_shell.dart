import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/manage_cards_screen.dart';
import '../screens/settings_screen.dart';
import '../core/theme/theme.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  // Screens for IndexedStack
  // Using lazy initialization or simple list if screens are lightweight
  // For now, we'll instantiate them directly as per LLD simplicity
  final List<Widget> _screens = [
    const HomeScreen(),
    const ManageCardsScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Prevents shifting
        backgroundColor: Colors.white,
        elevation: 8,
        selectedItemColor: AppTheme.skyBlue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_rounded), // "Manage" context
            label: 'Manage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
