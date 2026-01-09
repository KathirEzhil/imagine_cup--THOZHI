import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';

class UserProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final NotificationService _notificationService = NotificationService();
  
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  bool _isOnboardingComplete = false;
  bool _hasConsent = false;
  String _selectedLanguage = AppConstants.langEnglish;
  bool _isGuest = false;
  
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null || _isGuest;
  bool get isGuest => _isGuest;
  bool get isOnboardingComplete => _isOnboardingComplete;
  bool get hasConsent => _hasConsent;
  String get selectedLanguage => _selectedLanguage;
  
  UserProvider() {
    _initialize();
  }
  
  Future<void> _initialize() async {
    _loadPreferences();
    _authService.authStateChanges.listen((firebaseUser) async {
      if (firebaseUser != null) {
        await loadUser(firebaseUser.uid);
      } else {
        _user = null;
        notifyListeners();
      }
    });
  }
  
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isOnboardingComplete = prefs.getBool(AppConstants.prefOnboardingComplete) ?? false;
    _hasConsent = prefs.getBool(AppConstants.prefConsentGiven) ?? false;
    _selectedLanguage = prefs.getString(AppConstants.prefLanguage) ?? AppConstants.langEnglish;
    notifyListeners();
  }
  
  Future<void> setOnboardingComplete(bool value) async {
    _isOnboardingComplete = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefOnboardingComplete, value);
    notifyListeners();
  }
  
  Future<void> setConsent(bool value) async {
    _hasConsent = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefConsentGiven, value);
    notifyListeners();
  }
  
  Future<void> setLanguage(String language) async {
    _selectedLanguage = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefLanguage, language);
    notifyListeners();
  }
  
  Future<void> loadUser(String userId) async {
    _setLoading(true);
    try {
      _user = await _firestoreService.getUser(userId);
      if (_user == null && _authService.currentUser != null) {
        // Create user if doesn't exist
        final firebaseUser = _authService.currentUser!;
        _user = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email,
          phone: firebaseUser.phoneNumber,
          name: firebaseUser.displayName ?? 'User',
          createdAt: DateTime.now(),
          profileCompleted: false,
        );
        await _firestoreService.createUser(_user!);
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> signInWithEmail(String email, String password) async {
    _setLoading(true);
    try {
      await _authService.signInWithEmail(email, password);
      if (_authService.currentUser != null) {
        await loadUser(_authService.currentUser!.uid);
        // Update last login
        await _firestoreService.updateUser(_user!.id, {
          'lastLoginAt': DateTime.now().toIso8601String(),
        });
        _user = _user!.copyWith(lastLoginAt: DateTime.now());
      }
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> signUpWithEmail(String email, String password, String name) async {
    _setLoading(true);
    try {
      await _authService.signUpWithEmail(email, password, name);
      if (_authService.currentUser != null) {
        await loadUser(_authService.currentUser!.uid);
      }
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> signInWithPhone(String phoneNumber) async {
    _setLoading(true);
    try {
      await _authService.signInWithPhoneNumber(phoneNumber);
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<bool> verifyOTP(String verificationId, String smsCode) async {
    _setLoading(true);
    try {
      await _authService.verifyOTP(verificationId, smsCode);
      if (_authService.currentUser != null) {
        await loadUser(_authService.currentUser!.uid);
        // Create user if doesn't exist
        if (_user == null && _authService.currentUser != null) {
          final firebaseUser = _authService.currentUser!;
          _user = UserModel(
            id: firebaseUser.uid,
            phone: firebaseUser.phoneNumber,
            name: 'User',
            createdAt: DateTime.now(),
            profileCompleted: false,
          );
          await _firestoreService.createUser(_user!);
        }
        // Update last login
        await _firestoreService.updateUser(_user!.id, {
          'lastLoginAt': DateTime.now().toIso8601String(),
        });
        _user = _user!.copyWith(lastLoginAt: DateTime.now());
      }
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> updateProfile(Map<String, dynamic> updates) async {
    if (_user == null) return;
    _setLoading(true);
    try {
      await _firestoreService.updateUser(_user!.id, updates);
      _user = _user!.copyWith(
        name: updates['name'] ?? _user!.name,
        language: updates['language'] ?? _user!.language,
        profileData: updates['profileData'] ?? _user!.profileData,
        profileCompleted: updates['profileCompleted'] ?? _user!.profileCompleted,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> saveProfileData(Map<String, dynamic> profileData) async {
    if (_user == null) return;
    _setLoading(true);
    try {
      await _firestoreService.saveProfileData(_user!.id, profileData);
      _user = _user!.copyWith(
        profileData: profileData,
        profileCompleted: true,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> signOut() async {
    _setLoading(true);
    try {
      if (!_isGuest) {
        await _authService.signOut();
      }
      _user = null;
      _isGuest = false;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void enableGuestMode() {
    _isGuest = true;
    _user = UserModel(
      id: 'guest_user',
      name: 'Thozhi Friend',
      email: 'guest@example.com',
      createdAt: DateTime.now(),
      profileCompleted: true,
    );
    _isOnboardingComplete = true;
    _hasConsent = true;
    notifyListeners();
  }
  
  Future<void> deleteAccount() async {
    if (_user == null) return;
    _setLoading(true);
    try {
      await _authService.deleteAccount();
      _user = null;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }
  
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
