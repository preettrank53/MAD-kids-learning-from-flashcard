import 'package:flutter/material.dart';

/// Custom TextField Widget - Reusable Component
/// 
/// A bubbly, rounded text field with consistent styling across the app.
/// Features: Fully rounded corners, white background, themed icon color.
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool isPassword;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
    this.isPassword = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary, // Theme primary color
        ),
        
        // White background for contrast
        filled: true,
        fillColor: Colors.white,
        
        // Fully rounded corners (bubbly style)
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), // Very rounded
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            width: 2,
          ),
        ),
        
        // Enabled border (when not focused)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            width: 2,
          ),
        ),
        
        // Focused border (when typing)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2.5,
          ),
        ),
        
        // Error border
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
        
        // Focused error border
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2.5,
          ),
        ),
        
        // Padding inside the field
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }
}

/// Custom Button Widget - Reusable Component
/// 
/// An elevated button with high shadow, rounded corners, and consistent theming.
/// Features: Primary color background, white text, prominent shadow.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        // Primary color background
        backgroundColor: Theme.of(context).colorScheme.primary,
        
        // White text
        foregroundColor: Colors.white,
        
        // High elevation for prominent shadow
        elevation: 8,
        
        // Shadow color
        shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        
        // Rounded corners
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Fully rounded
        ),
        
        // Padding for comfortable size
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 16,
        ),
        
        // Minimum size for accessibility
        minimumSize: const Size(200, 56),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
