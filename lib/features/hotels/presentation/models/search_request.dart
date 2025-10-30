import 'package:equatable/equatable.dart';

class SearchRequest extends Equatable {
  const SearchRequest({
    required this.displayText,
    required this.searchType,
    required this.searchQuery,
  });

  final String displayText;
  final String searchType;
  final List<String> searchQuery;

  SearchRequest copyWith({
    String? displayText,
    String? searchType,
    List<String>? searchQuery,
  }) {
    return SearchRequest(
      displayText: displayText ?? this.displayText,
      searchType: searchType ?? this.searchType,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [displayText, searchType, searchQuery];
}
