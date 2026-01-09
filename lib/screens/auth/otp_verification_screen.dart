import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/gradient_button.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/validators.dart';
import '../dashboard/dashboard_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final VoidCallback? onVerified;
  
  const OTPVerificationScreen({
    super.key,
    required this.phoneNumber,
    this.onVerified,
  });
  
  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  String? _verificationId; // This should be stored from the sign-in process
  
  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
  
  Future<void> _handleVerifyOTP() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    // TODO: Get verificationId from auth service
    // For MVP, we'll simulate OTP verification
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // In real implementation:
    // final success = await userProvider.verifyOTP(_verificationId!, _otpController.text);
    
    // For demo, simulate success
    await Future.delayed(const Duration(seconds: 1));
    
    if (!mounted) return;
    setState(() => _isLoading = false);
    
    // Navigate based on profile completion
    if (userProvider.user?.profileCompleted ?? false) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      // Navigate to profiling
      // TODO: Navigate to profiling screen
      widget.onVerified?.call();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
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
                const SizedBox(height: 40),
                Text(
                  'Verify Phone Number',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'We sent a verification code to',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.phoneNumber,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    letterSpacing: 8,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Enter OTP',
                    hintText: '000000',
                    prefixIcon: Icon(Icons.lock_outlined),
                    helperText: 'Enter the 6-digit code sent to your phone',
                  ),
                  validator: Validators.validateOTP,
                  maxLength: 6,
                ),
                const SizedBox(height: 24),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  GradientButton(
                    text: 'Verify',
                    onPressed: _handleVerifyOTP,
                  ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // Resend OTP
                  },
                  child: const Text('Resend Code'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
