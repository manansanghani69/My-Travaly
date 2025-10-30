# MyTravaly Flutter App - Agent Implementation Guide

## Project Overview

This is a Flutter hotel booking application implementing Clean Architecture with three main screens:
1. Google Sign-In/Sign-Up (Frontend only)
2. Home Page with Hotel List
3. Search Results with Pagination

---

## Architecture: Clean Architecture

```
lib/
├── core/
│   ├── constants/
│   │   └── api_constants.dart
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   └── network_info.dart
│   ├── usecases/
│   │   └── usecase.dart
│   └── utils/
│       └── device_info_helper.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── google_auth_local_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── sign_in_with_google.dart
│   │   │       └── sign_out.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       ├── pages/
│   │       │   └── sign_in_page.dart
│   │       └── widgets/
│   │           └── google_sign_in_button.dart
│   ├── hotels/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── hotel_remote_data_source.dart
│   │   │   │   └── device_registration_data_source.dart
│   │   │   ├── models/
│   │   │   │   ├── hotel_model.dart
│   │   │   │   ├── search_autocomplete_model.dart
│   │   │   │   ├── property_model.dart
│   │   │   │   └── visitor_token_model.dart
│   │   │   └── repositories/
│   │   │       └── hotel_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── hotel.dart
│   │   │   │   ├── property.dart
│   │   │   │   └── search_suggestion.dart
│   │   │   ├── repositories/
│   │   │   │   └── hotel_repository.dart
│   │   │   └── usecases/
│   │   │       ├── register_device.dart
│   │   │       ├── get_popular_stays.dart
│   │   │       ├── search_autocomplete.dart
│   │   │       └── get_search_results.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── hotel_bloc.dart
│   │       │   ├── hotel_event.dart
│   │       │   ├── hotel_state.dart
│   │       │   ├── search_bloc.dart
│   │       │   ├── search_event.dart
│   │       │   └── search_state.dart
│   │       ├── pages/
│   │       │   ├── home_page.dart
│   │       │   └── search_results_page.dart
│   │       └── widgets/
│   │           ├── hotel_card.dart
│   │           ├── search_bar_widget.dart
│   │           └── pagination_widget.dart
└── injection_container.dart
```

---

## Task Breakdown

### Task 1: Google Sign-In/Sign-Up (Frontend Only)

#### Requirements:
- Implement Google Sign-In using `google_sign_in` package
- No backend API integration required
- Store user info locally (optional)
- Navigate to Home Page after successful sign-in

#### Implementation Steps:

1. **Add Dependencies** (pubspec.yaml):
```yaml
dependencies:
  google_sign_in: ^6.2.1
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  dartz: ^0.10.1
```

2. **Entity** (domain/entities/user.dart):
```dart
class User extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;

  const User({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [id, email, displayName, photoUrl];
}
```

3. **Use Case** (domain/usecases/sign_in_with_google.dart):
```dart
class SignInWithGoogle {
  final AuthRepository repository;

  SignInWithGoogle(this.repository);

  Future<Either<Failure, User>> call() async {
    return await repository.signInWithGoogle();
  }
}
```

4. **BLoC Events & States**:
```dart
// auth_event.dart
abstract class AuthEvent extends Equatable {}

class SignInWithGoogleEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class SignOutEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

// auth_state.dart
abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
  
  @override
  List<Object> get props => [user];
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
  
  @override
  List<Object> get props => [message];
}
```

5. **Sign-In Page UI**:
```dart
class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Center(
            child: GoogleSignInButton(
              onPressed: () {
                context.read<AuthBloc>().add(SignInWithGoogleEvent());
              },
            ),
          );
        },
      ),
    );
  }
}
```

---

### Task 2: Home Page with Hotel List

#### Requirements:
- Display popular hotels using `popularStay` API
- Implement search bar with autocomplete
- Use `searchAutoComplete` API for suggestions
- Navigate to Search Results page

#### Implementation Steps:

1. **Register Device First**:
```dart
// domain/usecases/register_device.dart
class RegisterDevice {
  final HotelRepository repository;

  RegisterDevice(this.repository);

  Future<Either<Failure, String>> call() async {
    return await repository.registerDevice();
  }
}
```

2. **Hotel Entity** (domain/entities/hotel.dart):
```dart
class Hotel extends Equatable {
  final String propertyCode;
  final String propertyName;
  final int propertyStar;
  final String propertyImage;
  final String propertyType;
  final PropertyAddress address;
  final PriceInfo markedPrice;
  final PriceInfo staticPrice;
  final GoogleReview? googleReview;

  const Hotel({
    required this.propertyCode,
    required this.propertyName,
    required this.propertyStar,
    required this.propertyImage,
    required this.propertyType,
    required this.address,
    required this.markedPrice,
    required this.staticPrice,
    this.googleReview,
  });

  @override
  List<Object?> get props => [
    propertyCode,
    propertyName,
    propertyStar,
    propertyImage,
    propertyType,
    address,
    markedPrice,
    staticPrice,
    googleReview,
  ];
}
```

