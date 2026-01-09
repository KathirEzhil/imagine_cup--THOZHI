import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        // Circular logo container
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppTheme.logoBlue,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.spa_rounded,
            size: size * 0.6,
            color: AppTheme.dashboardGreen,
          ),
        ),
        const SizedBox(height: 16),
        // "Thozhi" in the special pill container
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.logoBlue,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.outfit(
                fontSize: size * 0.25,
                fontWeight: FontWeight.bold,
              ),
              children: const [
                TextSpan(text: 'Tho', style: TextStyle(color: Color(0xFF4A90E2))),
                TextSpan(text: 'zhi', style: TextStyle(color: Color(0xFFD38E9D))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
