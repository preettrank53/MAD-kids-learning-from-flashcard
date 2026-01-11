import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart';

/// Login Screen - User Authentication
/// 
/// This screen provides the login interface for users to authenticate.
/// Features: Email/password login, password visibility toggle, form validation.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  
  // Text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Password visibility toggle state
  bool _isPasswordVisible = false;
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  /// Handle login button press
  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Login successful! Email: ${_emailController.text}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      
      // Navigate to dashboard using named route (cleaner navigation)
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }
  
  /// Handle create account button press
  void _handleCreateAccount() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎉 Create Account feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
    // TODO: Navigate to signup screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SafeArea prevents content from going under system UI
      body: SafeArea(
        child: Center(
          // SingleChildScrollView prevents overflow when keyboard appears
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ============================================================
                    // LOGO - App branding
                    // ============================================================
                    Icon(
                      Icons.school,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // ============================================================
                    // TITLE - Welcome message
                    // ============================================================
                    Text(
                      'Welcome Back!',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'Login to continue learning',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // ============================================================
                    // EMAIL FIELD - Using CustomTextField
                    // ============================================================
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'Email Address',
                      icon: Icons.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // ============================================================
                    // PASSWORD FIELD - Using CustomTextField with visibility toggle
                    // ============================================================
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible, // Toggle based on state
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        
                        // Eye icon to toggle password visibility
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () {
                            // Toggle password visibility using setState
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        
                        // White background for contrast
                        filled: true,
                        fillColor: Colors.white,
                        
                        // Fully rounded corners (bubbly style)
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.5,
                          ),
                        ),
                        
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error,
                            width: 2,
                          ),
                        ),
                        
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error,
                            width: 2.5,
                          ),
                        ),
                        
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // ============================================================
                    // LOGIN BUTTON - Using CustomButton
                    // ============================================================
                    Center(
                      child: CustomButton(
                        text: 'Login',
                        onPressed: _handleLogin,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // ============================================================
                    // FOOTER - Create account link
                    // ============================================================
                    TextButton(
                      onPressed: _handleCreateAccount,
                      child: Text(
                        "Don't have an account? Create one",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
