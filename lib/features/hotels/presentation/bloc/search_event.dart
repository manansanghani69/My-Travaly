import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class GetAutocompleteSuggestionsEvent extends SearchEvent {
  const GetAutocompleteSuggestionsEvent(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class ClearSuggestionsEvent extends SearchEvent {
  const ClearSuggestionsEvent();
}
