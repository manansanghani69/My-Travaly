import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/hotel.dart';
import '../repositories/hotel_repository.dart';

class GetSearchResults extends UseCase<List<Hotel>, SearchParams> {
  GetSearchResults(this.repository);

  final HotelRepository repository;

  @override
  Future<Either<Failure, List<Hotel>>> call(SearchParams params) {
    return repository.getSearchResults(params);
  }
}

class SearchParams extends Equatable {
  const SearchParams({
    required this.checkIn,
    required this.checkOut,
    required this.rooms,
    required this.adults,
    required this.children,
    required this.searchType,
    required this.searchQuery,
    this.limit = 5,
    this.offset = 0,
    this.excludedPropertyCodes = const [],
    this.accommodation = const ['all'],
    this.excludedSearchTypes = const ['street'],
    this.currency = 'INR',
    this.lowPrice = '0',
    this.highPrice = '3000000',
    this.requestId = 0,
  });

  final String checkIn;
  final String checkOut;
  final int rooms;
  final int adults;
  final int children;
  final String searchType;
  final List<String> searchQuery;
  final int limit;
  final int offset;
  final List<String> excludedPropertyCodes;
  final List<String> accommodation;
  final List<String> excludedSearchTypes;
  final String currency;
  final String lowPrice;
  final String highPrice;
  final int requestId;

  SearchParams copyWith({
    String? checkIn,
    String? checkOut,
    int? rooms,
    int? adults,
    int? children,
    String? searchType,
    List<String>? searchQuery,
    int? limit,
    int? offset,
    List<String>? excludedPropertyCodes,
    List<String>? accommodation,
    List<String>? excludedSearchTypes,
    String? currency,
    String? lowPrice,
    String? highPrice,
    int? requestId,
  }) {
    return SearchParams(
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      rooms: rooms ?? this.rooms,
      adults: adults ?? this.adults,
      children: children ?? this.children,
      searchType: searchType ?? this.searchType,
      searchQuery: searchQuery ?? this.searchQuery,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      excludedPropertyCodes:
          excludedPropertyCodes ?? this.excludedPropertyCodes,
      accommodation: accommodation ?? this.accommodation,
      excludedSearchTypes: excludedSearchTypes ?? this.excludedSearchTypes,
      currency: currency ?? this.currency,
      lowPrice: lowPrice ?? this.lowPrice,
      highPrice: highPrice ?? this.highPrice,
      requestId: requestId ?? this.requestId,
    );
  }

  @override
  List<Object?> get props => [
    checkIn,
    checkOut,
    rooms,
    adults,
    children,
    searchType,
    searchQuery,
    limit,
    offset,
    excludedPropertyCodes,
    accommodation,
    excludedSearchTypes,
    currency,
    lowPrice,
    highPrice,
    requestId,
  ];
}
