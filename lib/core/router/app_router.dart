// App Router that handles all the navigation and some route protection
// Author: Luis Angel Beltran Sanchez
// Version: 1.0.0

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/home_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';

// Route name constants
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
}

// Our router provider which is consumed by app.dart
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: _AuthStateNotifier(ref, authState),
    redirect: (context, state) {
      final isAuthenticated = authState is AuthAuthenticated;
      final isInitial = authState is AuthInitial;
      final isLoading = authState is AuthLoading;

      // We're still checking auth status here to avoid showing anything unwanted yet
      if (isInitial || isLoading) return null;

      final isOnAuthScreen = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;

      // If an authenticated user still tries to go to login or register, we send them to the home page
      // Basically because they are already logged in :)
      if (isAuthenticated && isOnAuthScreen) return AppRoutes.home;

      // Will add protected routes soon so that's on todo for now
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
        ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
        ),
      GoRoute(
        path: AppRoutes.register,
        builder:(context, state) => const RegisterScreen(),
        ),
    ],
    );
});

// Here i bridged the riverpod state changes to be the GoRouter's refresh system
class _AuthStateNotifier extends ChangeNotifier {
  _AuthStateNotifier(this._ref, this._authState) {
    _ref.listen(authProvider, (previous, next) {
      if (previous != next) notifyListeners();
    });
  }

  final Ref _ref;
  final AuthState _authState;
}