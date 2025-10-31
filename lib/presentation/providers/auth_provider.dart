import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user.dart';

/// State class for authenticated user
class AuthState {
  final User? user;
  final bool isAuthenticated;
  final String? walletAddress;

  const AuthState({
    this.user,
    this.isAuthenticated = false,
    this.walletAddress,
  });

  AuthState copyWith({
    User? user,
    bool? isAuthenticated,
    String? walletAddress,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      walletAddress: walletAddress ?? this.walletAddress,
    );
  }
}

/// Auth state notifier
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  /// Set authenticated user
  void setUser(User user, {String? walletAddress}) {
    state = AuthState(
      user: user,
      isAuthenticated: true,
      walletAddress: walletAddress,
    );
  }

  /// Clear authentication
  void logout() {
    state = const AuthState();
  }
}

/// Global auth state provider
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