3. **BLoC for Hotels**:
```dart
// hotel_event.dart
abstract class HotelEvent extends Equatable {}

class LoadPopularHotelsEvent extends HotelEvent {
  final String city;
  final String state;
  final String country;

  LoadPopularHotelsEvent({
    required this.city,
    required this.state,
    required this.country,
  });

  @override
  List<Object> get props => [city, state, country];
}

class SearchHotelsEvent extends HotelEvent {
  final String query;

  SearchHotelsEvent(this.query);

  @override
  List<Object> get props => [query];
}

// hotel_state.dart
abstract class HotelState extends Equatable {}

class HotelInitial extends HotelState {
  @override
  List<Object> get props => [];
}

class HotelLoading extends HotelState {
  @override
  List<Object> get props => [];
}

class HotelLoaded extends HotelState {
  final List<Hotel> hotels;

  HotelLoaded(this.hotels);

  @override
  List<Object> get props => [hotels];
}

class HotelError extends HotelState {
  final String message;

  HotelError(this.message);

  @override
  List<Object> get props => [message];
}
```

4. **Home Page UI**:
```dart
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Register device and load hotels
    context.read<HotelBloc>().add(
      LoadPopularHotelsEvent(
        city: 'Jamshedpur',
        state: 'Jharkhand',
        country: 'India',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyTravaly'),
      ),
      body: Column(
        children: [
          SearchBarWidget(
            onSearch: (query) {
              Navigator.pushNamed(
                context,
                '/search',
                arguments: query,
              );
            },
          ),
          Expanded(
            child: BlocBuilder<HotelBloc, HotelState>(
              builder: (context, state) {
                if (state is HotelLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is HotelLoaded) {
                  return ListView.builder(
                    itemCount: state.hotels.length,
                    itemBuilder: (context, index) {
                      return HotelCard(hotel: state.hotels[index]);
                    },
                  );
                }
                if (state is HotelError) {
                  return Center(child: Text(state.message));
                }
                return Center(child: Text('No hotels found'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

5. **Search Bar Widget with Autocomplete**:
```dart
class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch;

  const SearchBarWidget({required this.onSearch});

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Search by hotel, city, state, or country',
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                widget.onSearch(_controller.text);
              }
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (value) {
          // Trigger autocomplete
          if (value.length >= 3) {
            context.read<SearchBloc>().add(
              GetAutocompleteSuggestionsEvent(value),
            );
          }
        },
        onSubmitted: widget.onSearch,
      ),
    );
  }
}
```

---

### Task 3: Search Results with Pagination

#### Requirements:
- Display search results from `getSearchResultListOfHotels` API
- Implement pagination (load more on scroll)
- Show loading indicator while fetching

#### Implementation Steps:

1. **Search Use Case**:
```dart
class GetSearchResults {
  final HotelRepository repository;

  GetSearchResults(this.repository);

  Future<Either<Failure, List<Hotel>>> call(SearchParams params) async {
    return await repository.getSearchResults(params);
  }
}

class SearchParams {
  final String checkIn;
  final String checkOut;
  final int rooms;
  final int adults;
  final int children;
  final String searchType;
  final List<String> searchQuery;
  final int limit;
  final int offset;

  SearchParams({
    required this.checkIn,
    required this.checkOut,
    required this.rooms,
    required this.adults,
    required this.children,
    required this.searchType,
    required this.searchQuery,
    this.limit = 10,
    this.offset = 0,
  });
}
```

2. **Search BLoC with Pagination**:
```dart
// search_event.dart
abstract class SearchEvent extends Equatable {}

class PerformSearchEvent extends SearchEvent {
  final String query;
  final String searchType;

  PerformSearchEvent(this.query, this.searchType);

  @override
  List<Object> get props => [query, searchType];
}

class LoadMoreResultsEvent extends SearchEvent {
  @override
  List<Object> get props => [];
}

// search_state.dart
abstract class SearchState extends Equatable {}

class SearchInitial extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchLoading extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchLoaded extends SearchState {
  final List<Hotel> hotels;
  final bool hasMore;
  final int currentPage;

  SearchLoaded({
    required this.hotels,
    required this.hasMore,
    required this.currentPage,
  });

  @override
  List<Object> get props => [hotels, hasMore, currentPage];
}

class SearchLoadingMore extends SearchState {
  final List<Hotel> currentHotels;

  SearchLoadingMore(this.currentHotels);

  @override
  List<Object> get props => [currentHotels];
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);

  @override
  List<Object> get props => [message];
}
```

3. **Search Results Page with Pagination**:
```dart
class SearchResultsPage extends StatefulWidget {
  final String searchQuery;

  const SearchResultsPage({required this.searchQuery});

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initial search
    context.read<SearchBloc>().add(
      PerformSearchEvent(widget.searchQuery, 'citySearch'),
    );

