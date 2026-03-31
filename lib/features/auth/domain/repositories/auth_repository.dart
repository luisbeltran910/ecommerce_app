// My simple auth class operations for the app
// Author: Luis Angel Beltran Sanchez
// Version: 1.0.0

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
    Future<Either<Failure, User>> login({
        required String email,
        required String password,
    });

    Future<Either<Failure, User>> register({
        required String name,
        required String email,
        required String password,
    });

    Future<Either<Failure, void>> logout();

    Future<Either<Failure, User?>> getCurrentUser();
}