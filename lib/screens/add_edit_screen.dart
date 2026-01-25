import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../database/db_helper.dart';
// import '../database/mock_db_helper.dart';
import '../models/flashcard_model.dart';
import 'dart:math' as math;

class AddEditScreen extends StatefulWidget {
  final Flashcard? flashcard;
  
  const AddEditScreen({super.key, this.flashcard});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  bool _isLoading = false;
  int _selectedColorValue = 0xFFFF6B6B;

  final List<Color> _colors = [
    const Color(0xFFFF6B6B), // Red
    const Color(0xFFFF9F43), // Orange
    const Color(0xFFFECA57), // Yellow
    const Color(0xFF1DD1A1), // Green
    const Color(0xFF54A0FF), // Blue
    const Color(0xFF5f27cd), // Purple
  ];
  
  @override
  void initState() {
    super.initState();
    if (widget.flashcard != null) {
      _titleController.text = widget.flashcard!.title;
      _categoryController.text = widget.flashcard!.category;
      _selectedColorValue = widget.flashcard!.colorValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: Text(
          widget.flashcard == null ? 'Create New Card' : 'Edit Card',
          style: GoogleFonts.fredoka(color: Colors.black, fontSize: 24),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // =================================
              // CARD PREVIEW
              // =================================
              Center(
                child: Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Decorative corner
                      Positioned(
                        top: -20,
                        right: -20,
                        child: Transform.rotate(
                          angle: 0.5,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color(_selectedColorValue).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(_selectedColorValue).withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.wb_incandescent_rounded, 
                              color: Color(_selectedColorValue), 
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              _titleController.text.isEmpty ? 'Your Word' : _titleController.text,
                              style: GoogleFonts.fredoka(
                                fontSize: 28,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _categoryController.text.isEmpty ? 'Category' : _categoryController.text.toUpperCase(),
                            style: GoogleFonts.nunito(
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // =================================
              // INPUT FIELDS
              // =================================
              Text(
                'Card Details',
                style: GoogleFonts.fredoka(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 12),
              
              // Title Input
              _buildInputField(
                controller: _titleController,
                hint: 'What word?',
                icon: Icons.edit_rounded,
                onChanged: (val) => setState(() {}),
              ),
              
              const SizedBox(height: 16),
              
              // Category Input
              _buildInputField(
                controller: _categoryController,
                hint: 'Category (e.g. Animals)',
                icon: Icons.category_rounded,
                onChanged: (val) => setState(() {}),
              ),
              
              const SizedBox(height: 30),
              
              // =================================
              // COLOR PICKER
              // =================================
              Text(
                'Pick a Color',
                style: GoogleFonts.fredoka(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _colors.map((color) {
                    bool isSelected = _selectedColorValue == color.value;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColorValue = color.value),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                          boxShadow: isSelected ? [
                             BoxShadow(color: color.withOpacity(0.5), blurRadius: 10, offset: const Offset(0,4))
                          ] : null,
                        ),
                        child: isSelected ? const Icon(Icons.check_rounded, color: Colors.white, size: 24) : null,
                      ),
                    );
                  }).toList(),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // =================================
              // SAVE BUTTON
              // =================================
               SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    elevation: 10,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: _isLoading 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(widget.flashcard == null ? Icons.add_rounded : Icons.save_rounded, color: Colors.white),
                          const SizedBox(width: 12),
                          Text(
                            widget.flashcard == null ? 'Create Card' : 'Save Changes',
                            style: GoogleFonts.fredoka(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller, 
    required String hint, 
    required IconData icon,
    Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade300, fontSize: 18),
          prefixIcon: Icon(icon, color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Required';
          return null;
        },
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final card = Flashcard(
        id: widget.flashcard?.id,
        title: _titleController.text.trim(),
        category: _categoryController.text.trim(), // Keep original case or title case
        colorValue: _selectedColorValue,
      );

      if (widget.flashcard == null) {
        await DatabaseHelper.instance.insertFlashcard(card);
        // await MockDatabaseHelper.instance.insertFlashcard(card);
      } else {
        await DatabaseHelper.instance.updateFlashcard(card);
        // await MockDatabaseHelper.instance.updateFlashcard(card);
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
         setState(() => _isLoading = false);
      }
    }
  }
}
