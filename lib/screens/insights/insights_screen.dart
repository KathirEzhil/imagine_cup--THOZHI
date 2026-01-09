import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/user_provider.dart';
import '../../providers/burnout_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/burnout_model.dart';
import '../../models/daily_log_model.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});
  
  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }
  
  void _loadData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final burnoutProvider = Provider.of<BurnoutProvider>(context, listen: false);
    if (userProvider.user != null) {
      burnoutProvider.loadDailyLogs(userProvider.user!.id);
      burnoutProvider.loadBurnoutHistory(userProvider.user!.id);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final burnoutProvider = Provider.of<BurnoutProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    
    final hasData = burnoutProvider.recentLogs.isNotEmpty;
    final latestLog = hasData ? burnoutProvider.recentLogs.first : null;
    final currentBurnout = burnoutProvider.currentBurnout;

    return Scaffold(
      backgroundColor: AppTheme.dashboardGreen,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Wellness Insights', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: burnoutProvider.isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.white))
        : !hasData 
          ? _buildEmptyState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Weekly Header
                  _buildWeeklyHeader(),
                  const SizedBox(height: 32),
                  
                  // Trend Graph
                  _buildAverageWellnessGraph(burnoutProvider.getWeeklyTrendData()),
                  const SizedBox(height: 32),
                  
                  // Score Highlights
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildScoreCircle((burnoutProvider.wellnessScore).toInt(), 'Average', AppTheme.softRose),
                      _buildScoreCircle((latestLog?.dailyScore ?? 0).toInt(), 'Today', AppTheme.accentBlue),
                      _buildScoreCircle((currentBurnout?.riskScore ?? 0).toInt(), 'Risk Score', Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 40),
                  
                  // Risk Indicator
                  _buildRiskLevelIndicator(currentBurnout),
                  const SizedBox(height: 40),
                  
                  // Metrics Grid
                  _buildMetricsGrid(latestLog),
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.query_stats, size: 80, color: Colors.white.withOpacity(0.5)),
            const SizedBox(height: 24),
            Text(
              'No data yet',
              style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Complete your first daily check-in to see your wellness insights here.',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyHeader() {
    final now = DateTime.now();
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: days.map((d) => Text(d, style: GoogleFonts.outfit(color: Colors.white70, fontSize: 12))).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (i) {
            final dayDate = startOfWeek.add(Duration(days: i));
            final isToday = dayDate.day == now.day && dayDate.month == now.month;
            return Text(
              '${dayDate.day}', 
              style: GoogleFonts.outfit(
                color: Colors.white, 
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal, 
                fontSize: 16
              )
            );
          }),
        ),
      ],
    );
  }

  Widget _buildAverageWellnessGraph(List<Map<String, dynamic>> trendData) {
    final List<FlSpot> spots = trendData.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), (e.value['riskScore'] as int).toDouble());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Burnout Risk Trend', style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        SizedBox(
          height: 180,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots.isEmpty ? [const FlSpot(0, 0)] : spots,
                  isCurved: true,
                  color: const Color(0xFFD38E9D),
                  barWidth: 4,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: const Color(0xFFD38E9D).withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreCircle(int score, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text('$score', style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.outfit(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildRiskLevelIndicator(BurnoutModel? burnout) {
    final level = burnout?.level ?? BurnoutLevel.low;
    final color = level == BurnoutLevel.low ? Colors.green : (level == BurnoutLevel.medium ? Colors.orange : Colors.red);
    final label = level == BurnoutLevel.low ? 'Low Risk' : (level == BurnoutLevel.medium ? 'Moderate Risk' : 'High Risk');
    final progress = level == BurnoutLevel.low ? 0.3 : (level == BurnoutLevel.medium ? 0.6 : 1.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personalized Risk Level', style: GoogleFonts.outfit(color: Colors.white70)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white10,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(label, style: GoogleFonts.outfit(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(DailyLogModel? latestLog) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildMetricItem(Icons.bedtime_outlined, 'Sleep', '${latestLog?.sleepHours ?? 0} hrs', Colors.blue),
        _buildMetricItem(Icons.fitness_center, 'Activity', '${latestLog?.activityMinutes ?? 0} mins', Colors.orange),
        _buildMetricItem(Icons.work_outline, 'Workload', latestLog?.energyLevel ?? 'N/A', Colors.purple),
        _buildMetricItem(Icons.waves, 'Stress', latestLog?.stressLevel.toStringAsFixed(1) ?? '0.0', Colors.teal),
      ],
    );
  }

  Widget _buildMetricItem(IconData icon, String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const Spacer(),
          Text(title, style: GoogleFonts.outfit(color: Colors.white70, fontSize: 12)),
          Text(value, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
