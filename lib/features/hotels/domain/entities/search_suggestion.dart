import 'package:equatable/equatable.dart';

class SearchSuggestion extends Equatable {
  final String valueToDisplay;
  final String type;
  final List<String> searchArray;

  const SearchSuggestion({
    required this.valueToDisplay,
    required this.type,
    required this.searchArray,
  });

  @override
  List<Object?> get props => [valueToDisplay, type, searchArray];
}
