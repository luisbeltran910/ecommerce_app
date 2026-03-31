// Login usecase to be called within the app also for knowing what went wrong
// Author: Luis Angel Beltran Sanchez
// Version: 1.0.0

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });
}

class Login {
  final AuthRepository repository;

  const Login(this.repository);

  Future<Either<Failure, User>> call(LoginParams params) {
    return repository.login(
      email: params.email, 
      password: params.password,
      );
  }
}