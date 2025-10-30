import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/google_auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required GoogleAuthLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  final GoogleAuthLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      final user = await _localDataSource.signInWithGoogle();
      return Right(user);
    } on AuthException catch (error) {
      return Left(AuthFailure(error.message ?? 'Authentication failed'));
    } catch (error) {
      return Left(AuthFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _localDataSource.signOut();
      return const Right(null);
    } catch (error) {
      return Left(AuthFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getSignedInUser() async {
    try {
      final user = await _localDataSource.getSignedInUser();
      return Right(user);
    } catch (error) {
      return Left(AuthFailure(error.toString()));
    }
  }
}
