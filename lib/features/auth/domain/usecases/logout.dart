// Logout usecase to be called within the app also for knowing what went wrong
// Author: Luis Angel Beltran Sanchez
// Version: 1.0.0

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class Logout {
  final AuthRepository repository;

  const Logout(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.logout();
  }
}