import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});
  
  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final List<AlertNotification> _alerts = [
    AlertNotification(
      title: 'Wellness Check-In',
      message: 'Your wellness needs attention. Take a moment for yourself today.',
      type: AlertType.burnout,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      read: false,
    ),
    AlertNotification(
      title: 'Self-Care Reminder',
      message: 'Remember to take a break and practice self-care today.',
      type: AlertType.selfCare,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      read: true,
    ),
    AlertNotification(
      title: 'Daily Check-In',
      message: 'Time for your daily check-in. How are you feeling today?',
      type: AlertType.reminder,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      read: true,
    ),
  ];
  
  @override
  Widget build(BuildContext context) {
    final unreadCount = _alerts.where((alert) => !alert.read).length;
    
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
          'Alerts & Notifications',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (unreadCount > 0)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.accentRed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$unreadCount',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Notification preferences
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notification Preferences',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Burnout Alerts'),
                        subtitle: const Text('Gentle alerts when burnout risk is detected'),
                        value: true,
                        onChanged: (value) {},
                        activeThumbColor: AppTheme.primaryPurple,
                      ),
                      SwitchListTile(
                        title: const Text('Self-Care Reminders'),
                        subtitle: const Text('Daily reminders to take care of yourself'),
                        value: true,
                        onChanged: (value) {},
                        activeThumbColor: AppTheme.primaryPurple,
                      ),
                      SwitchListTile(
                        title: const Text('Daily Check-In Reminders'),
                        subtitle: const Text('Reminders to complete your daily check-in'),
                        value: true,
                        onChanged: (value) {},
                        activeThumbColor: AppTheme.primaryPurple,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Alerts list
            Expanded(
              child: _alerts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.notifications_none,
                            size: 64,
                            color: AppTheme.textLight,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No notifications yet',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.textLight,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _alerts.length,
                      itemBuilder: (context, index) {
                        return _buildAlertCard(_alerts[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAlertCard(AlertNotification alert) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: alert.read ? Colors.white : AppTheme.primaryPurple.withOpacity(0.05),
      child: InkWell(
        onTap: () {
          setState(() {
            alert.read = true;
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getAlertColor(alert.type).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getAlertIcon(alert.type),
                  color: _getAlertColor(alert.type),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            alert.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: alert.read ? FontWeight.normal : FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!alert.read)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryPurple,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alert.message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTimestamp(alert.timestamp),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getAlertColor(AlertType type) {
    switch (type) {
      case AlertType.burnout:
        return AppTheme.burnoutHighColor;
      case AlertType.selfCare:
        return AppTheme.burnoutLowColor;
      case AlertType.reminder:
        return AppTheme.primaryPurple;
    }
  }
  
  IconData _getAlertIcon(AlertType type) {
    switch (type) {
      case AlertType.burnout:
        return Icons.warning;
      case AlertType.selfCare:
        return Icons.favorite;
      case AlertType.reminder:
        return Icons.notifications;
    }
  }
  
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

class AlertNotification {
  final String title;
  final String message;
  final AlertType type;
  final DateTime timestamp;
  bool read;
  
  AlertNotification({
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.read = false,
  });
}

enum AlertType {
  burnout,
  selfCare,
  reminder,
}
