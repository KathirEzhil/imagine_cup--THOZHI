class UserModel {
  final String id;
  final String? email;
  final String? phone;
  final String name;
  final String language;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool profileCompleted;
  final Map<String, dynamic>? profileData;
  
  UserModel({
    required this.id,
    this.email,
    this.phone,
    required this.name,
    this.language = 'English(US)',
    required this.createdAt,
    this.lastLoginAt,
    this.profileCompleted = false,
    this.profileData,
  });
  
  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'name': name,
      'language': language,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'profileCompleted': profileCompleted,
      'profileData': profileData,
    };
  }
  
  // Create from Map (Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'],
      phone: map['phone'],
      name: map['name'] ?? '',
      language: map['language'] ?? 'English(US)',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      lastLoginAt: map['lastLoginAt'] != null 
          ? DateTime.parse(map['lastLoginAt']) 
          : null,
      profileCompleted: map['profileCompleted'] ?? false,
      profileData: map['profileData'],
    );
  }
  
  // Copy with method
  UserModel copyWith({
    String? id,
    String? email,
    String? phone,
    String? name,
    String? language,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? profileCompleted,
    Map<String, dynamic>? profileData,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      profileData: profileData ?? this.profileData,
    );
  }
}
