import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class EmotionalSupportScreen extends StatefulWidget {
  const EmotionalSupportScreen({super.key});
  
  @override
  State<EmotionalSupportScreen> createState() => _EmotionalSupportScreenState();
}

class _EmotionalSupportScreenState extends State<EmotionalSupportScreen> {
  final _journalController = TextEditingController();
  final List<String> _affirmations = [
    'You are doing your best, and that is enough.',
    'Your feelings are valid, and it\'s okay to feel this way.',
    'You deserve rest and self-care.',
    'Taking care of yourself is not selfish; it\'s necessary.',
    'You are strong, capable, and valued.',
    'It\'s okay to ask for help when you need it.',
    'You are making a difference, even when it doesn\'t feel like it.',
    'Every day is a new opportunity to care for yourself.',
    'Your well-being matters.',
    'You are worthy of love and support.',
  ];
  
  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final dailyAffirmation = _affirmations[DateTime.now().day % _affirmations.length];
    
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
          'Emotional Support',
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
              // Daily Affirmation
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.favorite,
                        color: AppTheme.primaryPurple,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Today\'s Affirmation',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        dailyAffirmation,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Validation messages
              Text(
                'You are not alone',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildValidationCard(
                'Your feelings are valid',
                'It\'s okay to feel overwhelmed, tired, or stressed. Your emotions are valid, and you don\'t need to justify them.',
                Icons.sentiment_satisfied_alt,
              ),
              const SizedBox(height: 12),
              _buildValidationCard(
                'Self-care is essential',
                'Taking time for yourself is not selfish. It\'s necessary for your well-being and ability to care for others.',
                Icons.spa,
              ),
              const SizedBox(height: 12),
              _buildValidationCard(
                'You are doing great',
                'Every day you show up, you\'re making a difference. Recognize your efforts and be kind to yourself.',
                Icons.celebration,
              ),
              const SizedBox(height: 24),
              // Journaling section
              Text(
                'Journaling (Optional)',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Take a moment to write down your thoughts and feelings. This is a safe, non-judgmental space.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textLight,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _journalController,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: 'Write your thoughts here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  if (_journalController.text.trim().isNotEmpty) {
                    // Save journal entry
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Journal entry saved'),
                        backgroundColor: AppTheme.burnoutLowColor,
                      ),
                    );
                    _journalController.clear();
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text('Save Entry'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildValidationCard(String title, String message, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryPurple,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textLight,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
