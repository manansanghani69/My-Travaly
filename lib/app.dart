import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/sign_in_page.dart';
import 'features/hotels/presentation/bloc/hotel_bloc.dart';
import 'features/hotels/presentation/bloc/search_bloc.dart';
import 'features/hotels/presentation/bloc/search_results_bloc.dart';
import 'features/hotels/presentation/pages/home_page.dart';
import 'features/hotels/presentation/pages/search_results_page.dart';
import 'features/hotels/presentation/models/search_request.dart';
import 'injection_container.dart';

class MyTravalyApp extends StatelessWidget {
  const MyTravalyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AuthBloc>()..add(const AuthStatusRequested()),
        ),
        BlocProvider(create: (_) => sl<HotelBloc>()),
        BlocProvider(create: (_) => sl<SearchBloc>()),
        BlocProvider(create: (_) => sl<SearchResultsBloc>()),
      ],
      child: MaterialApp(
        title: 'MyTravaly',
        theme: AppTheme.light(),
        initialRoute: '/',
        onGenerateRoute: _onGenerateRoute,
        onUnknownRoute: (settings) =>
            MaterialPageRoute<void>(builder: (_) => const _NotFoundPage()),
        debugShowCheckedModeBanner: false,
        builder: (context, child) =>
            _ErrorBoundary(child: child ?? const SizedBox.shrink()),
      ),
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute<void>(
          builder: (_) => const _AuthGate(),
          settings: settings,
        );
      case '/home':
        return MaterialPageRoute<void>(
          builder: (_) => const HomePage(),
          settings: settings,
        );
      case '/search':
        final request = _buildSearchRequest(settings.arguments);
        return MaterialPageRoute<void>(
          builder: (_) => SearchResultsPage(initialRequest: request),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const _NotFoundPage(),
          settings: settings,
        );
    }
  }

  SearchRequest _buildSearchRequest(dynamic args) {
    if (args is SearchRequest) {
      return args;
    }

    final raw = args?.toString().trim() ?? '';
    if (raw.isEmpty) {
      return const SearchRequest(
        displayText: '',
        searchType: 'citySearch',
        searchQuery: <String>[],
      );
    }

    return SearchRequest(
      displayText: raw,
      searchType: 'citySearch',
      searchQuery: <String>[raw],
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is AuthAuthenticated) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return const SignInPage();
      },
    );
  }
}

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text(
              'Oops! We couldn\'t find that page.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
              child: const Text('Go home'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBoundary extends StatelessWidget {
  const _ErrorBoundary({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: child,
    );
  }
}
