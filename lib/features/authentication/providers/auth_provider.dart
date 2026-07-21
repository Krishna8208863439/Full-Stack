import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/user_model.dart';
import '../../../core/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository();
});

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  bool get isAdmin => user?.role == 'admin';
  bool get isWorker => user?.role == 'worker';

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepository _repository;

  AuthNotifier(this._repository)
      : super(AuthState(
          user: _repository.currentUser,
          isAuthenticated: _repository.currentUser != null,
        ));

  Future<bool> login(String email, String password, String role) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.loginWithEmailPassword(email, password, role);
      state = state.copyWith(
        user: user,
        isLoading: false,
        isAuthenticated: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Invalid credentials or connection error.',
      );
      return false;
    }
  }

  Future<bool> loginWithGoogle(String role) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.signInWithGoogle(role);
      state = state.copyWith(
        user: user,
        isLoading: false,
        isAuthenticated: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Google authentication failed.',
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState(user: null, isAuthenticated: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});
