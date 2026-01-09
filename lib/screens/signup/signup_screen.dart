import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/user_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../dashboard/dashboard_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  String _selectedLanguage = 'English(US)';
  bool _isLoading = false;
  
  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.softRose,
      body: SafeArea(
        child: Column(
          children: [
            // Header Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Text(
                'Sign up to become Thozhi\'s friend',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.deepBlue,
                ),
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildInputLabel('sign up with mobile number'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(hintText: ''),
                      ),
                      
                      const SizedBox(height: 16),
                      Text(
                        'or',
                        style: GoogleFonts.outfit(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildInputLabel('sign up with email id'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(hintText: ''),
                      ),
                      
                      const SizedBox(height: 32),
                      _buildInputLabel('enter the verification code/ OTP'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: ''),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Language Selector
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'please choose your preferred language',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 14,
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<String>(
                                value: _selectedLanguage,
                                isExpanded: true,
                                underline: const SizedBox(),
                                icon: const Icon(Icons.arrow_drop_down, color: AppTheme.deepBlue),
                                style: GoogleFonts.outfit(color: AppTheme.deepBlue, fontWeight: FontWeight.w500),
                                items: ['English(US)', 'தமிழ்'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedLanguage = val);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 60),
                      
                      // Skip/Demo Button
                      OutlinedButton(
                        onPressed: () {
                          final userProv = Provider.of<UserProvider>(context, listen: false);
                          userProv.enableGuestMode();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const DashboardScreen()),
                            (route) => false,
                          );
                        },
                        child: Text(
                          'Skip this option for now\n(for demo)',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(height: 1.2),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.outfit(
        fontSize: 16,
        color: Colors.black.withOpacity(0.7),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
