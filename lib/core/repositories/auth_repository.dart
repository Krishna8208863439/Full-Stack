import '../models/user_model.dart';

abstract class IAuthRepository {
  Future<UserModel> loginWithEmailPassword(String email, String password, String role);
  Future<UserModel> signInWithGoogle(String role);
  Future<void> sendPasswordReset(String email);
  Future<bool> verifyOtp(String otpCode);
  Future<void> logout();
  UserModel? get currentUser;
}

class AuthRepository implements IAuthRepository {
  UserModel? _currentUser = const UserModel(
    uid: 'usr_admin_001',
    email: 'admin@texmill-erp.com',
    displayName: 'Rajesh Kumar (Plant Manager)',
    photoUrl: 'https://lh3.googleusercontent.com/a/default-user',
    role: 'admin',
    department: 'Plant Operations',
    assignedLoomIds: ['AJ-001', 'AJ-002', 'RP-003', 'AJ-004', 'AJ-005', 'RP-006'],
  );

  @override
  UserModel? get currentUser => _currentUser;

  @override
  Future<UserModel> loginWithEmailPassword(String email, String password, String role) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Latency simulation
    _currentUser = UserModel(
      uid: 'usr_${role}_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: role == 'admin' ? 'Rajesh Kumar (Admin)' : 'John Weaver (Worker)',
      role: role,
      department: role == 'admin' ? 'Plant Management' : 'Shed A Weaving Floor',
      assignedLoomIds: role == 'admin' ? ['AJ-001', 'AJ-002', 'RP-003'] : ['AJ-001', 'AJ-002'],
      lastLogin: DateTime.now().toIso8601String(),
    );
    return _currentUser!;
  }

  @override
  Future<UserModel> signInWithGoogle(String selectedRole) async {
    await Future.delayed(const Duration(milliseconds: 700));
    _currentUser = UserModel(
      uid: 'google_user_${DateTime.now().millisecondsSinceEpoch}',
      email: 'krishna.g@gmail.com',
      displayName: 'Krishna (Google Account)',
      photoUrl: 'https://lh3.googleusercontent.com/a/default-avatar',
      role: selectedRole,
      department: selectedRole == 'admin' ? 'Executive Operations' : 'Weaving Floor Operator',
      assignedLoomIds: selectedRole == 'admin' ? ['AJ-001', 'RP-003'] : ['AJ-001'],
      createdAt: DateTime.now().toIso8601String(),
      lastLogin: DateTime.now().toIso8601String(),
      deviceInfo: 'Google One-Tap Session',
    );
    return _currentUser!;
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<bool> verifyOtp(String otpCode) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return otpCode == '123456';
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }
}
