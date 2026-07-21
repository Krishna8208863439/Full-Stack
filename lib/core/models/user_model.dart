import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String roleId;
  final String department;
  final List<String> assignedLoomIds;
  final bool isActive;

  const UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.roleId,
    required this.department,
    this.assignedLoomIds = const [],
    this.isActive = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String? ?? '',
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String? ?? 'User',
      roleId: json['roleId'] as String? ?? 'admin',
      department: json['department'] as String? ?? 'Plant Ops',
      assignedLoomIds: (json['assignedLoomIds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'roleId': roleId,
      'department': department,
      'assignedLoomIds': assignedLoomIds,
      'isActive': isActive,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? roleId,
    String? department,
    List<String>? assignedLoomIds,
    bool? isActive,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      roleId: roleId ?? this.roleId,
      department: department ?? this.department,
      assignedLoomIds: assignedLoomIds ?? this.assignedLoomIds,
      isActive: isActive ?? this.isActive,
    );
  }
}
