import 'package:flutter/foundation.dart';
import '../models/daily_log_model.dart';
import '../models/burnout_model.dart';
import '../services/firestore_service.dart';
import '../services/notification_service.dart';
import 'package:uuid/uuid.dart';

class BurnoutProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final NotificationService _notificationService = NotificationService();
  final _uuid = const Uuid();
  
  List<DailyLogModel> _recentLogs = [];
  BurnoutModel? _currentBurnout;
  List<BurnoutModel> _burnoutHistory = [];
  bool _isLoading = false;
  String? _error;
  DailyLogModel? _todayLog;
  
  List<DailyLogModel> get recentLogs => _recentLogs;
  BurnoutModel? get currentBurnout => _currentBurnout;
  List<BurnoutModel> get burnoutHistory => _burnoutHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DailyLogModel? get todayLog => _todayLog;
  
  // Calculate wellness score from recent logs
  double get wellnessScore {
    if (_recentLogs.isEmpty) return 0;
    final scores = _recentLogs.map((log) => log.dailyScore).toList();
    return scores.reduce((a, b) => a + b) / scores.length;
  }
  
  Future<void> loadDailyLogs(String userId) async {
    _setLoading(true);
    try {
      _recentLogs = await _firestoreService.getDailyLogs(userId, limit: 30);
      // Check today's log
      _todayLog = await _firestoreService.getDailyLogByDate(userId, DateTime.now());
      _error = null;
      
      // Calculate burnout after loading logs
      if (_recentLogs.isNotEmpty) {
        await calculateBurnout(userId);
      } else {
        // Initialize empty state if no logs
        _currentBurnout = BurnoutModel(
          id: _uuid.v4(),
          userId: userId,
          date: DateTime.now(),
          level: BurnoutLevel.low,
          riskScore: 0,
          explanation: 'Welcome! Complete your first check-in to start tracking your wellness.',
          riskFactors: [],
        );
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadBurnoutHistory(String userId) async {
    _setLoading(true);
    try {
      final assessment = await _firestoreService.getLatestBurnoutAssessment(userId);
      _currentBurnout = assessment;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Stream<List<DailyLogModel>> streamDailyLogs(String userId) {
    return _firestoreService.streamDailyLogs(userId).map((logs) {
      _recentLogs = logs;
      _todayLog = logs.isNotEmpty && 
          logs.first.date.year == DateTime.now().year &&
          logs.first.date.month == DateTime.now().month &&
          logs.first.date.day == DateTime.now().day
          ? logs.first
          : null;
      notifyListeners();
      return logs;
    });
  }
  
  Future<void> saveDailyLog(String userId, DailyLogModel log) async {
    _setLoading(true);
    try {
      await _firestoreService.createDailyLog(log);
      // Reload logs
      await loadDailyLogs(userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> createDailyCheckIn({
    required String userId,
    required double stressLevel,
    required String energyLevel,
    required String mood,
    required double sleepHours,
    required int activityMinutes,
    required double workloadIntensity,
    String? notes,
  }) async {
    _setLoading(true);
    try {
      final logId = _uuid.v4();
      final today = DateTime.now();
      
      // Check if log already exists for today
      final existingLog = await _firestoreService.getDailyLogByDate(userId, today);
      
      final log = DailyLogModel(
        id: existingLog?.id ?? logId,
        userId: userId,
        date: DateTime(today.year, today.month, today.day),
        stressLevel: stressLevel,
        energyLevel: energyLevel,
        mood: mood,
        sleepHours: sleepHours,
        activityMinutes: activityMinutes,
        workloadIntensity: workloadIntensity,
        notes: notes,
        createdAt: DateTime.now(),
      );
      
      await _firestoreService.createDailyLog(log);
      await loadDailyLogs(userId);
      
      // Calculate burnout after check-in
      await calculateBurnout(userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> calculateBurnout(String userId) async {
    try {
      if (_recentLogs.isEmpty) {
        _currentBurnout = BurnoutModel(
          id: _uuid.v4(),
          userId: userId,
          date: DateTime.now(),
          level: BurnoutLevel.low,
          riskScore: 0,
          explanation: 'Welcome! Complete your first check-in to start tracking your wellness.',
          riskFactors: [],
        );
        notifyListeners();
        return;
      }
      
      // Calculate burnout using the model's static method
      _currentBurnout = BurnoutModel.calculateFromLogs(userId, _recentLogs);
      
      // Save to Firestore
      await _firestoreService.saveBurnoutAssessment(_currentBurnout!);
      
      // Send gentle notification if risk is medium or high
      if (_currentBurnout!.level == BurnoutLevel.medium || 
          _currentBurnout!.level == BurnoutLevel.high) {
        await _notificationService.sendBurnoutAlert(
          userId,
          _currentBurnout!.levelString,
        );
      }
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }
  
  Stream<List<BurnoutModel>> streamBurnoutHistory(String userId) {
    return _firestoreService.streamBurnoutAssessments(userId).map((assessments) {
      _burnoutHistory = assessments;
      if (assessments.isNotEmpty) {
        _currentBurnout = assessments.first;
      }
      notifyListeners();
      return assessments;
    });
  }
  
  // Get weekly trend data for charts
  List<Map<String, dynamic>> getWeeklyTrendData() {
    if (_burnoutHistory.isEmpty) return [];
    
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    
    final weeklyData = _burnoutHistory
        .where((b) => b.date.isAfter(weekAgo))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    
    return weeklyData.map((burnout) {
      return {
        'date': burnout.date,
        'riskScore': burnout.riskScore,
        'level': burnout.level.name,
      };
    }).toList();
  }
  
  // Get stress and energy trends
  Map<String, List<Map<String, dynamic>>> getStressAndEnergyTrends() {
    if (_recentLogs.isEmpty) {
      return {'stress': [], 'energy': []};
    }
    
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    
    final weeklyLogs = _recentLogs
        .where((log) => log.date.isAfter(weekAgo))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    
    final stressData = weeklyLogs.map((log) {
      return {
        'date': log.date,
        'value': log.stressLevel,
      };
    }).toList();
    
    final energyLevels = ['Very Low', 'Low', 'Moderate', 'High', 'Very High'];
    final energyData = weeklyLogs.map((log) {
      return {
        'date': log.date,
        'value': energyLevels.indexOf(log.energyLevel).toDouble(),
      };
    }).toList();
    
    return {
      'stress': stressData,
      'energy': energyData,
    };
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
