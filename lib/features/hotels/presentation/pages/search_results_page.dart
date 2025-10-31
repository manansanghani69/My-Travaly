import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../domain/entities/hotel.dart';
import '../../domain/usecases/get_search_results.dart';
import '../bloc/search_results_bloc.dart';
import '../bloc/search_results_event.dart';
import '../bloc/search_results_state.dart';
import '../models/search_request.dart';
import '../widgets/pagination_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/search_result_card.dart';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key, required this.initialRequest});

  final SearchRequest initialRequest;

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  static const _filterOptions = <String>[
    'Price',
    'Rating',
    'Amenities',
    'Property Type',
    'Distance',
  ];

  late final ScrollController _scrollController;
  late final String _defaultCheckIn;
  late final String _defaultCheckOut;
  late SearchRequest _currentRequest;
  final Set<int> _activeFilters = <int>{};

  @override
  void initState() {
    super.initState();
    _currentRequest = widget.initialRequest;
    final now = DateTime.now();
    _defaultCheckIn = DateFormat(
      'yyyy-MM-dd',
    ).format(now.add(const Duration(days: 1)));
    _defaultCheckOut = DateFormat(
      'yyyy-MM-dd',
    ).format(now.add(const Duration(days: 2)));
    _scrollController = ScrollController()..addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _performSearch(reset: true),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= maxScroll * 0.9) {
      context.read<SearchResultsBloc>().add(const LoadMoreResultsEvent());
    }
  }

  void _handleSearch(SearchRequest request) {
    setState(() {
      _currentRequest = request;
    });
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
    _performSearch(reset: true);
  }

  void _performSearch({required bool reset}) {
    context.read<SearchResultsBloc>().add(
      PerformSearchEvent(
        request: _currentRequest,
        params: _buildBaseParams(_currentRequest),
        reset: reset,
      ),
    );
  }

  SearchParams _buildBaseParams(SearchRequest request) {
    return SearchParams(
      checkIn: _defaultCheckIn,
      checkOut: _defaultCheckOut,
      rooms: 1,
      adults: 2,
      children: 0,
      searchType: request.searchType,
      searchQuery: request.searchQuery,
      limit: 5,
      offset: 0,
    );
  }

  Future<void> _onRefresh() async {
    context.read<SearchResultsBloc>().add(const RefreshSearchEvent());
  }

  Future<void> _openSearchSheet({bool clearQuery = false}) async {
    final result = await showModalBottomSheet<SearchRequest>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: SafeArea(
            child: SearchBarWidget(
              initialQuery: clearQuery ? '' : _currentRequest.displayText,
              onSearch: (request) {
                Navigator.of(sheetContext).pop(request);
              },
            ),
          ),
        );
      },
    );

    if (result != null) {
      _handleSearch(result);
    }
  }

  void _toggleFilter(int index) {
    setState(() {
      if (_activeFilters.contains(index)) {
        _activeFilters.remove(index);
      } else {
        _activeFilters.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final queryLabel = _currentRequest.displayText.isEmpty
        ? 'Search hotels, cities, destinations...'
        : _currentRequest.displayText;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: _TopBar(
        onBack: () => Navigator.of(context).maybePop(),
        onFav: () {},
      ),
      body: BlocBuilder<SearchResultsBloc, SearchResultsState>(
        builder: (context, state) {
          final hotels = _extractHotels(state);
          final hasMore = _extractHasMore(state);
          final isLoading = state is SearchResultsLoading;
          final isLoadingMore = state is SearchResultsLoadingMore;

          return Column(
            children: [
              _SearchQueryPill(
                query: queryLabel,
                onClear: _currentRequest.displayText.isEmpty
                    ? null
                    : () {
                        _handleSearch(
                          _currentRequest.copyWith(
                            searchQuery: [],
                            displayText: '',
                          ),
                        );
                      },
              ),
              // _FilterBar(
              //   filters: _filterOptions,
              //   activeFilters: _activeFilters,
              //   onFilterToggle: _toggleFilter,
              // ),
              _ResultsHeader(
                count: hotels.length,
                isFetching: isLoading && hotels.isEmpty,
              ),
              Expanded(
                child: _buildBody(
                  state: state,
                  hotels: hotels,
                  hasMore: hasMore,
                  isLoadingMore: isLoadingMore,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Hotel> _extractHotels(SearchResultsState state) {
    if (state is SearchResultsLoaded) {
      return state.hotels;
    }
    if (state is SearchResultsLoadingMore) {
      return state.currentHotels;
    }
    return const <Hotel>[];
  }

  bool _extractHasMore(SearchResultsState state) {
    if (state is SearchResultsLoaded) {
      return state.hasMore;
    }
    if (state is SearchResultsLoadingMore) {
      return state.hasMore;
    }
    return false;
  }

  Widget _buildBody({
    required SearchResultsState state,
    required List<Hotel> hotels,
    required bool hasMore,
    required bool isLoadingMore,
  }) {
    if (state is SearchResultsLoading && hotels.isEmpty) {
      return _LoadingList(controller: _scrollController);
    }

    if (state is SearchResultsError) {
      return _ErrorView(
        message: state.message,
        onRetry: () => _performSearch(reset: true),
      );
    }

    if (state is SearchResultsEmpty) {
      return _EmptyResultsView(query: _currentRequest.displayText);
    }

    return _SearchResultsList(
      scrollController: _scrollController,
      hotels: hotels,
      hasMore: hasMore,
      isLoadingMore: isLoadingMore,
      onRefresh: _onRefresh,
      onLoadMore: () =>
          context.read<SearchResultsBloc>().add(const LoadMoreResultsEvent()),
    );
  }
}

class _TopBar extends StatelessWidget implements PreferredSizeWidget {
  const _TopBar({required this.onBack, required this.onFav});

  final VoidCallback onBack;
  final VoidCallback onFav;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: onBack,
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Color(0xFF1C1C1C),
          size: 18,
        ),
      ),
      title: Text(
        'Search Results',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1C1C1C),
        ),
      ),
      actions: [
        IconButton(
          onPressed: onFav,
          icon: const Icon(
            Icons.favorite_border_rounded,
            color: Color(0xFF1C1C1C),
          ),
        ),
      ],
    );
  }
}

class _SearchQueryPill extends StatelessWidget {
  const _SearchQueryPill({required this.query, this.onClear});

  final String query;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: Color(0xFF6F7A85)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                query,
                style: const TextStyle(color: Color(0xFF1C1C1C), fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onClear != null)
              IconButton(
                onPressed: onClear,
                splashRadius: 18,
                icon: const Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: Color(0xFF9AA3AF),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.filters,
    required this.activeFilters,
    required this.onFilterToggle,
  });

  final List<String> filters;
  final Set<int> activeFilters;
  final ValueChanged<int> onFilterToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isActive = activeFilters.contains(index);
                return FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        filters[index],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, size: 16),
                    ],
                  ),
                  selected: isActive,
                  onSelected: (_) => onFilterToggle(index),
                  selectedColor: const Color(0xFFE3F2FD),
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: isActive
                        ? const Color(0xFF1976D2)
                        : const Color(0xFFE1E5EB),
                  ),
                  labelStyle: TextStyle(
                    color: isActive
                        ? const Color(0xFF1976D2)
                        : const Color(0xFF425466),
                    fontWeight: FontWeight.w600,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                );
              },
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Sort options coming soon')),
                );
            },
            icon: const Icon(Icons.sort_rounded, color: Color(0xFF1976D2)),
            splashRadius: 22,
          ),
        ],
      ),
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader({required this.count, required this.isFetching});

  final int count;
  final bool isFetching;

  @override
  Widget build(BuildContext context) {
    final label = isFetching
        ? 'Fetching stays...'
        : count == 0
        ? 'No stays found'
        : 'Found $count stays';

    return Container(
      height: 44,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF6F6F6),
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1C1C),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultsList extends StatelessWidget {
  const _SearchResultsList({
    required this.scrollController,
    required this.hotels,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onRefresh,
    required this.onLoadMore,
  });

  final ScrollController scrollController;
  final List<Hotel> hotels;
  final bool hasMore;
  final bool isLoadingMore;
  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: const Color(0xFF1976D2),
      onRefresh: onRefresh,
      child: ListView.builder(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: hasMore ? hotels.length + 1 : hotels.length,
        itemBuilder: (context, index) {
          if (index >= hotels.length) {
            return PaginationWidget(
              isLoading: isLoadingMore,
              hasMore: hasMore,
              onLoadMore: onLoadMore,
            );
          }
          return SearchResultCard(hotel: hotels[index]);
        },
      ),
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList({required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (_, __) => const _SearchResultShimmerCard(),
    );
  }
}

class _SearchResultShimmerCard extends StatelessWidget {
  const _SearchResultShimmerCard();

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey.shade300;
    final highlightColor = Colors.grey.shade100;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerBox(baseColor, width: 80, height: 14),
                      const SizedBox(height: 8),
                      _shimmerBox(baseColor, width: 160, height: 18),
                      const SizedBox(height: 8),
                      _shimmerBox(baseColor, width: 140, height: 12),
                      const SizedBox(height: 12),
                      _shimmerBox(baseColor, width: 120, height: 18),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _shimmerBox(baseColor, width: 96, height: 96, radius: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _shimmerBox(
  Color color, {
  double width = double.infinity,
  double height = 16,
  double radius = 10,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Color(0xFFD32F2F)),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyResultsView extends StatelessWidget {
  const _EmptyResultsView({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final description = query.isEmpty
        ? 'Try a different search to discover great stays.'
        : 'No hotels found for "$query". Try refining your search.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_outlined, size: 64),
            const SizedBox(height: 16),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
