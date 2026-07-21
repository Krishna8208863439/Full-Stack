import '../models/user_model.dart';

abstract class IAuthRepository {
  Future<UserModel> loginWithEmailPassword(String email, String password, String roleId);
  Future<void> sendPasswordReset(String email);
  Future<bool> verifyOtp(String otpCode);
  Future<void> logout();
  UserModel? get currentUser;
}

class AuthRepository implements IAuthRepository {
  UserModel? _mockCurrentUser = const UserModel(
    uid: 'usr_admin_001',
    email: 'admin@texmill-erp.com',
    displayName: 'Rajesh Kumar (Senior Manager)',
    roleId: 'admin',
    department: 'Plant Operations',
  );

  @override
  UserModel? get currentUser => _mockCurrentUser;

  @override
  Future<UserModel> loginWithEmailPassword(String email, String password, String roleId) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate API latency
    _mockCurrentUser = UserModel(
      uid: 'usr_${roleId}_001',
      email: email,
      displayName: email.contains('admin') ? 'Rajesh Kumar (Admin)' : 'Operational Specialist',
      roleId: roleId,
      department: 'Mill Operations',
    );
    return _mockCurrentUser!;
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
    _mockCurrentUser = null;
  }
}
