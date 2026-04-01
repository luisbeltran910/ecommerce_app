// Auth Provider will handle our authentication across the whole app
// Author: Luis Angel Beltran Sanchez
// Version: 1.0.0

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/register.dart';
import '../../data/repositories/auth_repository_impl.dart';

// Our actual Auth State
sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {}

// Auth Notifier stuff
class AuthNotifier extends Notifier<AuthState> {
  late final Login _login;
  late final Register _register;
  late final Logout _logout;

  @override
  AuthState build() {
    final repository = AuthRepositoryImpl();
    _login = Login(repository);
    _register = Register(repository);
    _logout = Logout(repository);
    return AuthInitial();
  }

  Future<void> checkAuthStatus() async {
    state = AuthLoading();

    final repository = AuthRepositoryImpl();
    final result = await repository.getCurrentUser();

    result.fold(
      (failure) => state = AuthUnauthenticated(),
      (user) => state = user != null
          ? AuthAuthenticated(user)
          : AuthUnauthenticated(),
    );
  }

  Future<String?> login(String email, String password) async {
    state = AuthLoading();

    final result = await _login(LoginParams(
      email: email, 
      password: password,
      ));

    return result.fold(
      (failure) {
        state = AuthUnauthenticated();
        return failure.message;
      },
      (user) {
        state = AuthAuthenticated(user);
        return null;
      },
    );
  }

  Future<String?> register(String name, String email, String password) async {
    state = AuthLoading();

    final result = await _register(RegisterParams(
      name: name, 
      email: email, 
      password: password,
      ));

    return result.fold(
      (failure) {
        state = AuthUnauthenticated();
        return failure.message;
      },
      (user) {
        state = AuthAuthenticated(user);
        return null;
      },
    );
  }

  Future<void> logout() async{
    state = AuthLoading();
    await _logout();
    state = AuthUnauthenticated();
  }
}

// Provider definition for the app
final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
