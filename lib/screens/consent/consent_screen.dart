import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/gradient_button.dart';
import '../../core/theme/app_theme.dart';
import '../auth/login_screen.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});
  
  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool _consentGiven = false;
  
  void _handleConsent() {
    if (!_consentGiven) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please read and accept the consent to continue'),
          backgroundColor: AppTheme.accentRed,
        ),
      );
      return;
    }
    
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setConsent(true);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Consent & Privacy',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Privacy Matters',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildConsentItem(
                        'We collect only necessary data to provide you with personalized wellness insights.',
                      ),
                      const SizedBox(height: 12),
                      _buildConsentItem(
                        'Your data is stored securely and is never shared with third parties without your explicit consent.',
                      ),
                      const SizedBox(height: 12),
                      _buildConsentItem(
                        'You can delete your data or account at any time from the settings.',
                      ),
                      const SizedBox(height: 12),
                      _buildConsentItem(
                        'This app is not a substitute for professional medical advice. Please consult healthcare professionals for medical concerns.',
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Data Collection',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildConsentItem(
                        'Daily check-in responses (stress, energy, mood, sleep, activity, workload)',
                      ),
                      const SizedBox(height: 8),
                      _buildConsentItem(
                        'Profile information you provide during onboarding',
                      ),
                      const SizedBox(height: 8),
                      _buildConsentItem(
                        'Usage data to improve the app experience',
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Ethical Commitment',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildConsentItem(
                        'No ads will be shown in this app',
                      ),
                      const SizedBox(height: 8),
                      _buildConsentItem(
                        'We will never sell your data',
                      ),
                      const SizedBox(height: 8),
                      _buildConsentItem(
                        'Privacy-first design with transparency and user control',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Checkbox(
                    value: _consentGiven,
                    onChanged: (value) {
                      setState(() {
                        _consentGiven = value ?? false;
                      });
                    },
                    activeColor: AppTheme.primaryPurple,
                  ),
                  Expanded(
                    child: Text(
                      'I have read and understood the consent information above, and I agree to proceed.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              GradientButton(
                text: 'I Agree - Continue',
                onPressed: _handleConsent,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildConsentItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle,
          color: AppTheme.primaryPurple,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
