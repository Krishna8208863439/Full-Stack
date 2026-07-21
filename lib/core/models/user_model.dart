import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String photoUrl;
  final String role; // 'admin' or 'worker'
  final String department;
  final List<String> assignedLoomIds;
  final bool isActive;
  final String createdAt;
  final String lastLogin;
  final String deviceInfo;

  const UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl = '',
    required this.role,
    required this.department,
    this.assignedLoomIds = const [],
    this.isActive = true,
    this.createdAt = '',
    this.lastLogin = '',
    this.deviceInfo = 'Flutter Web Workstation',
  });

  bool get isAdmin => role == 'admin';
  bool get isWorker => role == 'worker';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String? ?? '',
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String? ?? json['name'] as String? ?? 'User',
      photoUrl: json['photoUrl'] as String? ?? json['photo'] as String? ?? '',
      role: json['role'] as String? ?? 'admin',
      department: json['department'] as String? ?? 'Plant Ops',
      assignedLoomIds: (json['assignedLoomIds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      lastLogin: json['lastLogin'] as String? ?? DateTime.now().toIso8601String(),
      deviceInfo: json['deviceInfo'] as String? ?? 'Flutter Workstation',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'name': displayName,
      'photoUrl': photoUrl,
      'photo': photoUrl,
      'role': role,
      'department': department,
      'assignedLoomIds': assignedLoomIds,
      'isActive': isActive,
      'createdAt': createdAt,
      'lastLogin': lastLogin,
      'deviceInfo': deviceInfo,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    String? role,
    String? department,
    List<String>? assignedLoomIds,
    bool? isActive,
    String? createdAt,
    String? lastLogin,
    String? deviceInfo,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      department: department ?? this.department,
      assignedLoomIds: assignedLoomIds ?? this.assignedLoomIds,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      deviceInfo: deviceInfo ?? this.deviceInfo,
    );
  }
}
