import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/search_suggestion.dart';
import '../repositories/hotel_repository.dart';

class SearchAutocomplete extends UseCase<List<SearchSuggestion>, String> {
  SearchAutocomplete(this.repository);

  final HotelRepository repository;

  @override
  Future<Either<Failure, List<SearchSuggestion>>> call(String params) {
    return repository.searchAutocomplete(params);
  }
}
