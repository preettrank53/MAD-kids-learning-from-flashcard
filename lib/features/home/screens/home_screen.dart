import 'package:flutter/material.dart';

/// Home Screen
/// 
/// Main landing screen of the app showing categories and navigation.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kids Learning'),
      ),
      body: const Center(
        child: Text('Home Screen - Learning Categories will be displayed here'),
      ),
    );
  }
}
