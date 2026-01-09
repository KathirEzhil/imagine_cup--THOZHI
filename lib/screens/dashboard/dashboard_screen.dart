import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/burnout_provider.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/burnout_indicator.dart';
import '../../widgets/quote_card.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/formatters.dart';
import '../../models/burnout_model.dart';
import '../daily_checkin/daily_checkin_screen.dart';
import '../insights/insights_screen.dart';
import '../personal_time/personal_time_screen.dart';
import '../interventions/interventions_screen.dart';

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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final burnoutProvider = Provider.of<BurnoutProvider>(context, listen: false);
    
    return Scaffold(
      backgroundColor: AppTheme.lightGreen,
      body: SafeArea(
        child: Consumer2<UserProvider, BurnoutProvider>(
          builder: (context, userProvider, burnoutProvider, child) {
            final user = userProvider.user;
            final burnout = burnoutProvider.currentBurnout;
            final hasCheckedInToday = burnoutProvider.todayLog != null;
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(context, userProvider),
                  const SizedBox(height: 24),
                  // Quick action buttons
                  _buildQuickActions(context),
                  const SizedBox(height: 24),
                  // Greeting and quote
                  _buildGreeting(context, user?.name ?? 'Friend'),
                  const SizedBox(height: 24),
                  // Schedule and Check-in
                  Row(
                    children: [
                      Expanded(
                        child: _buildScheduleCard(context),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildCheckInCard(context, hasCheckedInToday),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Burnout status
                  if (burnout != null)
                    _buildBurnoutStatusCard(context, burnout),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context, UserProvider userProvider) {
    return Row(
      children: [
        const AppLogo(size: 50),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            await userProvider.signOut();
            if (!mounted) return;
            Navigator.of(context).pushReplacementNamed('/login');
          },
          icon: const Icon(Icons.logout, size: 18),
          label: const Text('logout'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.darkGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }
  
  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context,
            'Energy Status',
            Icons.battery_charging_full,
            () {
              // Navigate to energy status
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildActionButton(
            context,
            'Risk Indicator',
            Icons.warning_amber,
            () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const InsightsScreen()),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildActionButton(
            context,
            'View Insights',
            Icons.insights,
            () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const InsightsScreen()),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildActionButton(
            context,
            'Time Tracker',
            Icons.timer,
            () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PersonalTimeScreen()),
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.accentRed.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildGreeting(BuildContext context, String userName) {
    final greeting = Formatters.getGreeting();
    final quotes = [
      'You are doing great today! Keep taking care of yourself.',
      'Every small step towards self-care matters.',
      'Your well-being is important. Take time for yourself.',
      'Remember: It\'s okay to rest. You deserve it.',
    ];
    final randomQuote = quotes[DateTime.now().day % quotes.length];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, $userName',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'you\'re doing great today',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        QuoteCard(quote: randomQuote),
      ],
    );
  }
  
  Widget _buildScheduleCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'your schedule for today',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          // Schedule items placeholder
          ...List.generate(3, (index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildCheckInCard(BuildContext context, bool hasCheckedIn) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DailyCheckInScreen()),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.accentRed.withOpacity(0.8),
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasCheckedIn ? Icons.check_circle : Icons.touch_app,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              hasCheckedIn ? 'Check-in Complete' : 'tap to complete the daily check in for today',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBurnoutStatusCard(BuildContext context, BurnoutModel burnout) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Burnout Risk Status',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            BurnoutIndicator(level: burnout.level),
            const SizedBox(height: 16),
            Text(
              burnout.explanation,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const InterventionsScreen()),
                );
              },
              child: const Text('View Recommendations'),
            ),
          ],
        ),
      ),
    );
  }
}
