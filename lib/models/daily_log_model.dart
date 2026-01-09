class DailyLogModel {
  final String id;
  final String userId;
  final DateTime date;
  final double stressLevel; // 0-10
  final String energyLevel; // Very Low, Low, Moderate, High, Very High
  final String mood; // emoji
  final double sleepHours; // 0-24
  final int activityMinutes; // 0-1440
  final double workloadIntensity; // 0-10
  final String? notes;
  final DateTime createdAt;
  
  DailyLogModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.stressLevel,
    required this.energyLevel,
    required this.mood,
    required this.sleepHours,
    required this.activityMinutes,
    required this.workloadIntensity,
    this.notes,
    required this.createdAt,
  });
  
  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'stressLevel': stressLevel,
      'energyLevel': energyLevel,
      'mood': mood,
      'sleepHours': sleepHours,
      'activityMinutes': activityMinutes,
      'workloadIntensity': workloadIntensity,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  // Create from Map (Firestore)
  factory DailyLogModel.fromMap(Map<String, dynamic> map) {
    return DailyLogModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      stressLevel: (map['stressLevel'] ?? 0).toDouble(),
      energyLevel: map['energyLevel'] ?? 'Moderate',
      mood: map['mood'] ?? '😐',
      sleepHours: (map['sleepHours'] ?? 0).toDouble(),
      activityMinutes: map['activityMinutes'] ?? 0,
      workloadIntensity: (map['workloadIntensity'] ?? 0).toDouble(),
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
  
  // Copy with method
  DailyLogModel copyWith({
    String? id,
    String? userId,
    DateTime? date,
    double? stressLevel,
    String? energyLevel,
    String? mood,
    double? sleepHours,
    int? activityMinutes,
    double? workloadIntensity,
    String? notes,
    DateTime? createdAt,
  }) {
    return DailyLogModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      stressLevel: stressLevel ?? this.stressLevel,
      energyLevel: energyLevel ?? this.energyLevel,
      mood: mood ?? this.mood,
      sleepHours: sleepHours ?? this.sleepHours,
      activityMinutes: activityMinutes ?? this.activityMinutes,
      workloadIntensity: workloadIntensity ?? this.workloadIntensity,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  // Calculate daily score (0-100)
  double get dailyScore {
    // Stress is negative, energy is positive, sleep is positive (optimal 7-9hrs)
    // Mood is positive, activity is positive, workload is negative
    double score = 50; // Base score
    
    // Stress contribution (0-10, lower is better)
    score -= stressLevel * 3;
    
    // Energy contribution (0-4 scale)
    final energyIndex = ['Very Low', 'Low', 'Moderate', 'High', 'Very High'].indexOf(energyLevel);
    score += energyIndex * 4;
    
    // Sleep contribution (optimal 7-9 hours)
    if (sleepHours >= 7 && sleepHours <= 9) {
      score += 15;
    } else if (sleepHours >= 6 && sleepHours <= 10) {
      score += 10;
    } else {
      score += 5;
    }
    
    // Activity contribution (30-60 mins optimal)
    if (activityMinutes >= 30 && activityMinutes <= 60) {
      score += 10;
    } else if (activityMinutes > 0) {
      score += 5;
    }
    
    // Mood contribution
    final moodIndex = ['😢', '😔', '😐', '😌', '😊'].indexOf(mood);
    score += moodIndex * 5;
    
    // Workload contribution (lower is better, but some workload is normal)
    if (workloadIntensity <= 5) {
      score += 5;
    } else if (workloadIntensity > 8) {
      score -= 5;
    }
    
    return score.clamp(0, 100);
  }
}
