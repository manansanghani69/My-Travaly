import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/search_suggestion.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../models/search_request.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({
    super.key,
    required this.onSearch,
    this.initialQuery,
  });

  final ValueChanged<SearchRequest> onSearch;
  final String? initialQuery;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  Timer? _debounce;
  static const _debounceDuration = Duration(milliseconds: 350);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery ?? '');
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant SearchBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuery != oldWidget.initialQuery) {
      final nextValue = widget.initialQuery ?? '';
      if (_controller.text != nextValue) {
        _controller.text = nextValue;
        _controller.selection = TextSelection.collapsed(
          offset: nextValue.length,
        );
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Search by hotel, city, state, or country',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  final query = _controller.text.trim();
                  if (query.isEmpty) return;
                  _submitRequest(_requestFromQuery(query));
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: _onQueryChanged,
            onSubmitted: (value) {
              final query = value.trim();
              if (query.isEmpty) return;
              _submitRequest(_requestFromQuery(query));
            },
          ),
        ),
        BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: CircularProgressIndicator(),
              );
            }

            if (state is SuggestionsLoaded) {
              return _SuggestionList(
                suggestions: state.suggestions,
                onSuggestionSelected: (suggestion) {
                  _submitRequest(_requestFromSuggestion(suggestion));
                },
              );
            }

            if (state is SearchError) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Text(
                  state.message,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.redAccent),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  void _onQueryChanged(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      _debounce?.cancel();
      context.read<SearchBloc>().add(const ClearSuggestionsEvent());
      return;
    }

    if (trimmed.length < 3) {
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      if (!mounted) return;
      context.read<SearchBloc>().add(GetAutocompleteSuggestionsEvent(trimmed));
    });
  }

  void _submitRequest(SearchRequest request) {
    _debounce?.cancel();
    final validatedRequest = _normalizeRequest(request);
    if (validatedRequest == null) {
      return;
    }

    widget.onSearch(validatedRequest);
    context.read<SearchBloc>().add(const ClearSuggestionsEvent());
    _controller
      ..text = validatedRequest.displayText
      ..selection = TextSelection.collapsed(
        offset: validatedRequest.displayText.length,
      );
    _focusNode.unfocus();
  }

  SearchRequest? _normalizeRequest(SearchRequest request) {
    if (request.searchType == 'citySearch' &&
        request.searchQuery.length < 3) {
      final suggestion = _bestSuggestionFor(request.displayText);
      if (suggestion != null) {
        return _requestFromSuggestion(suggestion);
      }

      final parts = request.displayText
          .split(',')
          .map((value) => value.trim())
          .where((value) => value.isNotEmpty)
          .toList();

      if (parts.length >= 3) {
        return request.copyWith(searchQuery: parts.take(3).toList());
      }

      _showValidationMessage(
        'Please select a suggestion to include city, state, and country.',
      );
      return null;
    }

    return request;
  }

  SearchSuggestion? _bestSuggestionFor(String query) {
    final blocState = context.read<SearchBloc>().state;
    if (blocState is! SuggestionsLoaded || blocState.suggestions.isEmpty) {
      return null;
    }

    final suggestions = blocState.suggestions;
    final normalized = query.trim().toLowerCase();

    if (normalized.isEmpty) {
      return suggestions.first;
    }

    for (final suggestion in suggestions) {
      if (suggestion.valueToDisplay.toLowerCase().contains(normalized)) {
        return suggestion;
      }
    }

    return suggestions.first;
  }

  void _showValidationMessage(String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return;
    }
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  SearchRequest _requestFromQuery(String query) {
    return SearchRequest(
      displayText: query,
      searchType: 'citySearch',
      searchQuery: [query],
    );
  }

  SearchRequest _requestFromSuggestion(SearchSuggestion suggestion) {
    final searchArray = suggestion.searchArray;

    String? typeFromArray;
    List<String> queryParts = <String>[];

    if (searchArray.isNotEmpty) {
      final first = searchArray.first;
      if (_looksLikeSearchType(first)) {
        typeFromArray = first;
        queryParts = searchArray
            .skip(1)
            .where((value) => value.isNotEmpty)
            .toList();
      } else {
        queryParts = searchArray.where((value) => value.isNotEmpty).toList();
      }
    }

    final searchType = _normalizeSearchType(typeFromArray ?? suggestion.type);
    if (queryParts.isEmpty) {
      queryParts = <String>[suggestion.valueToDisplay];
    }

    return SearchRequest(
      displayText: suggestion.valueToDisplay,
      searchType: searchType,
      searchQuery: queryParts,
    );
  }

  bool _looksLikeSearchType(String value) {
    final lower = value.toLowerCase();
    return lower.contains('search') ||
        lower.contains('city') ||
        lower.contains('state') ||
        lower.contains('country');
  }

  String _normalizeSearchType(String value) {
    final lower = value.toLowerCase();
    if (lower.contains('hotel') ||
        lower.contains('property') ||
        lower.contains('id')) {
      return 'hotelIdSearch';
    }
    if (lower.contains('country')) {
      return 'countrySearch';
    }
    if (lower.contains('state')) {
      return 'stateSearch';
    }
    if (lower.contains('city')) {
      return 'citySearch';
    }
    if (lower.contains('airport')) {
      return 'airportSearch';
    }
    return 'citySearch';
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({
    required this.suggestions,
    required this.onSuggestionSelected,
  });

  final List<SearchSuggestion> suggestions;
  final ValueChanged<SearchSuggestion> onSuggestionSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: suggestions.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ListTile(
            leading: const Icon(Icons.location_city_outlined),
            title: Text(suggestion.valueToDisplay),
            subtitle: Text(suggestion.type),
            onTap: () => onSuggestionSelected(suggestion),
          );
        },
      ),
    );
  }
}
