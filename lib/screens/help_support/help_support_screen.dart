import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});
  
  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final List<FAQItem> _faqs = [
    FAQItem(
      question: 'How does burnout prediction work?',
      answer: 'Our app analyzes your daily check-ins, including stress levels, energy, mood, sleep, activity, and workload. Based on these patterns, we calculate your burnout risk level using a combination of factors. The system looks at trends over the past week to provide accurate assessments.',
    ),
    FAQItem(
      question: 'Is my data secure?',
      answer: 'Yes, your data is stored securely using Firebase with industry-standard encryption. We never share your data with third parties, and you can delete your data at any time from the settings.',
    ),
    FAQItem(
      question: 'Is this app a replacement for professional help?',
      answer: 'No, Thozhi is not a substitute for professional medical or mental health advice. If you\'re experiencing severe symptoms or crisis, please contact a healthcare professional or emergency services immediately.',
    ),
    FAQItem(
      question: 'How often should I complete my daily check-in?',
      answer: 'We recommend completing your daily check-in once per day, ideally in the evening. However, you can do it at any time that\'s convenient for you. Consistent check-ins help provide more accurate burnout predictions.',
    ),
    FAQItem(
      question: 'Can I customize my notifications?',
      answer: 'Yes, you can customize your notification preferences in the Profile & Settings screen. You can enable or disable burnout alerts, self-care reminders, and daily check-in reminders.',
    ),
    FAQItem(
      question: 'What should I do if my burnout risk is high?',
      answer: 'If your burnout risk is high, please prioritize rest and self-care. Consider reaching out to friends, family, or professional support. The app will provide personalized recommendations based on your risk level. Remember: asking for help is a strength, not a weakness.',
    ),
  ];
  
  final List<EmergencyResource> _emergencyResources = [
    EmergencyResource(
      title: 'Emergency Mental Health Services',
      phone: '988',
      description: 'National Suicide Prevention Lifeline (24/7)',
    ),
    EmergencyResource(
      title: 'Crisis Text Line',
      phone: 'Text HOME to 741741',
      description: 'Free, 24/7 crisis support via text',
    ),
    EmergencyResource(
      title: 'National Domestic Violence Hotline',
      phone: '1-800-799-7233',
      description: '24/7 support for domestic violence',
    ),
  ];
  
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
        title: Text(
          'Help & Support',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emergency resources
              Card(
                color: AppTheme.accentRed.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.emergency, color: AppTheme.accentRed),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Emergency Resources',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.accentRed,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ..._emergencyResources.map((resource) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildEmergencyResourceCard(resource),
                      )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // FAQs
              Text(
                'Frequently Asked Questions',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ..._faqs.map((faq) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildFAQCard(faq),
              )),
              const SizedBox(height: 24),
              // App disclaimer
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'App Disclaimer',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Thozhi is a wellness application designed to help homemakers track their well-being and predict burnout risk. This app is not intended to diagnose, treat, cure, or prevent any disease or mental health condition. Always consult with qualified healthcare professionals for medical advice, diagnosis, or treatment.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textLight,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'If you are experiencing a medical emergency or mental health crisis, please contact emergency services immediately.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.accentRed,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Contact support
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _contactSupport();
                  },
                  icon: const Icon(Icons.email),
                  label: const Text('Contact Support'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildEmergencyResourceCard(EmergencyResource resource) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resource.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              resource.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textLight,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                _callEmergency(resource.phone);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.accentRed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.phone, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      resource.phone,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFAQCard(FAQItem faq) {
    bool isExpanded = false;
    
    return StatefulBuilder(
      builder: (context, setState) {
        return Card(
          child: ExpansionTile(
            title: Text(
              faq.question,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  faq.answer,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textLight,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _callEmergency(String phone) {
    // Remove non-digit characters for phone calls
    final phoneNumber = phone.replaceAll(RegExp(r'[^\d+]'), '');
    launchUrl(Uri.parse('tel:$phoneNumber'));
  }
  
  void _contactSupport() {
    launchUrl(Uri.parse('mailto:support@thozhi.app?subject=Support Request'));
  }
}

class FAQItem {
  final String question;
  final String answer;
  
  FAQItem({
    required this.question,
    required this.answer,
  });
}

class EmergencyResource {
  final String title;
  final String phone;
  final String description;
  
  EmergencyResource({
    required this.title,
    required this.phone,
    required this.description,
  });
}
