import 'package:equatable/equatable.dart';

import '../../domain/entities/hotel.dart';

abstract class SearchResultsState extends Equatable {
  const SearchResultsState();

  @override
  List<Object?> get props => [];
}

class SearchResultsInitial extends SearchResultsState {
  const SearchResultsInitial();
}

class SearchResultsLoading extends SearchResultsState {
  const SearchResultsLoading();
}

class SearchResultsLoaded extends SearchResultsState {
  const SearchResultsLoaded({
    required this.hotels,
    required this.hasMore,
    required this.currentPage,
    required this.excludedHotelCodes,
  });

  final List<Hotel> hotels;
  final bool hasMore;
  final int currentPage;
  final List<String> excludedHotelCodes;

  @override
  List<Object?> get props => [hotels, hasMore, currentPage, excludedHotelCodes];
}

class SearchResultsLoadingMore extends SearchResultsState {
  const SearchResultsLoadingMore({
    required this.currentHotels,
    required this.hasMore,
    required this.currentPage,
    required this.excludedHotelCodes,
  });

  final List<Hotel> currentHotels;
  final bool hasMore;
  final int currentPage;
  final List<String> excludedHotelCodes;

  @override
  List<Object?> get props => [
    currentHotels,
    hasMore,
    currentPage,
    excludedHotelCodes,
  ];
}

class SearchResultsError extends SearchResultsState {
  const SearchResultsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class SearchResultsEmpty extends SearchResultsState {
  const SearchResultsEmpty();
}
