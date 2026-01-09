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
            final hasCheckedIn = burnoutProvider.todayLog != null;
            
            // Determine time-based greeting
            final hour = DateTime.now().hour;
            String timeGreeting = 'Good morning';
            if (hour >= 12 && hour < 17) timeGreeting = 'Good afternoon';
            if (hour >= 17) timeGreeting = 'Good evening';

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
                        onPressed: () async {
                          await userProvider.signOut();
                          if (context.mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                          }
                        },
                        icon: const Icon(Icons.logout, size: 16, color: Colors.white),
                        label: const Text('logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.deepBlue,
                          foregroundColor: Colors.white,
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
                        _buildActionChip('wellness analysis', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InsightsScreen()))),
                        _buildActionChip('burnout risk', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InsightsScreen()))),
                        _buildActionChip('self care tips', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InsightsScreen()))),
                        _buildActionChip('time tracker', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PersonalTimeScreen()))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Greeting
                  Text(
                    '$timeGreeting, ${user?.name ?? 'Friend'}\nyou\'re doing great today 🌸',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      color: AppTheme.deepBlue,
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Quote Area
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: Text(
                        '\"The best way to predict the future is to create it.\"\n— Thozhi Wellness',
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
                        child: _buildCheckInCircle(context, hasCheckedIn),
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
            borderRadius: BorderRadius.circular(12),
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
        color: const Color(0xFF2B3A67),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                'Today\'s Focus',
                style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const Spacer(),
          _buildScheduleItem('09:00 AM', 'Morning Calm'),
          _buildScheduleItem('01:00 PM', 'Relaxation Break'),
          _buildScheduleItem('06:00 PM', 'Wellness Sync'),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String time, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Text(time, style: GoogleFonts.outfit(color: Colors.white70, fontSize: 10)),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(title, style: GoogleFonts.outfit(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
  
  Widget _buildCheckInCircle(BuildContext context, bool completed) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DailyCheckInScreen())),
      child: Container(
        width: 140,
        height: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: completed ? AppTheme.accentBlue : const Color(0xFFD38E9D),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(completed ? Icons.check_circle : Icons.add_circle, color: Colors.white, size: 32),
              const SizedBox(height: 8),
              Text(
                completed ? 'Check-in\nCompleted' : 'Tap to\nCheck-in',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
