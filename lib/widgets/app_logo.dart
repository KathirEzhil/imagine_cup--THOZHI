import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_constants.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showTagline;
  
  const AppLogo({
    super.key,
    this.size = 100,
    this.showTagline = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circular logo with stylized head icon
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.face,
            size: size * 0.6,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        // App name with gradient
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            AppConstants.appName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (showTagline) ...[
          const SizedBox(height: 12),
          Text(
            AppConstants.appTagline,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
