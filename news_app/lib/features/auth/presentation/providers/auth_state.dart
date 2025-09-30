import '../../domain/entities/user_entity.dart';

class AuthState {
  final bool isLoading;
  final UserEntity? user;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  const AuthState.initial()
      : isLoading = false,
        user = null,
        error = null;

  const AuthState.loading()
      : isLoading = true,
        user = null,
        error = null;

  const AuthState.authenticated(UserEntity this.user)
      : isLoading = false,
        error = null;

  const AuthState.unauthenticated()
      : isLoading = false,
        user = null,
        error = null;

  const AuthState.error(String this.error)
      : isLoading = false,
        user = null;

  AuthState copyWith({
    bool? isLoading,
    UserEntity? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }

  bool get isAuthenticated => user != null && error == null;
  
  bool get hasError => error != null;
}