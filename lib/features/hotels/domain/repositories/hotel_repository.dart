import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/hotel.dart';
import '../entities/search_suggestion.dart';
import '../usecases/get_search_results.dart';

abstract class HotelRepository {
  Future<Either<Failure, String>> registerDevice();
  Future<Either<Failure, List<Hotel>>> getPopularStays({
    required String city,
    required String state,
    required String country,
  });
  Future<Either<Failure, List<SearchSuggestion>>> searchAutocomplete(
    String query,
  );
  Future<Either<Failure, List<Hotel>>> getSearchResults(SearchParams params);
}
