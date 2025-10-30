import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/hotel.dart';
import '../repositories/hotel_repository.dart';

class GetPopularStays extends UseCase<List<Hotel>, PopularStaysParams> {
  GetPopularStays(this.repository);

  final HotelRepository repository;

  @override
  Future<Either<Failure, List<Hotel>>> call(PopularStaysParams params) {
    return repository.getPopularStays(
      city: params.city,
      state: params.state,
      country: params.country,
    );
  }
}

class PopularStaysParams extends Equatable {
  const PopularStaysParams({
    required this.city,
    required this.state,
    required this.country,
  });

  final String city;
  final String state;
  final String country;

  @override
  List<Object?> get props => [city, state, country];
}
