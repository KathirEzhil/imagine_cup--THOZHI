class AppConstants {
  // App Info
  static const String appName = 'Thozhi';
  static const String appTagline = 'Your trusted companion for balance & well-being';
  
  // Burnout Levels
  static const String burnoutLow = 'Low';
  static const String burnoutMedium = 'Medium';
  static const String burnoutHigh = 'High';
  
  // Languages
  static const String langEnglish = 'English(US)';
  static const String langTamil = 'Tamil';
  
  // Firestore Collections
  static const String usersCollection = 'users';
  static const String dailyLogsCollection = 'daily_logs';
  static const String profilesCollection = 'profiles';
  static const String notificationsCollection = 'notifications';
  static const String interventionsCollection = 'interventions';
  
  // Storage Keys
  static const String prefLanguage = 'pref_language';
  static const String prefOnboardingComplete = 'onboarding_complete';
  static const String prefConsentGiven = 'consent_given';
  
  // Mood Options
  static const List<String> moodOptions = ['😊', '😌', '😐', '😔', '😢'];
  static const List<String> moodLabels = ['Joyful', 'Calm', 'Neutral', 'Sad', 'Very Sad'];
  
  // Energy Levels
  static const List<String> energyLevels = ['Very Low', 'Low', 'Moderate', 'High', 'Very High'];
  
  // Default Values
  static const int defaultSleepHours = 7;
  static const int defaultActivityMinutes = 30;
  static const int defaultCheckInTimeMinutes = 1;
}
