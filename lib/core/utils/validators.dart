class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
  
  // Phone validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    final phoneRegex = RegExp(r'^\+?[\d\s-()]{10,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
  
  // OTP validation
  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the OTP';
    }
    if (value.length != 6) {
      return 'OTP must be 6 digits';
    }
    final otpRegex = RegExp(r'^\d{6}$');
    if (!otpRegex.hasMatch(value)) {
      return 'OTP must contain only numbers';
    }
    return null;
  }
  
  // Required field validation
  static String? validateRequired(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  
  // Sleep hours validation
  static String? validateSleepHours(double? value) {
    if (value == null) {
      return 'Please enter sleep hours';
    }
    if (value < 0 || value > 24) {
      return 'Sleep hours must be between 0 and 24';
    }
    return null;
  }
  
  // Activity minutes validation
  static String? validateActivityMinutes(int? value) {
    if (value == null) {
      return 'Please enter activity minutes';
    }
    if (value < 0 || value > 1440) {
      return 'Activity minutes must be between 0 and 1440';
    }
    return null;
  }
}
