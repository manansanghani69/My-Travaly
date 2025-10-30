import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/hotel.dart';
import '../../domain/entities/search_suggestion.dart';
import '../../domain/repositories/hotel_repository.dart';
import '../../domain/usecases/get_search_results.dart';
import '../datasources/hotel_remote_data_source.dart';

class HotelRepositoryImpl implements HotelRepository {
  HotelRepositoryImpl({
    required HotelRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  final HotelRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, List<Hotel>>> getPopularStays({
    required String city,
    required String state,
    required String country,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final hotels = await _remoteDataSource.getPopularStays(
        city: city,
        state: state,
        country: country,
      );
      return Right(hotels);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message ?? 'Unable to load hotels'));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SearchSuggestion>>> searchAutocomplete(
    String query,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final suggestions = await _remoteDataSource.searchAutocomplete(query);
      return Right(suggestions);
    } on ServerException catch (error) {
      return Left(
        ServerFailure(error.message ?? 'Unable to fetch suggestions'),
      );
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> registerDevice() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final token = await _remoteDataSource.registerDevice();
      return Right(token);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message ?? 'Device registration failed'));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Hotel>>> getSearchResults(
    SearchParams params,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final hotels = await _remoteDataSource.getSearchResults(params);
      return Right(hotels);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message ?? 'Unable to fetch results'));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
