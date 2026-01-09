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
            const SizedBox(height: 48),
            
            _buildRecommendationTile(
              '5 mins mindfulness practice',
              Icons.self_improvement,
              const Color(0xFFD38E9D), // Pink
            ),
            const SizedBox(height: 20),
            
            _buildRecommendationTile(
              'Schedule your personal time',
              Icons.calendar_today,
              const Color(0xFF2E3B71), // Blue
            ),
            const SizedBox(height: 20),
            
            _buildRecommendationTile(
              'Guided meditation',
              Icons.mediation,
              const Color(0xFF81C784), // Green
            ),
            const SizedBox(height: 20),
            
            _buildRecommendationTile(
              'Hydration / Self-care reminder',
              Icons.water_drop,
              const Color(0xFF4DB6AC), // Teal
            ),
            
            const SizedBox(height: 60),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.support_agent),
              label: const Text('Connect with Support'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.1),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationTile(String text, IconData icon, Color color) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                text,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
