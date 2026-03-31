// Register usecase to be called within the app also for knowing what went wrong
// Author: Luis Angel Beltran Sanchez
// Version: 1.0.0

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterParams {
  final String name;
  final String email;
  final String password;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });
}

class Register {
  final AuthRepository repository;

  const Register(this.repository);

  Future<Either<Failure, User>> call(RegisterParams params) {
    return repository.register(
      name: params.name, 
      email: params.email, 
      password: params.password
    );
  }
}