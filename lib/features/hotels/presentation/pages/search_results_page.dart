import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/hotel.dart';
import '../../domain/usecases/get_search_results.dart';
import '../bloc/search_results_bloc.dart';
import '../bloc/search_results_event.dart';
import '../bloc/search_results_state.dart';
import '../models/search_request.dart';
import '../widgets/hotel_card.dart';
import '../widgets/pagination_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/shimmer_hotel_card.dart';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key, required this.initialRequest});

  final SearchRequest initialRequest;

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late final ScrollController _scrollController;
  late final String _defaultCheckIn;
  late final String _defaultCheckOut;
  late SearchRequest _currentRequest;

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

  @override
  Widget build(BuildContext context) {
    final title = _currentRequest.displayText.isEmpty
        ? 'Search Results'
        : 'Results for "${_currentRequest.displayText}"';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          SearchBarWidget(
            initialQuery: _currentRequest.displayText,
            onSearch: _handleSearch,
          ),
          Expanded(
            child: BlocBuilder<SearchResultsBloc, SearchResultsState>(
              builder: (context, state) {
                if (state is SearchResultsLoading) {
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

                if (state is SearchResultsLoaded) {
                  return _SearchResultsList(
                    scrollController: _scrollController,
                    hotels: state.hotels,
                    hasMore: state.hasMore,
                    isLoadingMore: false,
                    onRefresh: _onRefresh,
                    onLoadMore: () => context.read<SearchResultsBloc>().add(
                      const LoadMoreResultsEvent(),
                    ),
                  );
                }

                if (state is SearchResultsLoadingMore) {
                  return _SearchResultsList(
                    scrollController: _scrollController,
                    hotels: state.currentHotels,
                    hasMore: state.hasMore,
                    isLoadingMore: true,
                    onRefresh: _onRefresh,
                    onLoadMore: () => context.read<SearchResultsBloc>().add(
                      const LoadMoreResultsEvent(),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
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
          return HotelCard(hotel: hotels[index]);
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
      itemCount: 4,
      itemBuilder: (_, __) => const ShimmerHotelCard(),
    );
  }
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
            const Icon(Icons.error_outline, size: 64),
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
