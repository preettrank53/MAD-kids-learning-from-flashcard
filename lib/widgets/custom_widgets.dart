import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'clay_card.dart';


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

/// Custom Button Widget - Claymorphism Style
/// 
/// A soft, 3D button that depresses when clicked.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClayCard(
        onTap: onPressed,
        borderRadius: 30,
        color: color ?? Theme.of(context).colorScheme.primary,
        depth: 15,
        spread: 2,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor ?? Colors.white,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}
