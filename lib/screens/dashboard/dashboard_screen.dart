import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/user_provider.dart';
import '../../providers/burnout_provider.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/quote_card.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../daily_checkin/daily_checkin_screen.dart';
import '../insights/insights_screen.dart';
import '../personal_time/personal_time_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }
  
  void _initializeData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final burnoutProvider = Provider.of<BurnoutProvider>(context, listen: false);
    if (userProvider.user != null) {
      burnoutProvider.loadDailyLogs(userProvider.user!.id);
      burnoutProvider.loadBurnoutHistory(userProvider.user!.id);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.dashboardGreen,
      body: SafeArea(
        child: Consumer2<UserProvider, BurnoutProvider>(
          builder: (context, userProvider, burnoutProvider, child) {
            final user = userProvider.user;
            
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo + Logout Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppLogo(size: 40),
                      ElevatedButton.icon(
                        onPressed: () => userProvider.signOut(),
                        icon: const Icon(Icons.arrow_back, size: 16, color: Colors.white),
                        label: const Text('logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: Size.zero,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Horizontal Action Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildActionChip('energy status', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InsightsScreen()))),
                        _buildActionChip('risk indicator', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InsightsScreen()))),
                        _buildActionChip('view insights', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InsightsScreen()))),
                        _buildActionChip('time tracker', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PersonalTimeScreen()))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Greeting
                  Text(
                    'Good evening, you\'re doing great today 🌸',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: AppTheme.deepBlue,
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Quote Area
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: Text(
                        'some relevant qoute which changes every day',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  
                  // Schedule + Check-in Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildScheduleBox(),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: _buildCheckInCircle(context),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildActionChip(String label, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFD38E9D).withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildScheduleBox() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2E3B71), // Dark Blue from image
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'your schedule for today',
            style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          ...List.generate(4, (index) => Container(
            margin: const EdgeInsets.only(top: 12),
            height: 20,
            decoration: BoxDecoration(
              color: index % 2 == 0 ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          )),
        ],
      ),
    );
  }
  
  Widget _buildCheckInCircle(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DailyCheckInScreen())),
      child: Container(
        width: 140,
        height: 140,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFFD38E9D),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            'tap to complete\nthe daily check in\nfor today',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
