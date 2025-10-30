import 'package:equatable/equatable.dart';

import '../../domain/entities/search_suggestion.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SuggestionsLoaded extends SearchState {
  const SuggestionsLoaded(this.suggestions);

  final List<SearchSuggestion> suggestions;

  @override
  List<Object?> get props => [suggestions];
}

class SearchError extends SearchState {
  const SearchError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
