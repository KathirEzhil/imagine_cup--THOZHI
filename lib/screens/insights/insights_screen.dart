import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/user_provider.dart';
import '../../providers/burnout_provider.dart';
import '../../widgets/wellness_score_gauge.dart';
import '../../widgets/burnout_indicator.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../models/burnout_model.dart';
import '../interventions/interventions_screen.dart';

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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final burnoutProvider = Provider.of<BurnoutProvider>(context, listen: false);
    
    return Scaffold(
      backgroundColor: AppTheme.lightGreen,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Wellness Score & Insights',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Consumer2<UserProvider, BurnoutProvider>(
          builder: (context, userProvider, burnoutProvider, child) {
            final wellnessScore = burnoutProvider.wellnessScore;
            final burnout = burnoutProvider.currentBurnout;
            final recentLogs = burnoutProvider.recentLogs;
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Wellness Score Gauge
                  Center(
                    child: WellnessScoreGauge(score: wellnessScore),
                  ),
                  const SizedBox(height: 32),
                  // Key Metrics
                  _buildKeyMetrics(recentLogs),
                  const SizedBox(height: 32),
                  // Today's Snapshot
                  _buildTodaysSnapshot(recentLogs.isNotEmpty ? recentLogs.first : null),
                  const SizedBox(height: 32),
                  // Burnout Status
                  if (burnout != null) _buildBurnoutStatus(burnout, burnoutProvider: burnoutProvider),
                  const SizedBox(height: 32),
                  // Weekly Trend
                  _buildWeeklyTrend(burnoutProvider: burnoutProvider),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildKeyMetrics(List logs) {
    if (logs.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No data available yet'),
        ),
      );
    }
    
    final latestLog = logs.first;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Key Metrics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildMetricItem(
              Icons.bedtime,
              'Sleep',
              Formatters.formatHours(latestLog.sleepHours),
              AppTheme.burnoutLowColor,
            ),
            const SizedBox(height: 12),
            _buildMetricItem(
              Icons.directions_run,
              'Activity',
              Formatters.formatActivityTime(latestLog.activityMinutes),
              AppTheme.burnoutLowColor,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMetricItem(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            '$label: $value',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Container(
          width: 60,
          height: 8,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            widthFactor: 0.7,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildTodaysSnapshot(dynamic log) {
    if (log == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Complete your daily check-in to see today\'s snapshot'),
        ),
      );
    }
    
    final moodLabels = {
      '😊': 'Joyful',
      '😌': 'Calm',
      '😐': 'Neutral',
      '😔': 'Sad',
      '😢': 'Very Sad',
    };
    
    final energyColors = {
      'Very Low': AppTheme.accentRed,
      'Low': AppTheme.accentOrange,
      'Moderate': AppTheme.accentYellow,
      'High': AppTheme.burnoutLowColor,
      'Very High': AppTheme.darkGreen,
    };
    
    final workloadLabels = {
      (0, 3): 'Low',
      (4, 6): 'Moderate',
      (7, 10): 'High',
    };
    
    String workloadLabel = 'Moderate';
    for (var entry in workloadLabels.entries) {
      if (log.workloadIntensity >= entry.key.$1 && log.workloadIntensity <= entry.key.$2) {
        workloadLabel = entry.value;
        break;
      }
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Snapshot',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSnapshotCard(
                    log.mood,
                    moodLabels[log.mood] ?? 'Neutral',
                    AppTheme.lightGreen,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSnapshotCard(
                    Icons.battery_charging_full,
                    'Energy: ${log.energyLevel.split(' ').first}',
                    energyColors[log.energyLevel] ?? AppTheme.mediumGray,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildSnapshotCard(
                    Icons.graphic_eq,
                    'Stress: ${log.stressLevel < 5 ? 'Low' : log.stressLevel < 7 ? 'Moderate' : 'High'}',
                    log.stressLevel < 5 
                        ? AppTheme.burnoutLowColor 
                        : log.stressLevel < 7 
                            ? AppTheme.burnoutMediumColor 
                            : AppTheme.burnoutHighColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSnapshotCard(
                    Icons.work_outline,
                    'Workload: $workloadLabel',
                    workloadLabel == 'Low' 
                        ? AppTheme.burnoutLowColor 
                        : workloadLabel == 'Moderate' 
                            ? AppTheme.burnoutMediumColor 
                            : AppTheme.burnoutHighColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSnapshotCard(dynamic icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          if (icon is String)
            Text(icon, style: const TextStyle(fontSize: 32))
          else
            Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  
  Widget _buildBurnoutStatus(BurnoutModel burnout, {required BurnoutProvider burnoutProvider}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Burnout Status & Insights',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Burnout Risk Level',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  BurnoutIndicator(level: burnout.level),
                  const SizedBox(height: 12),
                  Text(
                    burnout.explanation,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Trend
            Text(
              'Your Trend',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _buildTrendChart(burnoutProvider: burnoutProvider),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.accentYellow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.celebration, color: AppTheme.accentOrange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Keep up the great work! Your efforts in maintaining balance are paying off.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
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
  
  Widget _buildWeeklyTrend({required BurnoutProvider burnoutProvider}) {
    final trendData = burnoutProvider.getWeeklyTrendData();
    
    if (trendData.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Complete daily check-ins to see your trend'),
        ),
      );
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last 7 Days Trend',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: trendData.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          entry.value['riskScore'] as double,
                        );
                      }).toList(),
                      isCurved: true,
                      color: AppTheme.primaryPurple,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.primaryPurple.withOpacity(0.1),
                      ),
                    ),
                  ],
                  minY: 0,
                  maxY: 100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTrendChart({required BurnoutProvider burnoutProvider}) {
    final trendData = burnoutProvider.getWeeklyTrendData();
    
    if (trendData.isEmpty) {
      return const Center(child: Text('No trend data available'));
    }
    
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < trendData.length) {
                  final date = trendData[value.toInt()]['date'] as DateTime;
                  return Text(
                    Formatters.formatShortDate(date),
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: trendData.asMap().entries.map((entry) {
              return FlSpot(
                entry.key.toDouble(),
                entry.value['riskScore'] as double,
              );
            }).toList(),
            isCurved: true,
            color: AppTheme.burnoutLowColor,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.burnoutLowColor.withOpacity(0.1),
            ),
          ),
        ],
        minY: 0,
        maxY: 100,
      ),
    );
  }
}
