import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/hotel.dart';
import '../../domain/usecases/get_search_results.dart';
import '../models/search_request.dart';
import 'search_results_event.dart';
import 'search_results_state.dart';

class SearchResultsBloc extends Bloc<SearchResultsEvent, SearchResultsState> {
  SearchResultsBloc({required GetSearchResults getSearchResults})
    : _getSearchResults = getSearchResults,
      super(const SearchResultsInitial()) {
    on<PerformSearchEvent>(_onPerformSearch);
    on<LoadMoreResultsEvent>(_onLoadMore);
    on<RefreshSearchEvent>(_onRefresh);
  }

  final GetSearchResults _getSearchResults;
  SearchParams? _baseParams;
  final List<Hotel> _hotels = [];
  final Set<String> _seenHotelCodes = <String>{};
  int _currentPage = 0;
  bool _hasMore = true;
  SearchRequest? _currentRequest;

  Future<void> _onPerformSearch(
    PerformSearchEvent event,
    Emitter<SearchResultsState> emit,
  ) async {
    if (event.reset) {
      _hotels.clear();
      _seenHotelCodes.clear();
      _currentPage = 0;
      _hasMore = true;
      _currentRequest = event.request;
      emit(const SearchResultsLoading());
    }

    _baseParams = event.params.copyWith(offset: 0);
    final effectiveParams = _baseParams!.copyWith(
      offset: _currentPage * _baseParams!.limit,
      excludedPropertyCodes: _seenHotelCodes.toList(),
    );

    final result = await _getSearchResults(effectiveParams);

    result.fold(
      (failure) => emit(
        SearchResultsError(failure.message ?? 'Unable to fetch results'),
      ),
      (hotels) {
        _hasMore = hotels.length >= effectiveParams.limit;
        final uniqueHotels = _extractUniqueHotels(hotels);

        if (event.reset) {
          _hotels
            ..clear()
            ..addAll(uniqueHotels);
        } else {
          _hotels.addAll(uniqueHotels);
        }

        if (_hotels.isEmpty) {
          emit(const SearchResultsEmpty());
        } else {
          emit(
            SearchResultsLoaded(
              hotels: List<Hotel>.unmodifiable(_hotels),
              hasMore: _hasMore,
              currentPage: _currentPage,
              excludedHotelCodes: List<String>.unmodifiable(_seenHotelCodes),
            ),
          );
        }
      },
    );
  }

  Future<void> _onLoadMore(
    LoadMoreResultsEvent event,
    Emitter<SearchResultsState> emit,
  ) async {
    if (!_hasMore || _baseParams == null) {
      return;
    }

    emit(
      SearchResultsLoadingMore(
        currentHotels: List<Hotel>.unmodifiable(_hotels),
        hasMore: _hasMore,
        currentPage: _currentPage,
        excludedHotelCodes: List<String>.unmodifiable(_seenHotelCodes),
      ),
    );

    _currentPage += 1;

    final effectiveParams = _baseParams!.copyWith(
      offset: _currentPage * _baseParams!.limit,
      excludedPropertyCodes: _seenHotelCodes.toList(),
    );

    final result = await _getSearchResults(effectiveParams);

    result.fold(
      (failure) {
        _currentPage -= 1;
        emit(
          SearchResultsError(failure.message ?? 'Unable to load more results'),
        );
      },
      (hotels) {
        _hasMore = hotels.length >= effectiveParams.limit;
        final uniqueHotels = _extractUniqueHotels(hotels);
        _hotels.addAll(uniqueHotels);

        emit(
          SearchResultsLoaded(
            hotels: List<Hotel>.unmodifiable(_hotels),
            hasMore: _hasMore,
            currentPage: _currentPage,
            excludedHotelCodes: List<String>.unmodifiable(_seenHotelCodes),
          ),
        );
      },
    );
  }

  Future<void> _onRefresh(
    RefreshSearchEvent event,
    Emitter<SearchResultsState> emit,
  ) async {
    if (_baseParams == null || _currentRequest == null) {
      return;
    }

    add(
      PerformSearchEvent(
        request: _currentRequest!,
        params: _baseParams!.copyWith(offset: 0),
        reset: true,
      ),
    );
  }

  List<Hotel> _extractUniqueHotels(List<Hotel> hotels) {
    final uniqueHotels = <Hotel>[];
    for (final hotel in hotels) {
      final key = _hotelKey(hotel);
      if (_seenHotelCodes.add(key)) {
        uniqueHotels.add(hotel);
      }
    }
    return uniqueHotels;
  }

  String _hotelKey(Hotel hotel) {
    final code = hotel.propertyCode.trim();
    if (code.isNotEmpty) {
      return code;
    }
    final name = hotel.propertyName.trim();
    final city = hotel.address.city.trim();
    return '$name|$city|${hotel.staticPrice.amount}';
  }
}
