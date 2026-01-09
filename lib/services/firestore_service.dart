import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/daily_log_model.dart';
import '../models/burnout_model.dart';
import '../core/constants/app_constants.dart';

class FirestoreService {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  
  // User Operations
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.id)
          .set(user.toMap());
    } catch (e) {
      throw 'Failed to create user: $e';
    }
  }
  
  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();
      
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw 'Failed to get user: $e';
    }
  }
  
  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update(updates);
    } catch (e) {
      throw 'Failed to update user: $e';
    }
  }
  
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .delete();
    } catch (e) {
      throw 'Failed to delete user: $e';
    }
  }
  
  // Daily Log Operations
  Future<void> createDailyLog(DailyLogModel log) async {
    try {
      await _firestore
          .collection(AppConstants.dailyLogsCollection)
          .doc(log.id)
          .set(log.toMap());
    } catch (e) {
      throw 'Failed to create daily log: $e';
    }
  }
  
  Future<List<DailyLogModel>> getDailyLogs(String userId, {int limit = 30}) async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.dailyLogsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .limit(limit)
          .get();
      
      return querySnapshot.docs
          .map((doc) => DailyLogModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw 'Failed to get daily logs: $e';
    }
  }
  
  Future<DailyLogModel?> getDailyLogByDate(String userId, DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      
      final querySnapshot = await _firestore
          .collection(AppConstants.dailyLogsCollection)
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('date', isLessThan: endOfDay.toIso8601String())
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        return DailyLogModel.fromMap(querySnapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      throw 'Failed to get daily log: $e';
    }
  }
  
  Future<void> updateDailyLog(String logId, Map<String, dynamic> updates) async {
    try {
      await _firestore
          .collection(AppConstants.dailyLogsCollection)
          .doc(logId)
          .update(updates);
    } catch (e) {
      throw 'Failed to update daily log: $e';
    }
  }
  
  Stream<List<DailyLogModel>> streamDailyLogs(String userId, {int limit = 7}) {
    return _firestore
        .collection(AppConstants.dailyLogsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DailyLogModel.fromMap(doc.data()))
            .toList());
  }
  
  // Burnout Operations
  Future<void> saveBurnoutAssessment(BurnoutModel burnout) async {
    try {
      await _firestore
          .collection('burnout_assessments')
          .doc(burnout.id)
          .set(burnout.toMap());
    } catch (e) {
      throw 'Failed to save burnout assessment: $e';
    }
  }
  
  Future<BurnoutModel?> getLatestBurnoutAssessment(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('burnout_assessments')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        return BurnoutModel.fromMap(querySnapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      throw 'Failed to get burnout assessment: $e';
    }
  }
  
  Stream<List<BurnoutModel>> streamBurnoutAssessments(String userId, {int limit = 7}) {
    return _firestore
        .collection('burnout_assessments')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BurnoutModel.fromMap(doc.data()))
            .toList());
  }
  
  // Profile Data Operations
  Future<void> saveProfileData(String userId, Map<String, dynamic> profileData) async {
    try {
      await updateUser(userId, {
        'profileData': profileData,
        'profileCompleted': true,
      });
    } catch (e) {
      throw 'Failed to save profile data: $e';
    }
  }
  
  // Notification Operations
  Future<void> saveNotification(String userId, Map<String, dynamic> notification) async {
    try {
      await _firestore
          .collection(AppConstants.notificationsCollection)
          .add({
        ...notification,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
        'read': false,
      });
    } catch (e) {
      throw 'Failed to save notification: $e';
    }
  }
  
  Future<List<Map<String, dynamic>>> getNotifications(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.notificationsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();
      
      return querySnapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();
    } catch (e) {
      throw 'Failed to get notifications: $e';
    }
  }
  
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _firestore
          .collection(AppConstants.notificationsCollection)
          .doc(notificationId)
          .update({'read': true});
    } catch (e) {
      throw 'Failed to mark notification as read: $e';
    }
  }
}
