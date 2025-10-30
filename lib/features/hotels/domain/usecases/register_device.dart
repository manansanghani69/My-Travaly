import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/hotel_repository.dart';

class RegisterDevice extends UseCase<String, NoParams> {
  RegisterDevice(this.repository);

  final HotelRepository repository;

  @override
  Future<Either<Failure, String>> call(NoParams params) {
    return repository.registerDevice();
  }
}
