import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/search_autocomplete.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required SearchAutocomplete searchAutocomplete})
    : _searchAutocomplete = searchAutocomplete,
      super(const SearchInitial()) {
    on<GetAutocompleteSuggestionsEvent>(_onGetSuggestions);
    on<ClearSuggestionsEvent>((event, emit) => emit(const SearchInitial()));
  }

  final SearchAutocomplete _searchAutocomplete;

  Future<void> _onGetSuggestions(
    GetAutocompleteSuggestionsEvent event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.length < 3) {
      emit(const SearchInitial());
      return;
    }

    emit(const SearchLoading());
    final result = await _searchAutocomplete(query);

    result.fold(
      (failure) =>
          emit(SearchError(failure.message ?? 'Unable to fetch suggestions')),
      (suggestions) {
        if (suggestions.isEmpty) {
          emit(const SearchInitial());
        } else {
          emit(SuggestionsLoaded(suggestions));
        }
      },
    );
  }
}
