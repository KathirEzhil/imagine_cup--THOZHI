import 'daily_log_model.dart';

enum BurnoutLevel {
  low,
  medium,
  high,
}

class BurnoutModel {
  final String id;
  final String userId;
  final DateTime date;
  final BurnoutLevel level;
  final double riskScore; // 0-100
  final String explanation;
  final List<String> riskFactors;
  final Map<String, dynamic>? calculationData;
  
  BurnoutModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.level,
    required this.riskScore,
    required this.explanation,
    required this.riskFactors,
    this.calculationData,
  });
  
  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'level': level.name,
      'riskScore': riskScore,
      'explanation': explanation,
      'riskFactors': riskFactors,
      'calculationData': calculationData,
    };
  }
  
  // Create from Map (Firestore)
  factory BurnoutModel.fromMap(Map<String, dynamic> map) {
    return BurnoutModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      level: BurnoutLevel.values.firstWhere(
        (e) => e.name == map['level'],
        orElse: () => BurnoutLevel.low,
      ),
      riskScore: (map['riskScore'] ?? 0).toDouble(),
      explanation: map['explanation'] ?? '',
      riskFactors: List<String>.from(map['riskFactors'] ?? []),
      calculationData: map['calculationData'],
    );
  }
  
  String get levelString {
    switch (level) {
      case BurnoutLevel.low:
        return 'Low';
      case BurnoutLevel.medium:
        return 'Medium';
      case BurnoutLevel.high:
        return 'High';
    }
  }
  
  // Calculate burnout from recent daily logs
  static BurnoutModel calculateFromLogs(
    String userId,
    List<DailyLogModel> recentLogs, {
    String? id,
  }) {
    if (recentLogs.isEmpty) {
      return BurnoutModel(
        id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        date: DateTime.now(),
        level: BurnoutLevel.low,
        riskScore: 0,
        explanation: 'No data available yet. Please complete your daily check-ins to get burnout predictions.',
        riskFactors: [],
      );
    }
    
    // Analyze last 7 days (or available days)
    final logs = recentLogs.length > 7 ? recentLogs.sublist(0, 7) : recentLogs;
    
    // Calculate averages
    final avgStress = logs.map((e) => e.stressLevel).reduce((a, b) => a + b) / logs.length;
    final avgSleep = logs.map((e) => e.sleepHours).reduce((a, b) => a + b) / logs.length;
    final avgActivity = logs.map((e) => e.activityMinutes).reduce((a, b) => a + b) / logs.length;
    final avgWorkload = logs.map((e) => e.workloadIntensity).reduce((a, b) => a + b) / logs.length;
    
    // Energy levels (convert to numeric: 0-4)
    final energyValues = logs.map((log) {
      final levels = ['Very Low', 'Low', 'Moderate', 'High', 'Very High'];
      return levels.indexOf(log.energyLevel);
    }).toList();
    final avgEnergy = energyValues.reduce((a, b) => a + b) / energyValues.length;
    
    // Mood values (0-4 scale)
    final moodValues = logs.map((log) {
      final moods = ['😢', '😔', '😐', '😌', '😊'];
      return moods.indexOf(log.mood);
    }).toList();
    final avgMood = moodValues.reduce((a, b) => a + b) / moodValues.length;
    
    // Calculate risk score (0-100, higher = more risk)
    double riskScore = 0;
    List<String> riskFactors = [];
    
    // Stress factor (0-40 points)
    if (avgStress >= 7) {
      riskScore += 40;
      riskFactors.add('High stress levels');
    } else if (avgStress >= 5) {
      riskScore += 25;
      riskFactors.add('Moderate stress levels');
    } else {
      riskScore += avgStress * 4;
    }
    
    // Sleep factor (0-20 points)
    if (avgSleep < 5 || avgSleep > 10) {
      riskScore += 20;
      riskFactors.add('Insufficient or excessive sleep');
    } else if (avgSleep < 6 || avgSleep > 9) {
      riskScore += 10;
    }
    
    // Activity factor (0-15 points)
    if (avgActivity < 15) {
      riskScore += 15;
      riskFactors.add('Low physical activity');
    } else if (avgActivity < 30) {
      riskScore += 8;
    }
    
    // Energy factor (0-15 points)
    if (avgEnergy < 1.5) {
      riskScore += 15;
      riskFactors.add('Low energy levels');
    } else if (avgEnergy < 2.5) {
      riskScore += 10;
    }
    
    // Mood factor (0-10 points)
    if (avgMood < 2) {
      riskScore += 10;
      riskFactors.add('Low mood');
    } else if (avgMood < 2.5) {
      riskScore += 5;
    }
    
    // Workload factor (0-10 points)
    if (avgWorkload >= 8) {
      riskScore += 10;
      riskFactors.add('High workload intensity');
    } else if (avgWorkload >= 6) {
      riskScore += 5;
    }
    
    // Determine level
    BurnoutLevel level;
    String explanation;
    
    if (riskScore >= 60) {
      level = BurnoutLevel.high;
      explanation = 'Based on recent patterns in your activity and biometrics, your risk of burnout is high. Please prioritize rest and self-care, and consider seeking support.';
    } else if (riskScore >= 35) {
      level = BurnoutLevel.medium;
      explanation = 'Based on recent patterns in your activity and biometrics, your risk of burnout is moderate. Consider taking more breaks and practicing self-care.';
    } else {
      level = BurnoutLevel.low;
      explanation = 'Based on recent patterns in your activity and biometrics, your risk of burnout remains low. Keep up the great work! Your efforts in maintaining balance are paying off.';
    }
    
    return BurnoutModel(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      date: DateTime.now(),
      level: level,
      riskScore: riskScore.clamp(0, 100),
      explanation: explanation,
      riskFactors: riskFactors.isEmpty 
          ? ['No significant risk factors identified']
          : riskFactors,
      calculationData: {
        'avgStress': avgStress,
        'avgSleep': avgSleep,
        'avgActivity': avgActivity,
        'avgEnergy': avgEnergy,
        'avgMood': avgMood,
        'avgWorkload': avgWorkload,
        'daysAnalyzed': logs.length,
      },
    );
  }
}
