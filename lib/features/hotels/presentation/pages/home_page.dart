import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/hotel_bloc.dart';
import '../bloc/hotel_event.dart';
import '../bloc/hotel_state.dart';
import '../models/search_request.dart';
import '../widgets/hotel_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/shimmer_hotel_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _categories = <String>[
    'All',
    'Hotels',
    'Resorts',
    'Homestays',
    'Apartments',
  ];

  int _selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    _loadPopularStays();
  }

  void _loadPopularStays() {
    context.read<HotelBloc>().add(
      const LoadPopularHotelsEvent(
        city: 'Jamshedpur',
        state: 'Jharkhand',
        country: 'India',
      ),
    );
  }

  void _onSearch(SearchRequest request) {
    Navigator.of(context).pushNamed('/search', arguments: request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Color(0xFF1C1C1C)),
          tooltip: 'Menu',
          onPressed: () {},
        ),
        title: Text(
          'MyTravaly',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1C1C1C),
                letterSpacing: 0.2,
              ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFF0F1F5),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.person_outline, color: Color(0xFF1C1C1C)),
                splashRadius: 18,
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF1976D2),
        onRefresh: () async => _loadPopularStays(),
        child: BlocBuilder<HotelBloc, HotelState>(
          builder: (context, state) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      SearchBarWidget(onSearch: _onSearch),
                      const SizedBox(height: 20),
                      const _GreetingSection(),
                      const SizedBox(height: 12),
                      // _CategoryChips(
                      //   categories: _categories,
                      //   selectedIndex: _selectedCategory,
                      //   onSelected: (index) {
                      //     setState(() => _selectedCategory = index);
                      //   },
                      // ),
                      // const SizedBox(height: 12),
                      const _SectionHeader(),
                    ],
                  ),
                ),
                if (state is HotelLoading)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, __) => const ShimmerHotelCard(),
                      childCount: 3,
                    ),
                  )
                else if (state is HotelLoaded)
                  (state.hotels.isEmpty)
                      ? const SliverToBoxAdapter(
                          child: _EmptyState(),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_, index) => HotelCard(
                              hotel: state.hotels[index],
                            ),
                            childCount: state.hotels.length,
                          ),
                        )
                else if (state is HotelError)
                  SliverToBoxAdapter(
                    child: _ErrorState(
                      message: state.message,
                      onRetry: _loadPopularStays,
                    ),
                  )
                else
                  const SliverToBoxAdapter(child: _PlaceholderMessage()),
                const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GreetingSection extends StatelessWidget {
  const _GreetingSection();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Find Your Perfect Stay',
            style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1C1C1C),
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Explore top destinations handpicked for you.',
            style: textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6F6F6F),
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return ChoiceChip(
            label: Text(
              categories[index],
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF4C5A67),
                fontWeight: FontWeight.w600,
              ),
            ),
            selected: isSelected,
            onSelected: (_) => onSelected(index),
            pressElevation: 0,
            selectedColor: const Color(0xFF1976D2),
            backgroundColor: const Color(0xFFEFF3F8),
            labelPadding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Popular Stays',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1C1C1C),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, size: 64),
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
            label: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_outlined, size: 64),
          const SizedBox(height: 16),
          Text(
            'No hotels found for the selected location.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class _PlaceholderMessage extends StatelessWidget {
  const _PlaceholderMessage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Text(
        'Discover curated stays tailored for you. Start by searching for a destination.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
