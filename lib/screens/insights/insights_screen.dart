import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/user_provider.dart';
import '../../providers/burnout_provider.dart';
import '../../core/theme/app_theme.dart';

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
    return Scaffold(
      backgroundColor: AppTheme.dashboardGreen,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Wellness Insights', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weekly Header
            _buildWeeklyHeader(),
            const SizedBox(height: 32),
            
            // Trend Graph
            _buildAverageWellnessGraph(),
            const SizedBox(height: 32),
            
            // Score Highlights
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildScoreCircle(75, 'Good', Colors.orange),
                _buildScoreCircle(62, 'Moderate', Colors.amber),
                _buildScoreCircle(84, 'Excellent', Colors.green),
              ],
            ),
            const SizedBox(height: 40),
            
            // Risk Indicator
            _buildRiskLevelIndicator(),
            const SizedBox(height: 40),
            
            // Metrics Grid
            _buildMetricsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((d) => Text(d, style: GoogleFonts.outfit(color: Colors.white70, fontSize: 12))).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (i) => Text('${25 + i}', style: GoogleFonts.outfit(color: Colors.white, fontWeight: i == 4 ? FontWeight.bold : FontWeight.normal, fontSize: 16))).toList(),
        ),
      ],
    );
  }

  Widget _buildAverageWellnessGraph() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Average Wellness', style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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
                  spots: [
                    const FlSpot(0, 70),
                    const FlSpot(1, 65),
                    const FlSpot(2, 80),
                    const FlSpot(3, 75),
                    const FlSpot(4, 85),
                    const FlSpot(5, 78),
                    const FlSpot(6, 92),
                  ],
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

  Widget _buildRiskLevelIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Risk Level', style: GoogleFonts.outfit(color: Colors.white70)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text('Low Risk', style: GoogleFonts.outfit(color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildMetricItem(Icons.bedtime_outlined, 'Sleep', '7.8 hrs', Colors.blue),
        _buildMetricItem(Icons.fitness_center, 'Activity', '60 mins', Colors.orange),
        _buildMetricItem(Icons.work_outline, 'Workload', 'Moderate', Colors.purple),
        _buildMetricItem(Icons.waves, 'Stress', 'Low', Colors.teal),
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
