import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/hotel_bloc.dart';
import '../bloc/hotel_event.dart';
import '../bloc/hotel_state.dart';
import '../widgets/hotel_card.dart';
import '../models/search_request.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/shimmer_hotel_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      appBar: AppBar(
        title: const Text('MyTravaly'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushReplacementNamed('/'),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.12),
                child: Icon(
                  Icons.person_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadPopularStays(),
        child: BlocBuilder<HotelBloc, HotelState>(
          builder: (context, state) {
            final children = <Widget>[
              SearchBarWidget(onSearch: _onSearch),
              const SizedBox(height: 8),
            ];

            if (state is HotelLoading) {
              children.addAll(
                List<Widget>.generate(4, (_) => const ShimmerHotelCard()),
              );
            } else if (state is HotelLoaded) {
              if (state.hotels.isEmpty) {
                children.add(const _EmptyState());
              } else {
                children.addAll(
                  state.hotels.map((hotel) => HotelCard(hotel: hotel)),
                );
              }
            } else if (state is HotelError) {
              children.add(
                _ErrorState(message: state.message, onRetry: _loadPopularStays),
              );
            } else {
              children.add(const _PlaceholderMessage());
            }

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: children,
            );
          },
        ),
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
