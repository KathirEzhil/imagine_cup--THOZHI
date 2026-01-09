import 'package:intl/intl.dart';

class Formatters {
  // Date formatters
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
  
  static String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }
  
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(dateTime);
  }
  
  static String formatDayOfWeek(DateTime date) {
    return DateFormat('EEEE').format(date);
  }
  
  static String formatShortDate(DateTime date) {
    return DateFormat('MMM dd').format(date);
  }
  
  // Get greeting based on time
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }
  
  // Format phone number
  static String formatPhoneNumber(String phone) {
    if (phone.isEmpty) return '';
    // Remove all non-digit characters
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length >= 10) {
      return '${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6)}';
    }
    return phone;
  }
  
  // Format wellness score
  static String formatWellnessScore(double score) {
    return score.toStringAsFixed(0);
  }
  
  // Format hours
  static String formatHours(double hours) {
    final wholeHours = hours.floor();
    final minutes = ((hours - wholeHours) * 60).round();
    if (minutes == 0) {
      return '$wholeHours hrs';
    }
    return '$wholeHours.${minutes ~/ 6} hrs';
  }
  
  // Format activity time
  static String formatActivityTime(int minutes) {
    if (minutes < 60) {
      return '$minutes mins';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) {
      return '$hours hr';
    }
    return '$hours hr $mins mins';
  }
}
