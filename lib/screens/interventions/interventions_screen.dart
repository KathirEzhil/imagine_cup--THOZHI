import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/user_provider.dart';
import '../../providers/burnout_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/burnout_model.dart';
import '../../widgets/app_logo.dart';

class InterventionsScreen extends StatefulWidget {
  const InterventionsScreen({super.key});
  
  @override
  State<InterventionsScreen> createState() => _InterventionsScreenState();
}

class _InterventionsScreenState extends State<InterventionsScreen> {
  @override
  Widget build(BuildContext context) {
    final burnoutProvider = Provider.of<BurnoutProvider>(context);
    final currentBurnout = burnoutProvider.currentBurnout;
    final isHighRisk = currentBurnout?.level == BurnoutLevel.high;

    return Scaffold(
      backgroundColor: AppTheme.dashboardGreen,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Personalized Recommendations', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const AppLogo(size: 60),
            const SizedBox(height: 24),
            
            if (isHighRisk)
              _buildUrgentAlert(),
            
            const SizedBox(height: 24),
            
            _buildRecommendationTile(
              '5 mins mindfulness practice',
              Icons.self_improvement,
              const Color(0xFFD38E9D), // Pink
              'Guided breathing to lower immediate stress.'
            ),
            const SizedBox(height: 20),
            
            _buildRecommendationTile(
              'Schedule your personal time',
              Icons.calendar_today,
              const Color(0xFF2E3B71), // Blue
              'Reserve time for yourself this evening.'
            ),
            const SizedBox(height: 20),
            
            _buildRecommendationTile(
              'Guided meditation',
              Icons.mediation,
              const Color(0xFF81C784), // Green
              'Deep relaxation for mental clarity.'
            ),
            const SizedBox(height: 20),
            
            _buildRecommendationTile(
              'Hydration / Self-care reminder',
              Icons.water_drop,
              const Color(0xFF4DB6AC), // Teal
              'A quick glass of water can reset your focus.'
            ),
            
            const SizedBox(height: 40),
            
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Connecting to support...'))
                );
              },
              icon: const Icon(Icons.support_agent),
              label: Text(isHighRisk ? 'Talk to a Professional' : 'Connect with Support'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isHighRisk ? AppTheme.accentRed : Colors.white.withOpacity(0.1),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildUrgentAlert() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentRed.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentRed),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppTheme.accentRed, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('We\'re here for you', style: GoogleFonts.outfit(color: AppTheme.accentRed, fontWeight: FontWeight.bold)),
                Text(
                  'Your current burnout risk is high. Please consider taking a break or talking to someone.',
                  style: GoogleFonts.outfit(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationTile(String text, IconData icon, Color color, String subtitle) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Starting: $text'))
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}
