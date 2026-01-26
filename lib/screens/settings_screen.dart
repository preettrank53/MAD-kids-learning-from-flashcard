import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  // Theme Constants based on "Strict Blue/Yellow Theme"
  final Color electricBlue = const Color(0xFF007AFF);
  final Color boldYellow = const Color(0xFFFFD300);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Parent Zone',
          style: GoogleFonts.fredoka(color: Colors.black, fontSize: 24),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
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
              decoration: InputDecoration(
                labelText: "Child's Name",
                labelStyle: TextStyle(color: electricBlue),
                prefixIcon: Icon(Icons.face_rounded, color: electricBlue),
                // Blue Border Styling
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: electricBlue.withOpacity(0.3), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: electricBlue, width: 2),
                ),
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
                border: Border.all(color: electricBlue.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: SwitchListTile(
                title: const Text('Background Music'),
                subtitle: const Text('Play gentle music while learning'),
                value: _isMusicOn,
                activeColor: boldYellow, // Yellow when active
                secondary: Icon(Icons.music_note_rounded, color: electricBlue),
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
                border: Border.all(color: electricBlue.withOpacity(0.3)),
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
                         style: TextStyle(color: electricBlue, fontWeight: FontWeight.bold),
                       ),
                     ],
                   ),
                   Slider(
                    value: _dailyGoal,
                    min: 5,
                    max: 50,
                    divisions: 9, // Steps of 5 (approx)
                    label: _dailyGoal.round().toString(),
                    activeColor: boldYellow, // Yellow when active
                    inactiveColor: Colors.grey.shade200,
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
              decoration: InputDecoration(
                labelText: 'Difficulty Level',
                labelStyle: TextStyle(color: electricBlue),
                prefixIcon: Icon(Icons.school_rounded, color: electricBlue),
                // Blue Border Styling
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: electricBlue.withOpacity(0.3), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: electricBlue, width: 2),
                ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: electricBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                ),
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

  /// Helper mainly for Section Headers (Strict Blue)
  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.nunito(
        color: electricBlue,
        fontWeight: FontWeight.w900,
        fontSize: 14,
        letterSpacing: 1.2,
      ),
    );
  }
}
