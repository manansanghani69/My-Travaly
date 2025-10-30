import 'package:equatable/equatable.dart';

import '../../domain/usecases/get_search_results.dart';
import '../models/search_request.dart';

abstract class SearchResultsEvent extends Equatable {
  const SearchResultsEvent();

  @override
  List<Object?> get props => [];
}

class PerformSearchEvent extends SearchResultsEvent {
  const PerformSearchEvent({
    required this.request,
    required this.params,
    this.reset = true,
  });

  final SearchRequest request;
  final SearchParams params;
  final bool reset;

  @override
  List<Object?> get props => [request, params, reset];
}

class LoadMoreResultsEvent extends SearchResultsEvent {
  const LoadMoreResultsEvent();
}

class RefreshSearchEvent extends SearchResultsEvent {
  const RefreshSearchEvent();
}
