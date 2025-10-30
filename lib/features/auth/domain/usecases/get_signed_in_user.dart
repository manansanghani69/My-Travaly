import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetSignedInUser extends UseCase<User?, NoParams> {
  GetSignedInUser(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, User?>> call(NoParams params) {
    return repository.getSignedInUser();
  }
}
