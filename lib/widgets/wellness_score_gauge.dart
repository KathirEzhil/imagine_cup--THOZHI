import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/formatters.dart';

class WellnessScoreGauge extends StatelessWidget {
  final double score; // 0-100
  
  const WellnessScoreGauge({
    super.key,
    required this.score,
  });
  
  Color _getScoreColor() {
    if (score >= 80) return AppTheme.burnoutLowColor;
    if (score >= 60) return AppTheme.burnoutMediumColor;
    return AppTheme.burnoutHighColor;
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular progress indicator
          SizedBox(
            width: 160,
            height: 160,
            child: CircularProgressIndicator(
              value: score / 100,
              strokeWidth: 16,
              backgroundColor: AppTheme.mediumGray.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(_getScoreColor()),
            ),
          ),
          // Score text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Formatters.formatWellnessScore(score),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Wellness Score',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
