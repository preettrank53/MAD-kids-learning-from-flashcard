import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'settings_screen.dart';

// Main Shell - The new home of the app containing the navigation
// This screen wraps the Dashboard and other future screens with a BottomNavigationBar
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // Track the active tab index
  int _selectedIndex = 0;

  // List of pages to display based on selection
  final List<Widget> _pages = [
    // Item 1: Home (The Dashboard Grid)
    const DashboardScreen(),
    
    // Item 2: Manage (Placeholder for Manage Cards)
    const Placeholder(),
    
    // Item 3: Settings (Parent Zone)
    const SettingsScreen(),
  ];

  // Handle tap on navigation items
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display the selected page body
      body: _pages[_selectedIndex],
      
      // Step 2: Implement Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensure all items are shown properly
        backgroundColor: Colors.white, // Background Color: White
        elevation: 10, // Slight shadow for lift
        
        // Tab Selection Colors
        selectedItemColor: const Color(0xFFFFD300), // Bold Yellow
        unselectedItemColor: const Color(0xFF007AFF), // Electric Blue
        
        // Label Visibility
        showSelectedLabels: true,
        showUnselectedLabels: false, // Set Show Unselected Labels to false for clean look
        
        // Current index
        currentIndex: _selectedIndex,
        
        // Tap Handler
        onTap: _onItemTapped,
        
        // Navigation Items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
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
