import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firestore_service.dart';

class NotificationService {
  FirebaseMessaging get _messaging => FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  FirestoreService get _firestoreService => FirestoreService();
  
  // Initialize notifications
  Future<void> initialize() async {
    // Request permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Initialize local notifications
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings();
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );
      
      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );
      
      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      
      // Handle background messages (notification tap when app is closed)
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessageTap);
      
      // Get initial message if app was opened from notification
      RemoteMessage? initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleBackgroundMessageTap(initialMessage);
      }
    }
  }
  
  // Get FCM token
  Future<String?> getFCMToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      return null;
    }
  }
  
  // Handle foreground message
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    await _localNotifications.show(
      message.notification?.hashCode ?? 0,
      message.notification?.title ?? 'Thozhi',
      message.notification?.body ?? '',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'thozhi_channel',
          'Thozhi Notifications',
          channelDescription: 'Notifications for wellness and burnout alerts',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
  
  // Handle notification tap (foreground)
  void _onNotificationTap(NotificationResponse response) {
    // Handle tap based on payload
    // Navigate to appropriate screen
  }
  
  // Handle background message tap
  void _handleBackgroundMessageTap(RemoteMessage message) {
    // Navigate to appropriate screen based on data
  }
  
  // Send local notification
  Future<void> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'thozhi_channel',
      'Thozhi Notifications',
      channelDescription: 'Notifications for wellness and burnout alerts',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    
    const iosDetails = DarwinNotificationDetails();
    
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
      payload: data?.toString(),
    );
  }
  
  // Schedule gentle reminder
  Future<void> scheduleDailyCheckInReminder(String userId) async {
    // Schedule for evening (6 PM)
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, 18, 0, 0);
    if (now.hour >= 18) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }
    
    // This would typically use a plugin like flutter_local_notifications
    // For now, we'll use FCM scheduled messages or Cloud Functions
  }
  
  // Send burnout alert (gentle)
  Future<void> sendBurnoutAlert(String userId, String level) async {
    String title = 'Wellness Check-In';
    String body = 'Your wellness needs attention. Take a moment for yourself today.';
    
    if (level == 'Medium') {
      body = 'Consider taking a break. Your well-being is important.';
    } else if (level == 'High') {
      body = 'Please prioritize rest and self-care. You deserve it.';
    }
    
    await showLocalNotification(
      title: title,
      body: body,
      data: {'type': 'burnout_alert', 'level': level},
    );
    
    // Also save to Firestore
    await _firestoreService.saveNotification(userId, {
      'type': 'burnout_alert',
      'title': title,
      'body': body,
      'level': level,
    });
  }
  
  // Send self-care nudge
  Future<void> sendSelfCareNudge(String userId, String message) async {
    await showLocalNotification(
      title: 'Self-Care Reminder',
      body: message,
      data: {'type': 'self_care'},
    );
    
    await _firestoreService.saveNotification(userId, {
      'type': 'self_care',
      'title': 'Self-Care Reminder',
      'body': message,
    });
  }
  
  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background message
}
