import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/gradient_button.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../dashboard/dashboard_screen.dart';

class ProfilingScreen extends StatefulWidget {
  const ProfilingScreen({super.key});
  
  @override
  State<ProfilingScreen> createState() => _ProfilingScreenState();
}

class _ProfilingScreenState extends State<ProfilingScreen> {
  int _currentStep = 0;
  final PageController _pageController = PageController();
  
  // Profile data
  final Map<String, dynamic> _profileData = {};
  
  final List<ProfileQuestion> _questions = [
    ProfileQuestion(
      category: 'Physical Health',
      questions: [
        'How would you rate your overall physical health?',
        'How many hours of sleep do you typically get?',
        'Do you engage in regular physical activity?',
        'How would you describe your energy levels throughout the day?',
      ],
      options: [
        ['Excellent', 'Good', 'Fair', 'Poor'],
        ['Less than 5 hours', '5-7 hours', '7-9 hours', 'More than 9 hours'],
        ['Daily', 'Few times a week', 'Rarely', 'Never'],
        ['Very High', 'High', 'Moderate', 'Low', 'Very Low'],
      ],
    ),
    ProfileQuestion(
      category: 'Emotional Well-being',
      questions: [
        'How often do you feel stressed?',
        'How would you describe your emotional state recently?',
        'Do you have time for yourself?',
        'How do you typically cope with stress?',
      ],
      options: [
        ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
        ['Very Happy', 'Happy', 'Neutral', 'Sad', 'Very Sad'],
        ['Daily', 'Few times a week', 'Rarely', 'Never'],
        ['Exercise', 'Meditation', 'Talking to someone', 'Rest', 'Other'],
      ],
    ),
    ProfileQuestion(
      category: 'Daily Responsibilities',
      questions: [
        'How would you describe your daily workload?',
        'How many hours per day do you typically work on household tasks?',
        'Do you have support with household responsibilities?',
        'How satisfied are you with your work-life balance?',
      ],
      options: [
        ['Very Light', 'Light', 'Moderate', 'Heavy', 'Very Heavy'],
        ['Less than 4 hours', '4-6 hours', '6-8 hours', 'More than 8 hours'],
        ['Always', 'Often', 'Sometimes', 'Rarely', 'Never'],
        ['Very Satisfied', 'Satisfied', 'Neutral', 'Dissatisfied', 'Very Dissatisfied'],
      ],
    ),
  ];
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  void _nextStep() {
    if (_currentStep < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeProfiling();
    }
  }
  
  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  Future<void> _completeProfiling() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    if (userProvider.user != null) {
      await userProvider.saveProfileData(_profileData);
    }
    
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightPink,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'PROFILE CREATION',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    'Please fill in the below details for me to analyze about you',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: (_currentStep + 1) / _questions.length,
                    backgroundColor: AppTheme.mediumGray,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryPurple),
                    minHeight: 8,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Step ${_currentStep + 1} of ${_questions.length}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            // Questions
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  return _buildQuestionPage(_questions[index], index);
                },
              ),
            ),
            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    OutlinedButton(
                      onPressed: _previousStep,
                      child: const Text('Back'),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 16),
                  Expanded(
                    child: GradientButton(
                      text: _currentStep < _questions.length - 1 ? 'Next' : 'Complete',
                      onPressed: _nextStep,
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
  
  Widget _buildQuestionPage(ProfileQuestion question, int stepIndex) {
    final answers = _profileData[question.category] ?? <String, String>{};
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.category,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryPurple,
            ),
          ),
          const SizedBox(height: 24),
          ...List.generate(question.questions.length, (qIndex) {
            return _buildQuestionItem(
              question.questions[qIndex],
              question.options[qIndex],
              question.category,
              qIndex,
              answers['q$qIndex'],
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildQuestionItem(
    String question,
    List<String> options,
    String category,
    int qIndex,
    String? selectedValue,
  ) {
    final key = '$category-q$qIndex';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...options.map((option) {
            final isSelected = selectedValue == option;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (!_profileData.containsKey(category)) {
                      _profileData[category] = {};
                    }
                    _profileData[category]['q$qIndex'] = option;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryPurple.withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryPurple : AppTheme.mediumGray,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSelected ? AppTheme.primaryPurple : AppTheme.mediumGray,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isSelected ? AppTheme.primaryPurple : AppTheme.textDark,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class ProfileQuestion {
  final String category;
  final List<String> questions;
  final List<List<String>> options;
  
  ProfileQuestion({
    required this.category,
    required this.questions,
    required this.options,
  });
}
