import 'dart:ui';
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'settings_screen.dart';
import 'manage_cards_screen.dart';
import '../widgets/clay_card.dart';
import '../core/theme/theme.dart';

// Main Shell - The Floating Island Navigation
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
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
      extendBody: true, // Critical for floating nav bar
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 100, // Sufficient space for the floating island
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        alignment: Alignment.bottomCenter,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Glassmorphic Island
            ClipRRect(
              borderRadius: BorderRadius.circular(50), // Stadium Shape
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryAccent.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Left Item: Home
                      _buildNavItem(Icons.grid_view_rounded, 0),
                      
                      // Spacer for the center FAB
                      const SizedBox(width: 60),
                      
                      // Right Item: Settings (or Manage)
                      // Original code had 3 items: Home, Manage, Settings.
                      // Let's put Manage on the right for now, or match the user request.
                      _buildNavItem(Icons.settings_rounded, 2),
                    ],
                  ),
                ),
              ),
            ),
            
            // Breaking Boundary Floating Action Button (Clay Style)
            Positioned(
              top: -15, // Moves it up to break the boundary
              child: GestureDetector(
                onTap: () {
                   setState(() {
                     _selectedIndex = 1; // Go to Manage Cards
                   });
                },
                child: ClayCard(
                  width: 75,
                  height: 75,
                  borderRadius: 75,
                  color: AppTheme.primaryAccent,
                  depth: 15,
                  child: const Icon(
                    Icons.add_rounded, 
                    color: Colors.white, 
                    size: 40
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryAccent.withOpacity(0.1) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? AppTheme.primaryAccent : Colors.grey.shade400,
          size: 30, // Large icons
        ),
      ),
    );
  }
}
