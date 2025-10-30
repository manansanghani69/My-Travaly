import '../../domain/entities/search_suggestion.dart';

class SearchSuggestionModel extends SearchSuggestion {
  const SearchSuggestionModel({
    required super.valueToDisplay,
    required super.type,
    required super.searchArray,
  });

  factory SearchSuggestionModel.fromJson(Map<String, dynamic> json) {
    final rawValue =
        json['valueToDisplay'] ?? json['propertyName'] ?? json['name'] ?? '';

    final rawType = json['type'] ?? json['category'] ?? json['searchType'];
    String type = rawType?.toString() ?? '';
    final searchArrayRaw = json['searchArray'];
    final queries = <String>[];

    if (searchArrayRaw is Map) {
      final nestedType = searchArrayRaw['type']?.toString();
      if (nestedType != null && nestedType.isNotEmpty) {
        type = nestedType;
      }
      final query = searchArrayRaw['query'];
      if (query is List) {
        queries.addAll(
          query
              .map((dynamic entry) => entry.toString())
              .where((element) => element.isNotEmpty),
        );
      } else if (query != null) {
        queries.add(query.toString());
      }
    } else if (searchArrayRaw is List) {
      queries.addAll(
        searchArrayRaw
            .map((dynamic entry) => entry.toString())
            .where((element) => element.isNotEmpty),
      );
    } else if (searchArrayRaw != null) {
      queries.add(searchArrayRaw.toString());
    }

    if (queries.isEmpty) {
      final fallback = json['searchQuery'];
      if (fallback is List) {
        queries.addAll(
          fallback
              .map((dynamic entry) => entry.toString())
              .where((element) => element.isNotEmpty),
        );
      } else if (fallback != null) {
        queries.add(fallback.toString());
      }
    }

    return SearchSuggestionModel(
      valueToDisplay: rawValue.toString(),
      type: type,
      searchArray: queries,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'valueToDisplay': valueToDisplay,
      'type': type,
      'searchArray': searchArray,
    };
  }
}