    // Pagination listener
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<SearchBloc>().add(LoadMoreResultsEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is SearchLoaded) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.hotels.length + (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.hotels.length) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return HotelCard(hotel: state.hotels[index]);
              },
            );
          }

          if (state is SearchLoadingMore) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.currentHotels.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.currentHotels.length) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return HotelCard(hotel: state.currentHotels[index]);
              },
            );
          }

          if (state is SearchError) {
            return Center(child: Text(state.message));
          }

          return Center(child: Text('No results found'));
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
```

---

## API Integration

### API Constants:
```dart
class ApiConstants {
  static const String baseUrl = 'https://api.mytravaly.com/public/v1/';
  static const String authToken = '71523fdd8d26f585315b4233e39d9263';
  
  // Headers
  static Map<String, String> getHeaders({String? visitorToken}) {
    final headers = {
      'authtoken': authToken,
      'Content-Type': 'application/json',
    };
    
    if (visitorToken != null) {
      headers['visitortoken'] = visitorToken;
    }
    
    return headers;
  }
}
```

### Remote Data Source:
```dart
abstract class HotelRemoteDataSource {
  Future<String> registerDevice();
  Future<List<HotelModel>> getPopularStays(String city, String state, String country);
  Future<List<SearchSuggestionModel>> searchAutocomplete(String query);
  Future<List<HotelModel>> getSearchResults(SearchParams params);
}

class HotelRemoteDataSourceImpl implements HotelRemoteDataSource {
  final http.Client client;
  String? _visitorToken;

  HotelRemoteDataSourceImpl({required this.client});

  @override
  Future<String> registerDevice() async {
    final deviceInfo = await DeviceInfoHelper.getDeviceInfo();
    
    final response = await client.post(
      Uri.parse(ApiConstants.baseUrl),
      headers: ApiConstants.getHeaders(),
      body: json.encode({
        'action': 'deviceRegister',
        'deviceRegister': deviceInfo,
      }),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      _visitorToken = data['data']['visitorToken'];
      return _visitorToken!;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<HotelModel>> getPopularStays(
    String city,
    String state,
    String country,
  ) async {
    if (_visitorToken == null) {
      await registerDevice();
    }

    final response = await client.post(
      Uri.parse(ApiConstants.baseUrl),
      headers: ApiConstants.getHeaders(visitorToken: _visitorToken),
      body: json.encode({
        'action': 'popularStay',
        'popularStay': {
          'limit': 10,
          'entityType': 'Any',
          'filter': {
            'searchType': 'byCity',
            'searchTypeInfo': {
              'country': country,
              'state': state,
              'city': city,
            },
          },
          'currency': 'INR',
        },
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> hotels = data['data'];
      return hotels.map((json) => HotelModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  // Similar implementations for other methods...
}
```

---

## Dependency Injection

```dart
// injection_container.dart
final sl = GetIt.instance;

Future<void> init() async {
  // BLoCs
  sl.registerFactory(() => AuthBloc(signInWithGoogle: sl(), signOut: sl()));
  sl.registerFactory(() => HotelBloc(
    getPopularStays: sl(),
    registerDevice: sl(),
  ));
  sl.registerFactory(() => SearchBloc(
    getSearchResults: sl(),
    searchAutocomplete: sl(),
  ));

  // Use cases
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => RegisterDevice(sl()));
  sl.registerLazySingleton(() => GetPopularStays(sl()));
  sl.registerLazySingleton(() => SearchAutocomplete(sl()));
  sl.registerLazySingleton(() => GetSearchResults(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<HotelRepository>(
    () => HotelRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data sources
  sl.registerLazySingleton<GoogleAuthLocalDataSource>(
    () => GoogleAuthLocalDataSourceImpl(googleSignIn: sl()),
  );
  sl.registerLazySingleton<HotelRemoteDataSource>(
    () => HotelRemoteDataSourceImpl(client: sl()),
  );

  // External
  sl.registerLazySingleton(() => GoogleSignIn());
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
}
```

---

## Key Packages Required

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  
  # Functional Programming
  dartz: ^0.10.1
  
  # Dependency Injection
  get_it: ^7.6.4
  
  # Authentication
  google_sign_in: ^6.2.1
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  
  # Network
  http: ^1.1.0
  connectivity_plus: ^5.0.2
  
  # Device Info
  device_info_plus: ^9.1.1
  
  # UI
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
```

---

## Testing Checklist

- [ ] Google Sign-In flow works correctly
- [ ] Device registration returns visitor token
- [ ] Popular hotels load on home page
- [ ] Search autocomplete shows suggestions
- [ ] Search results display correctly
- [ ] Pagination loads more results on scroll
- [ ] Error handling shows appropriate messages
- [ ] Loading states display correctly
- [ ] Navigation between pages works
- [ ] API responses are properly parsed

---

## Notes for AI Agent

1. **Always register device first** before making any hotel-related API calls
2. **Store visitor token** securely and reuse it for all subsequent requests
3. **Implement proper error handling** for network failures
4. **Use BLoC pattern** consistently across all features
5. **Follow Clean Architecture** principles strictly
6. **Implement pagination** using scroll controller
7. **Cache visitor token** to avoid repeated device registration
8. **Use debouncing** for search autocomplete (300-500ms delay)
9. **Handle edge cases** like empty search results, no internet connection
10. **Implement proper loading states** for better UX