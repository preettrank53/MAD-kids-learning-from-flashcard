import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/theme.dart';

/// Settings Screen - Parent Zone
/// 
/// This screen demonstrates "Forms & Interactive Controls" (Lab 7).
/// It allows parents to configure app settings using various input widgets.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State Variables
  final TextEditingController _nameController = TextEditingController(text: "Leo");
  bool _isMusicOn = true;
  double _dailyGoal = 10;
  String? _difficultyLevel = 'Preschool';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Zone'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================================
            // 1. Text Field: Child's Name
            // ============================================
            _buildSectionHeader('Profile Settings'),
            const SizedBox(height: 16),
            
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Child's Name",
                prefixIcon: Icon(Icons.face_rounded),
              ),
            ),

            const SizedBox(height: 32),

            // ============================================
            // 2. Switch: Background Music
            // ============================================
            _buildSectionHeader('Audio Preferences'),
            const SizedBox(height: 8),
            
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.primaryAccent.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: SwitchListTile(
                title: const Text('Background Music'),
                subtitle: const Text('Play gentle music while learning'),
                value: _isMusicOn,
                secondary: const Icon(Icons.music_note_rounded, color: AppTheme.primaryAccent),
                onChanged: (bool value) {
                  setState(() {
                    _isMusicOn = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 32),

            // ============================================
            // 3. Slider: Daily Card Goal
            // ============================================
            _buildSectionHeader('Learning Goals'),
            const SizedBox(height: 8),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.primaryAccent.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text('Daily Card Goal', style: TextStyle(color: Colors.grey.shade700)),
                       Text(
                         '${_dailyGoal.round()} Cards', 
                         style: const TextStyle(color: AppTheme.primaryAccent, fontWeight: FontWeight.bold),
                       ),
                     ],
                   ),
                   Slider(
                    value: _dailyGoal,
                    min: 5,
                    max: 50,
                    divisions: 9, // Steps of 5 (approx)
                    label: _dailyGoal.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _dailyGoal = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ============================================
            // 4. Dropdown: Difficulty Level
            // ============================================
            _buildSectionHeader('Curriculum'),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              value: _difficultyLevel,
              decoration: const InputDecoration(
                labelText: 'Difficulty Level',
                prefixIcon: Icon(Icons.school_rounded),
              ),
              items: ['Toddler', 'Preschool', 'Kindergarten']
                  .map((String level) {
                return DropdownMenuItem<String>(
                  value: level,
                  child: Text(level),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _difficultyLevel = newValue;
                });
              },
            ),
            
            const SizedBox(height: 48),
            
            // Save Button (Visual only)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings Saved!')),
                  );
                },
                child: Text(
                  'Save Changes',
                  style: GoogleFonts.fredoka(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper mainly for Section Headers
  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.fredoka(
        color: AppTheme.primaryAccent,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        letterSpacing: 1.0,
      ),
    );
  }
}
