import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/user_provider.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/gradient_button.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/validators.dart';
import '../signup/signup_screen.dart';
import '../dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final success = await userProvider.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
    );
    
    if (!mounted) return;
    setState(() => _isLoading = false);
    
    if (success) {
      // Check if profile is completed
      if (userProvider.user?.profileCompleted ?? false) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      } else {
        // Navigate to profiling
        // TODO: Navigate to profiling screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userProvider.error ?? 'Login failed'),
          backgroundColor: AppTheme.accentRed,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.softRose,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                const Center(child: AppLogo(size: 160)),
                const SizedBox(height: 24),
                Text(
                  'Your trusted companion\nfor balance & well-being',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 60),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email ID',
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter email' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: AppTheme.deepBlue,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter password' : null,
                ),
                const SizedBox(height: 48),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator(color: Colors.white))
                else
                  ElevatedButton(
                    onPressed: _handleLogin,
                    child: const Text('Login'),
                  ),
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: _isLoading ? null : () async {
                    setState(() => _isLoading = true);
                    final userProv = Provider.of<UserProvider>(context, listen: false);
                    final success = await userProv.enableGuestMode();
                    
                    if (!mounted) return;
                    setState(() => _isLoading = false);
                    
                    if (success) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const DashboardScreen()),
                        (route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(userProv.error ?? 'Guest login failed'),
                          backgroundColor: AppTheme.accentRed,
                        ),
                      );
                    }
                  },
                  child: const Text('Try as Guest (for demo)'),
                ),
                const SizedBox(height: 48),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SignUpScreen()),
                    );
                  },
                  child: Text(
                    'new user - sign up to register',
                    style: GoogleFonts.outfit(
                      color: AppTheme.deepBlue,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
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
