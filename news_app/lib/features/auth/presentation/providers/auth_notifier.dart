import 'package:flutter_riverpod/legacy.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AuthState.initial()) {
    _checkInitialAuthStatus();
  }

  Future<void> _checkInitialAuthStatus() async {
    state = const AuthState.loading();
    await checkAuthStatus();
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AuthState.loading();

    final result = await _authRepository.signUpWithEmailAndPassword(
      email: email,
      password: password,
      displayName: displayName,
    );

    result.fold(
      (error) {
        state = AuthState.error(error);
      },
      (_) {
        state = const AuthState.unauthenticated();
      },
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AuthState.loading();

    final result = await _authRepository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    result.fold(
      (error) {
        state = AuthState.error(error);
      },
      (user) {
        state = AuthState.authenticated(user);
      },
    );
  }

  Future<void> signOut() async {
    state = const AuthState.loading();

    final result = await _authRepository.signOut();

    result.fold(
      (error) {
        state = AuthState.error(error);
      },
      (_) {
        state = const AuthState.unauthenticated();
      },
    );
  }

  Future<void> checkAuthStatus() async {
    final result = await _authRepository.getCurrentUser();

    result.fold(
      (error) {
        state = AuthState.error(error);
      },
      (user) {
        if (user != null) {
          state = AuthState.authenticated(user);
        } else {
          state = const AuthState.unauthenticated();
        }
      },
    );
  }

  void clearError() {
    if (state.error != null) {
      final currentUser = state.user;
      if (currentUser != null) {
        state = AuthState.authenticated(currentUser);
      } else {
        state = const AuthState.unauthenticated();
      }
    }
  }
}
