import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';

class PersonalTimeScreen extends StatefulWidget {
  const PersonalTimeScreen({super.key});
  
  @override
  State<PersonalTimeScreen> createState() => _PersonalTimeScreenState();
}

class _PersonalTimeScreenState extends State<PersonalTimeScreen> {
  final int _dailyMeTimeMinutes = 30; // This would come from tracking
  final List<Map<String, dynamic>> _weeklyData = [
    {'day': 'Mon', 'minutes': 25},
    {'day': 'Tue', 'minutes': 35},
    {'day': 'Wed', 'minutes': 20},
    {'day': 'Thu', 'minutes': 40},
    {'day': 'Fri', 'minutes': 30},
    {'day': 'Sat', 'minutes': 60},
    {'day': 'Sun', 'minutes': 45},
  ];
  
  @override
  Widget build(BuildContext context) {
    final weeklyTotal = _weeklyData.map((d) => d['minutes'] as int).reduce((a, b) => a + b);
    final weeklyAverage = (weeklyTotal / _weeklyData.length).round();
    
    return Scaffold(
      backgroundColor: AppTheme.lightPink,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Personal Time Tracker',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Today's Me-Time
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.timer,
                        color: AppTheme.primaryPurple,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Today\'s Me-Time',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$_dailyMeTimeMinutes minutes',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          _startMeTimeTracking();
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start Tracking Me-Time'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Weekly Progress
              Text(
                'Weekly Progress',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Average: $weeklyAverage mins/day',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Total: ${Formatters.formatActivityTime(weeklyTotal)}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            gridData: const FlGridData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      '${value.toInt()}m',
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (value.toInt() >= 0 && value.toInt() < _weeklyData.length) {
                                      return Text(
                                        _weeklyData[value.toInt()]['day'] as String,
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
                            barGroups: _weeklyData.asMap().entries.map((entry) {
                              return BarChartGroupData(
                                x: entry.key,
                                barRods: [
                                  BarChartRodData(
                                    toY: (entry.value['minutes'] as int).toDouble(),
                                    color: AppTheme.primaryPurple,
                                    width: 20,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(4),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                            maxY: 120,
                            barTouchData: BarTouchData(enabled: false),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Gentle reminders
              Text(
                'Self-Care Tips',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildTipCard(
                'Set aside time daily',
                'Even 15 minutes of personal time can make a difference. Schedule it like any other appointment.',
                Icons.schedule,
              ),
              const SizedBox(height: 12),
              _buildTipCard(
                'Do what you enjoy',
                'Use your me-time for activities that bring you joy: reading, music, hobbies, or simply resting.',
                Icons.favorite,
              ),
              const SizedBox(height: 12),
              _buildTipCard(
                'It\'s okay to say no',
                'Protecting your personal time is important. It\'s okay to decline requests when you need time for yourself.',
                Icons.handshake,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTipCard(String title, String message, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppTheme.primaryPurple, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _startMeTimeTracking() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Track Me-Time'),
        content: const Text('Tracking your me-time is a gentle reminder to prioritize yourself. Would you like to start a timer?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Not Now'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Me-time tracking started. Remember to log it when done!'),
                  backgroundColor: AppTheme.burnoutLowColor,
                ),
              );
            },
            child: const Text('Start Timer'),
          ),
        ],
      ),
    );
  }
}
