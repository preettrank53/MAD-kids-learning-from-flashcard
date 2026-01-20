import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/flashcard_model.dart';

/// Add/Edit Flashcard Screen
/// 
/// This screen allows users to create new flashcards or edit existing ones.
/// Lab 6 Phase 3: CREATE operation UI
/// 
/// Features:
/// - Form validation for title and category
/// - Save flashcard to SQLite database
/// - Return success status to refresh previous screen
class AddEditScreen extends StatefulWidget {
  /// Optional flashcard to edit (null for new flashcard)
  final Flashcard? flashcard;
  
  const AddEditScreen({super.key, this.flashcard});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  
  // Text controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  
  // Loading state
  bool _isLoading = false;
  
  // Selected color for the flashcard
  int _selectedColorValue = 0xFFFF6B6B; // Default: Soft Red
  
  // Available colors for flashcards
  final List<Map<String, dynamic>> _availableColors = const [
    {'name': 'Red', 'value': 0xFFFF6B6B},
    {'name': 'Blue', 'value': 0xFF6FB3E0},
    {'name': 'Green', 'value': 0xFF98D8C8},
    {'name': 'Orange', 'value': 0xFFFFB347},
    {'name': 'Purple', 'value': 0xFFB19CD9},
    {'name': 'Yellow', 'value': 0xFFFFD93D},
  ];
  
  @override
  void initState() {
    super.initState();
    
    // If editing, populate fields with existing data
    if (widget.flashcard != null) {
      _titleController.text = widget.flashcard!.title;
      _categoryController.text = widget.flashcard!.category;
      _selectedColorValue = widget.flashcard!.colorValue;
    }
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    super.dispose();
  }
  
  /// Handle save button press
  Future<void> _handleSave() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    // Show loading
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Create Flashcard object
      Flashcard flashcard = Flashcard(
        id: widget.flashcard?.id, // null for new, existing id for edit
        title: _titleController.text.trim(),
        category: _categoryController.text.trim(),
        colorValue: _selectedColorValue,
      );
      
      // Save to database
      if (widget.flashcard == null) {
        // CREATE - Insert new flashcard
        await DatabaseHelper.instance.insertFlashcard(flashcard);
      } else {
        // UPDATE - Update existing flashcard
        await DatabaseHelper.instance.updateFlashcard(flashcard);
      }
      
      // Show success message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.flashcard == null
                ? '✅ Flashcard created successfully!'
                : '✅ Flashcard updated successfully!',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      
      // Return true to indicate success and trigger refresh
      Navigator.pop(context, true);
      
    } catch (e) {
      // Hide loading
      setState(() {
        _isLoading = false;
      });
      
      // Show error message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ====================================================================
      // APP BAR
      // ====================================================================
      appBar: AppBar(
        title: Text(widget.flashcard == null ? 'Add Flashcard' : 'Edit Flashcard'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      
      // ====================================================================
      // BODY - Form
      // ====================================================================
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ============================================================
                // TITLE FIELD
                // ============================================================
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Card Title',
                    hintText: 'e.g., Lion, Apple, Circle',
                    prefixIcon: Icon(
                      Icons.title,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    if (value.trim().length < 2) {
                      return 'Title must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                
                // ============================================================
                // CATEGORY FIELD
                // ============================================================
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    hintText: 'e.g., Animals, Fruits, Shapes',
                    prefixIcon: Icon(
                      Icons.category,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a category';
                    }
                    if (value.trim().length < 2) {
                      return 'Category must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 30),
                
                // ============================================================
                // COLOR PICKER
                // ============================================================
                Text(
                  'Choose Color:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                
                const SizedBox(height: 12),
                
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _availableColors.map((colorData) {
                    bool isSelected = _selectedColorValue == colorData['value'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColorValue = colorData['value'] as int;
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color(colorData['value'] as int),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Colors.black
                                : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 30,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 40),
                
                // ============================================================
                // SAVE BUTTON
                // ============================================================
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
                    : ElevatedButton(
                        onPressed: _handleSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          widget.flashcard == null ? 'Save Flashcard' : 'Update Flashcard',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
