// AuthRepositoryImpl which will be my link to my backend for data
// Author: Luis Angel Beltran Sanchez
// Version: 1.0.0

import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  AuthRepositoryImpl({
    Dio? dio,
    FlutterSecureStorage? secureStorage,
  })  : _dio = dio ?? ApiClient.instance,
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      final token = response.data['token'] as String;
      final userModel = UserModel.fromJson(
        response.data['user'] as Map<String, dynamic>,
      );

      await _secureStorage.write(key: 'auth_token', value: token);
      await _secureStorage.write(key: 'user_id', value: userModel.id);
      await _secureStorage.write(key: 'user_name', value: userModel.name);
      await _secureStorage.write(key: 'user_email', value: userModel.email);
      await _secureStorage.write(key: 'user_role', value: userModel.role);

      return Right(userModel.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: {'name': name, 'email': email, 'password': password},
      );

      final token = response.data['token'] as String;
      final userModel = UserModel.fromJson(
        response.data['user'] as Map<String, dynamic>,
      );

      await _secureStorage.write(key: 'auth_token', value: token);
      await _secureStorage.write(key: 'user_id', value: userModel.id);
      await _secureStorage.write(key: 'user_name', value: userModel.name);
      await _secureStorage.write(key: 'user_email', value: userModel.email);
      await _secureStorage.write(key: 'user_role', value: userModel.role);

      return Right(userModel.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _secureStorage.deleteAll();
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');

      if (token == null) return const Right(null);

      final user = User(
        id: await _secureStorage.read(key: 'user_id') ?? '',
        name: await _secureStorage.read(key: 'user_name') ?? '',
        email: await _secureStorage.read(key: 'user_email') ?? '',
        role: await _secureStorage.read(key: 'user_role') ?? '',
      );

      return Right(user);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Failure _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('No internet connection was detected');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return const AuthFailure('Invalid credentials');
        }
        if (statusCode == 422) {
          return const ServerFailure('Invalid input data');
        }
        if (statusCode != null && statusCode >= 500) {
          return const ServerFailure('Server error, please try again later or contact an administrator.');
        }
        return ServerFailure('Unexpected error $statusCode');
      default:
        return UnknownFailure(e.message ?? 'Something went wrong, please try again later or contact an administrator.');
    }
  }
}