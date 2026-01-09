import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/user_provider.dart';
import '../../core/theme/app_theme.dart';
import '../dashboard/dashboard_screen.dart';

class ProfilingScreen extends StatefulWidget {
  const ProfilingScreen({super.key});
  
  @override
  State<ProfilingScreen> createState() => _ProfilingScreenState();
}

class _ProfilingScreenState extends State<ProfilingScreen> {
  int _currentStep = 0;
  final PageController _pageController = PageController();
  final Map<String, dynamic> _profileData = {};
  
  final List<ProfileQuestion> _questions = [
    ProfileQuestion(
      category: 'Physical Health',
      instructions: 'please fill in the below details for me to analyze about you',
      questions: [
        'How would you rate your overall physical health?',
        'How many hours of sleep do you typically get?',
        'Do you engage in regular physical activity?',
        'How would you describe your energy levels?',
      ],
      options: [
        ['Excellent', 'Good', 'Fair', 'Poor'],
        ['Less than 5 hours', '5-7 hours', '7-9 hours', 'More than 9 hours'],
        ['Daily', 'Few times a week', 'Rarely', 'Never'],
        ['Very High', 'High', 'Moderate', 'Low'],
      ],
    ),
    ProfileQuestion(
      category: 'Emotional Well-being',
      instructions: 'now let\'s look at your emotional state',
      questions: [
        'How often do you feel stressed?',
        'How would you describe your mood recently?',
        'Do you have time for yourself?',
        'How do you typically cope with stress?',
      ],
      options: [
        ['Never', 'Rarely', 'Sometimes', 'Often', 'Always'],
        ['Very Happy', 'Happy', 'Neutral', 'Sad'],
        ['Daily', 'Few times a week', 'Rarely', 'Never'],
        ['Exercise', 'Meditation', 'Socializing', 'Rest'],
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
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _completeProfiling();
    }
  }
  
  Future<void> _completeProfiling() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.saveProfileData(_profileData);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const DashboardScreen()));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.softRose,
      appBar: AppBar(
        title: Text(
          'PROFILE CREATION',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: 1.2),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: (_currentStep + 1) / _questions.length,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentBlue),
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _questions[_currentStep].instructions,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            
            // Question Container (Grey box from image)
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentStep = index),
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    return _buildQuestionList(_questions[index]);
                  },
                ),
              ),
            ),
            
            // Navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: ElevatedButton(
                onPressed: _nextStep,
                child: Text(_currentStep < _questions.length - 1 ? 'Next' : 'Complete'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildQuestionList(ProfileQuestion question) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: question.questions.length,
      itemBuilder: (context, qIndex) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.questions[qIndex],
                style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 15, color: AppTheme.logoBlue),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: question.options[qIndex].map((opt) {
                  final isSelected = _profileData[question.category]?['q$qIndex'] == opt;
                  return ChoiceChip(
                    label: Text(opt),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        if (!_profileData.containsKey(question.category)) _profileData[question.category] = {};
                        _profileData[question.category]['q$qIndex'] = opt;
                      });
                    },
                    selectedColor: AppTheme.accentBlue.withOpacity(0.3),
                    labelStyle: GoogleFonts.outfit(
                      color: isSelected ? AppTheme.deepBlue : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProfileQuestion {
  final String category;
  final String instructions;
  final List<String> questions;
  final List<List<String>> options;
  
  ProfileQuestion({
    required this.category,
    required this.instructions,
    required this.questions,
    required this.options,
  });
}
