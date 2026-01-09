import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/burnout_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/burnout_model.dart';

class InterventionsScreen extends StatefulWidget {
  const InterventionsScreen({super.key});
  
  @override
  State<InterventionsScreen> createState() => _InterventionsScreenState();
}

class _InterventionsScreenState extends State<InterventionsScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final burnoutProvider = Provider.of<BurnoutProvider>(context, listen: false);
    
    final burnout = burnoutProvider.currentBurnout;
    final riskLevel = burnout?.level ?? BurnoutLevel.low;
    
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
          'Intervention & Recommendation Page',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer2<UserProvider, BurnoutProvider>(
          builder: (context, userProvider, burnoutProvider, child) {
            final burnout = burnoutProvider.currentBurnout;
            final riskLevel = burnout?.level ?? BurnoutLevel.low;
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personalization note
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.mediumGray.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppTheme.primaryBlue, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Personalized for: ${burnout?.levelString ?? 'Low'} Risk Level',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Recommendations list
                  ..._buildRecommendations(riskLevel),
                  const SizedBox(height: 32),
                  // Connect with support button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to support
                      },
                      icon: const Icon(Icons.help_outline),
                      label: const Text('? Connect with Support'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.darkGray,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  
  List<Widget> _buildRecommendations(BurnoutLevel level) {
    final recommendations = _getRecommendationsForLevel(level);
    
    return recommendations.map((rec) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: _buildRecommendationCard(rec),
      );
    }).toList();
  }
  
  List<Recommendation> _getRecommendationsForLevel(BurnoutLevel level) {
    if (level == BurnoutLevel.high) {
      return [
        Recommendation(
          title: 'Suggested Rest Activities',
          icon: Icons.bed,
          color: AppTheme.primaryBlue,
          suggestions: [
            'Take a 15-minute break every hour',
            'Practice deep breathing exercises',
            'Listen to calming music',
            'Take a short nap if possible',
            'Do gentle stretching',
          ],
        ),
        Recommendation(
          title: 'Gentle Exercise Ideas',
          icon: Icons.fitness_center,
          color: AppTheme.burnoutLowColor,
          suggestions: [
            '10-minute morning walk',
            'Light yoga or stretching',
            'Gentle breathing exercises',
            'Household chores as light movement',
          ],
        ),
        Recommendation(
          title: 'Breathing / Mindfulness Tips',
          icon: Icons.self_improvement,
          color: AppTheme.accentYellow,
          suggestions: [
            '4-7-8 breathing: Inhale 4, Hold 7, Exhale 8',
            '5-minute meditation',
            'Body scan relaxation',
            'Progressive muscle relaxation',
          ],
        ),
        Recommendation(
          title: 'Ask for Help Encouragement',
          icon: Icons.help_outline,
          color: AppTheme.accentOrange,
          suggestions: [
            'Talk to a trusted friend or family member',
            'Share your feelings with someone you trust',
            'Consider professional support if needed',
            'Remember: Asking for help is a strength, not a weakness',
          ],
        ),
        Recommendation(
          title: 'Community Support Suggestions',
          icon: Icons.people_outline,
          color: AppTheme.primaryPurple,
          suggestions: [
            'Join local homemaker support groups',
            'Connect with others who understand',
            'Share experiences in safe spaces',
            'Build your support network',
          ],
        ),
      ];
    } else if (level == BurnoutLevel.medium) {
      return [
        Recommendation(
          title: 'Suggested Rest Activities',
          icon: Icons.bed,
          color: AppTheme.primaryBlue,
          suggestions: [
            'Take regular short breaks',
            'Practice breathing exercises',
            'Listen to your favorite music',
            'Gentle stretching',
          ],
        ),
        Recommendation(
          title: 'Gentle Exercise Ideas',
          icon: Icons.fitness_center,
          color: AppTheme.burnoutLowColor,
          suggestions: [
            '15-minute walk',
            'Light yoga',
            'Stretching exercises',
          ],
        ),
        Recommendation(
          title: 'Breathing / Mindfulness Tips',
          icon: Icons.self_improvement,
          color: AppTheme.accentYellow,
          suggestions: [
            'Deep breathing exercises',
            '5-minute mindfulness practice',
            'Relaxation techniques',
          ],
        ),
        Recommendation(
          title: 'Ask for Help Encouragement',
          icon: Icons.help_outline,
          color: AppTheme.accentOrange,
          suggestions: [
            'Talk to someone you trust',
            'Share your feelings',
            'Consider seeking support',
          ],
        ),
        Recommendation(
          title: 'Community Support Suggestions',
          icon: Icons.people_outline,
          color: AppTheme.primaryPurple,
          suggestions: [
            'Connect with others',
            'Join support groups',
            'Build your network',
          ],
        ),
      ];
    } else {
      return [
        Recommendation(
          title: 'Suggested Rest Activities',
          icon: Icons.bed,
          color: AppTheme.primaryBlue,
          suggestions: [
            'Maintain regular rest breaks',
            'Continue self-care practices',
            'Enjoy calming activities',
          ],
        ),
        Recommendation(
          title: 'Gentle Exercise Ideas',
          icon: Icons.fitness_center,
          color: AppTheme.burnoutLowColor,
          suggestions: [
            'Continue your exercise routine',
            'Try new activities you enjoy',
            'Maintain physical activity',
          ],
        ),
        Recommendation(
          title: 'Breathing / Mindfulness Tips',
          icon: Icons.self_improvement,
          color: AppTheme.accentYellow,
          suggestions: [
            'Continue mindfulness practices',
            'Explore new techniques',
            'Maintain your routine',
          ],
        ),
        Recommendation(
          title: 'Ask for Help Encouragement',
          icon: Icons.help_outline,
          color: AppTheme.accentOrange,
          suggestions: [
            'Maintain your support network',
            'Continue open communication',
          ],
        ),
        Recommendation(
          title: 'Community Support Suggestions',
          icon: Icons.people_outline,
          color: AppTheme.primaryPurple,
          suggestions: [
            'Stay connected with your community',
            'Continue building relationships',
          ],
        ),
      ];
    }
  }
  
  Widget _buildRecommendationCard(Recommendation rec) {
    return Card(
      child: InkWell(
        onTap: () {
          _showRecommendationDetails(rec);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: rec.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  rec.icon,
                  color: rec.color,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  rec.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: AppTheme.textLight, size: 18),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showRecommendationDetails(Recommendation rec) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: rec.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(rec.icon, color: rec.color, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      rec.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: rec.suggestions.map((suggestion) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: rec.color,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            suggestion,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Recommendation {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> suggestions;
  
  Recommendation({
    required this.title,
    required this.icon,
    required this.color,
    required this.suggestions,
  });
}
