import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/gradient_button.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/validators.dart';
import '../auth/otp_verification_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  String _selectedLanguage = AppConstants.langEnglish;
  bool _useEmail = true;
  bool _showOTPField = false;
  bool _isLoading = false;
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }
  
  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_useEmail) {
      // For email signup, we'll use email/password auth
      // For MVP, skip OTP verification for email
      await _signUpWithEmail();
    } else {
      // For phone signup, show OTP field
      if (!_showOTPField) {
        setState(() => _showOTPField = true);
        // TODO: Send OTP
        return;
      }
      // Verify OTP and sign up
      await _signUpWithPhone();
    }
  }
  
  Future<void> _signUpWithEmail() async {
    setState(() => _isLoading = true);
    
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // Generate a temporary password or use email link
    // For MVP, use a simple approach
    const tempPassword = 'Temp123!'; // In production, use email verification link
    
    final success = await userProvider.signUpWithEmail(
      _emailController.text.trim(),
      tempPassword,
      _nameController.text.trim(),
    );
    
    if (!mounted) return;
    setState(() => _isLoading = false);
    
    if (success) {
      // Update language preference
      await userProvider.setLanguage(_selectedLanguage);
      // Navigate to dashboard or profiling
      // TODO: Navigate to appropriate screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userProvider.error ?? 'Sign up failed'),
          backgroundColor: AppTheme.accentRed,
        ),
      );
    }
  }
  
  Future<void> _signUpWithPhone() async {
    setState(() => _isLoading = true);
    
    // TODO: Implement phone OTP verification
    // For now, show OTP verification screen
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OTPVerificationScreen(
          phoneNumber: _phoneController.text.trim(),
          onVerified: () {
            // Handle verified signup
          },
        ),
      ),
    );
    
    setState(() => _isLoading = false);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightPink,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Sign up to become Thozhi\'s friend',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your name',
                    prefixIcon: Icon(Icons.person_outlined),
                  ),
                  validator: (value) => Validators.validateRequired(value, fieldName: 'Name'),
                ),
                const SizedBox(height: 24),
                // Sign up method selection
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Email'),
                        selected: _useEmail,
                        onSelected: (selected) {
                          setState(() {
                            _useEmail = true;
                            _showOTPField = false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Phone'),
                        selected: !_useEmail,
                        onSelected: (selected) {
                          setState(() {
                            _useEmail = false;
                            _showOTPField = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (_useEmail) ...[
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: Validators.validateEmail,
                  ),
                ] else ...[
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Mobile Number',
                      hintText: 'Enter your mobile number',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: Validators.validatePhone,
                  ),
                  const SizedBox(height: 16),
                  if (_showOTPField)
                    TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Verification Code (OTP)',
                        hintText: 'Enter the 6-digit code',
                        prefixIcon: Icon(Icons.lock_outlined),
                      ),
                      validator: Validators.validateOTP,
                    ),
                ],
                const SizedBox(height: 24),
                // Language selection
                Text(
                  'Please choose your preferred language',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedLanguage,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.language),
                  ),
                  items: [
                    AppConstants.langEnglish,
                    AppConstants.langTamil,
                  ].map((lang) {
                    return DropdownMenuItem(
                      value: lang,
                      child: Text(lang),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 32),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  GradientButton(
                    text: _showOTPField ? 'Verify & Sign Up' : 'Sign Up',
                    onPressed: _handleSignUp,
                  ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // Skip for demo
                    Navigator.of(context).pop();
                  },
                  child: const Text('Skip this option for now (for demo)'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
