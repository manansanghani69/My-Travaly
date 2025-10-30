# MyTravaly Flutter App - Codex Agent Task Prompts

---

## 🎯 TASK 1: Google Sign-In/Sign-Up Implementation

### Context
You are building a Flutter hotel booking app using Clean Architecture. This is the authentication screen - the entry point of the application.

### Requirements
- Implement Google Sign-In/Sign-Up using `google_sign_in` and `firebase_auth` packages
- This is **frontend-only** implementation (no backend API integration)
- Store user authentication state using BLoC pattern
- Navigate to Home Page after successful authentication
- Handle error states appropriately

### Prompt for Codex Agent:

```
Create a complete Google Sign-In/Sign-Up feature for a Flutter app using Clean Architecture and BLoC pattern.

ARCHITECTURE REQUIREMENTS:
1. Follow Clean Architecture with these layers:
   - Domain Layer: User entity, AuthRepository interface, SignInWithGoogle and SignOut use cases
   - Data Layer: UserModel, AuthRepositoryImpl, GoogleAuthLocalDataSource
   - Presentation Layer: AuthBloc (with events/states), SignInPage, GoogleSignInButton widget

2. DOMAIN LAYER:
   - Create User entity with: id, email, displayName, photoUrl
   - Create AuthRepository abstract class with signInWithGoogle() and signOut() methods
   - Create SignInWithGoogle use case that returns Either<Failure, User>
   - Create SignOut use case

3. DATA LAYER:
   - Create UserModel extending User entity with fromJson, toJson, and fromGoogleUser methods
   - Create GoogleAuthLocalDataSource with signInWithGoogle() method using google_sign_in package
   - Create AuthRepositoryImpl implementing AuthRepository

4. PRESENTATION LAYER:
   - Create AuthBloc with events: SignInWithGoogleEvent, SignOutEvent
   - Create AuthStates: AuthInitial, AuthLoading, AuthAuthenticated(user), AuthError(message)
   - Create SignInPage with:
     * Beautiful UI with app logo/branding
     * Google Sign-In button
     * Loading indicator during authentication
     * Error handling with SnackBar
     * Auto-navigation to '/home' on success
   - Create GoogleSignInButton widget with Google branding

5. ERROR HANDLING:
   - Handle GoogleSignIn.signIn() cancellation
   - Handle FirebaseAuth errors
   - Display user-friendly error messages

6. DEPENDENCIES TO USE:
   - google_sign_in: ^6.2.1
   - firebase_auth: ^4.16.0
   - flutter_bloc: ^8.1.3
   - equatable: ^2.0.5
   - dartz: ^0.10.1

7. FILE STRUCTURE:
lib/features/auth/
├── data/
│   ├── datasources/google_auth_local_data_source.dart
│   ├── models/user_model.dart
│   └── repositories/auth_repository_impl.dart
├── domain/
│   ├── entities/user.dart
│   ├── repositories/auth_repository.dart
│   └── usecases/
│       ├── sign_in_with_google.dart
│       └── sign_out.dart
└── presentation/
    ├── bloc/
    │   ├── auth_bloc.dart
    │   ├── auth_event.dart
    │   └── auth_state.dart
    ├── pages/sign_in_page.dart
    └── widgets/google_sign_in_button.dart

IMPORTANT:
- Use BlocConsumer for navigation and error display
- Implement proper dispose methods
- Add equatable for state comparison
- Store minimal user data (id, email, name, photo)
- NO backend API calls - purely frontend authentication

Generate complete, production-ready code for all files mentioned above.
```

---

## 🎯 TASK 2: Home Page with Hotel List & Search

### Context
After successful authentication, users land on the Home Page which displays popular hotels and provides a search bar for finding hotels by name, city, state, or country.

### Requirements
- Register device to get visitor token (required for all API calls)
- Display list of popular hotels using `popularStay` API
- Implement search bar with autocomplete suggestions
- Use `searchAutoComplete` API for real-time suggestions
- Navigate to Search Results page when search is submitted
- Handle loading, error, and empty states

### Prompt for Codex Agent:

```
Create a complete Home Page feature with hotel listing and search functionality for a Flutter app using Clean Architecture and BLoC pattern.

API DETAILS:
- Base URL: https://api.mytravaly.com/public/v1/
- Auth Token: 71523fdd8d26f585315b4233e39d9263
- Required Headers: authtoken, visitortoken (from device registration), Content-Type: application/json

CRITICAL API FLOW:
1. First call: Device Registration API to get visitorToken
2. Then use visitorToken for all subsequent API calls
3. Store visitorToken in memory for reuse

ARCHITECTURE REQUIREMENTS:

1. DOMAIN LAYER:
   - Create Hotel entity with:
     * propertyCode, propertyName, propertyStar, propertyImage
     * propertyType, propertyAddress, markedPrice, staticPrice
     * googleReview (optional)
   - Create SearchSuggestion entity with:
     * valueToDisplay, type (city/state/country/property)
     * searchArray (type and query list)
   - Create HotelRepository interface with:
     * registerDevice() -> Future<Either<Failure, String>>
     * getPopularStays(city, state, country) -> Future<Either<Failure, List<Hotel>>>
     * searchAutocomplete(query) -> Future<Either<Failure, List<SearchSuggestion>>>
   - Create use cases: RegisterDevice, GetPopularStays, SearchAutocomplete

2. DATA LAYER:
   - Create HotelModel, PropertyAddressModel, PriceInfoModel, GoogleReviewModel
   - Create SearchSuggestionModel
   - Create HotelRemoteDataSource with:
     * registerDevice() method that calls API with device info
     * getPopularStays() method that calls popularStay API
     * searchAutocomplete() method that calls searchAutoComplete API
     * Store and reuse visitorToken internally
   - Create HotelRepositoryImpl implementing HotelRepository
   - Create ApiConstants class with baseUrl, authToken, and header methods

3. DEVICE REGISTRATION:
   - Use device_info_plus package to get device details
   - Create DeviceInfoHelper to gather:
     * deviceModel, deviceBrand, deviceId
     * deviceName, deviceManufacturer, deviceProduct
     * deviceFingerprint, deviceSerialNumber
   - Call API with action: "deviceRegister"
   - Store returned visitorToken

4. POPULAR STAYS API:
   - Action: "popularStay"
   - Parameters: limit (10), entityType ("Any"), filter (byCity), currency ("INR")
   - Use default location: Jamshedpur, Jharkhand, India

5. SEARCH AUTOCOMPLETE API:
   - Action: "searchAutoComplete"
   - Parameters: inputText, searchType array, limit (10)
   - searchType: ["byCity", "byState", "byCountry", "byPropertyName"]
   - Trigger only when input length >= 3
   - Implement 300ms debounce

6. PRESENTATION LAYER:
   - Create HotelBloc with events:
     * LoadPopularHotelsEvent(city, state, country)
     * SearchHotelsEvent(query)
   - Create HotelStates:
     * HotelInitial, HotelLoading
     * HotelLoaded(hotels), HotelError(message)
   - Create SearchBloc with events:
     * GetAutocompleteSuggestionsEvent(query)
     * ClearSuggestionsEvent
   - Create SearchStates:
     * SearchInitial, SearchLoading
     * SuggestionsLoaded(suggestions), SearchError(message)

7. HOME PAGE UI:
   - AppBar with title "MyTravaly" and user profile icon
   - SearchBarWidget at top with:
     * TextField with hint "Search by hotel, city, state, or country"
     * Search icon and forward arrow button
     * Autocomplete dropdown showing suggestions
     * OnSubmit navigation to SearchResultsPage
   - GridView or ListView of HotelCard widgets showing:
     * Hotel image (use cached_network_image)
     * Hotel name and star rating
     * Location (city, state)
     * Price (show both marked and static price)
     * Google review rating if available
   - Pull-to-refresh functionality
   - Loading shimmer effect while fetching
   - Empty state with illustration
   - Error state with retry button

8. WIDGETS TO CREATE:
   - SearchBarWidget with autocomplete dropdown
   - HotelCard with image, details, and pricing
   - PriceTag widget for displaying prices
   - RatingWidget for star rating display
   - ShimmerHotelCard for loading state

9. ERROR HANDLING:
   - Handle network failures
   - Handle invalid visitorToken (re-register device)
   - Handle empty results
   - Display user-friendly error messages

10. DEPENDENCIES:
   - http: ^1.1.0
   - device_info_plus: ^9.1.1
   - cached_network_image: ^3.3.0
   - shimmer: ^3.0.0
   - connectivity_plus: ^5.0.2

FILE STRUCTURE:
lib/features/hotels/
├── data/
│   ├── datasources/
│   │   ├── hotel_remote_data_source.dart
│   │   └── device_registration_data_source.dart
│   ├── models/
│   │   ├── hotel_model.dart
│   │   ├── search_suggestion_model.dart
│   │   └── property_address_model.dart
│   └── repositories/hotel_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── hotel.dart
│   │   └── search_suggestion.dart
│   ├── repositories/hotel_repository.dart
│   └── usecases/
│       ├── register_device.dart
│       ├── get_popular_stays.dart
│       └── search_autocomplete.dart
└── presentation/
    ├── bloc/
    │   ├── hotel_bloc.dart (events, states)
    │   └── search_bloc.dart (events, states)
    ├── pages/home_page.dart
    └── widgets/
        ├── search_bar_widget.dart
        ├── hotel_card.dart
        ├── price_tag.dart
        └── rating_widget.dart

lib/core/
├── constants/api_constants.dart
├── utils/device_info_helper.dart
└── error/
    ├── exceptions.dart
    └── failures.dart

IMPORTANT NOTES:
- ALWAYS register device FIRST and store visitorToken
- Reuse visitorToken for all API calls
- Implement proper JSON parsing with null safety
- Use try-catch for API calls and JSON parsing
- Show loading states during API calls
- Implement debouncing for autocomplete (300ms)
- Cache hotel images using cached_network_image
- Handle different search types (city, state, country, property)

Generate complete, production-ready code for all files with proper error handling and state management.
```

---

## 🎯 TASK 3: Search Results Page with Pagination

### Context
Users can search for hotels and view results in a paginated list. The page should load initial results and fetch more as the user scrolls down.

### Requirements
- Display search results using `getSearchResultListOfHotels` API
- Implement infinite scroll pagination
- Load 10 results per page
- Show loading indicator at bottom while fetching more results
- Handle empty results and errors
- Support different search types (city, state, country, hotel name)

### Prompt for Codex Agent:

```
Create a complete Search Results Page with pagination for a Flutter app using Clean Architecture and BLoC pattern.

API DETAILS:
- Base URL: https://api.mytravaly.com/public/v1/
- Auth Token: 71523fdd8d26f585315b4233e39d9263
- Required Headers: authtoken, visitortoken, Content-Type: application/json
- Endpoint: getSearchResultListOfHotels

SEARCH RESULTS API:
- Action: "getSearchResultListOfHotels"
- Parameters:
  * checkIn: "YYYY-MM-DD" (default: tomorrow)
  * checkOut: "YYYY-MM-DD" (default: day after tomorrow)
  * rooms: 1
  * adults: 2
  * children: 0
  * searchType: "citySearch" | "stateSearch" | "countrySearch" | "hotelIdSearch"
  * searchQuery: [array of search values]
  * accommodation: ["all", "hotel"]
  * arrayOfExcludedSearchType: ["street"]
  * highPrice: "3000000"
  * lowPrice: "0"
  * limit: 10 (per page)
  * preloaderList: [array of excluded hotel codes]
  * currency: "INR"
  * rid: page number (0, 1, 2, ...)

PAGINATION STRATEGY:
- Initial load: rid = 0, limit = 10
- Load more: increment rid, keep limit = 10
- Stop loading when results < limit (end of list)
- Track excluded hotels to avoid duplicates

ARCHITECTURE REQUIREMENTS:

1. DOMAIN LAYER:
   - Create SearchParams entity with all search criteria
   - Extend Hotel entity if needed (already created in Task 2)
   - Update HotelRepository interface:
     * getSearchResults(SearchParams) -> Future<Either<Failure, SearchResultsResponse>>
   - Create SearchResultsResponse entity:
     * hotels: List<Hotel>
     * excludedHotels: List<String>
     * hasMore: bool
   - Create GetSearchResults use case

2. DATA LAYER:
   - Create SearchParamsModel with toJson method
   - Create SearchResultsModel with fromJson method
   - Update HotelRemoteDataSource:
     * Add getSearchResults(SearchParams) method
     * Use stored visitorToken from device registration
   - Update HotelRepositoryImpl with getSearchResults implementation

3. PRESENTATION LAYER:
   - Create SearchResultsBloc with events:
     * PerformSearchEvent(query, searchType, searchParams)
     * LoadMoreResultsEvent
     * RefreshSearchEvent
   - Create SearchResultsStates:
     * SearchResultsInitial
     * SearchResultsLoading
     * SearchResultsLoaded(hotels, hasMore, currentPage, excludedHotels)
     * SearchResultsLoadingMore(currentHotels)
     * SearchResultsError(message)
     * SearchResultsEmpty
   - Track state:
     * Current page (rid)
     * List of excluded hotel codes
     * Has more results flag

4. SEARCH RESULTS PAGE UI:
   - AppBar with:
     * Back button
     * Search query display
     * Filter button (optional)
   - SearchBarWidget (reuse from Task 2) for new searches
   - ListView.builder with:
     * HotelCard for each result (reuse from Task 2)
     * ScrollController for pagination detection
     * Bottom loading indicator during pagination
     * Pull-to-refresh functionality
   - Loading state: Show shimmer cards
   - Empty state: "No hotels found" with illustration
   - Error state: Error message with retry button

5. PAGINATION IMPLEMENTATION:
   - Use ScrollController to detect scroll position
   - Trigger LoadMoreResultsEvent when user scrolls to 90% of list
   - Show CircularProgressIndicator at bottom during load
   - Prevent multiple simultaneous load requests
   - Append new results to existing list
   - Update excluded hotels list
   - Stop pagination when results < limit

6. SCROLL CONTROLLER LOGIC:
```dart
void _onScroll() {
  if (_isBottom && state is SearchResultsLoaded && state.hasMore) {
    context.read<SearchResultsBloc>().add(LoadMoreResultsEvent());
  }
}

bool get _isBottom {
  if (!_scrollController.hasClients) return false;
  final maxScroll = _scrollController.position.maxScrollExtent;
  final currentScroll = _scrollController.offset;
  return currentScroll >= (maxScroll * 0.9);
}
```

7. SEARCH TYPE DETERMINATION:
   - Parse search query from autocomplete selection
   - Determine searchType based on selected suggestion:
     * City search -> "citySearch" with [city, state, country]
     * State search -> "stateSearch" with [state, country]
     * Country search -> "countrySearch" with [country]
     * Hotel name -> "hotelIdSearch" with [propertyCode]

8. DATE HANDLING:
   - Default checkIn: DateTime.now().add(Duration(days: 1))
   - Default checkOut: DateTime.now().add(Duration(days: 2))
   - Format: "yyyy-MM-dd"
   - Allow user to change dates (optional date picker)

9. HOTEL CARD ENHANCEMENTS:
   - Display all hotel details:
     * Property image (cached)
     * Property name and star rating
     * Property type badge (Hotel, Resort, etc.)
     * Address (street, city, state)
     * Price comparison (marked vs static price)
     * Google review rating
     * Available deals section
     * Amenities icons (WiFi, Parking, etc.)
   - OnTap: Navigate to hotel details (optional)

10. ERROR HANDLING:
   - Network timeout
   - Invalid search query
   - No results found
   - API errors
   - Pagination errors
   - Display appropriate messages and retry options

11. OPTIMIZATION:
   - Cache images with cached_network_image
   - Debounce scroll events (100ms)
   - Cancel previous API calls when new search is initiated
   - Dispose scroll controller properly
   - Use ListView.builder for performance

FILE STRUCTURE:
lib/features/hotels/
├── domain/
│   ├── entities/
│   │   ├── search_params.dart
│   │   └── search_results_response.dart
│   └── usecases/
│       └── get_search_results.dart
├── data/
│   └── models/
│       ├── search_params_model.dart
│       └── search_results_model.dart
└── presentation/
    ├── bloc/
    │   ├── search_results_bloc.dart
    │   ├── search_results_event.dart
    │   └── search_results_state.dart
    ├── pages/
    │   └── search_results_page.dart
    └── widgets/
        ├── hotel_card_detailed.dart
        ├── pagination_indicator.dart
        └── empty_results_widget.dart

IMPORTANT NOTES:
- Use ScrollController for pagination detection
- Track excluded hotels to avoid duplicates
- Increment rid (page number) for each pagination request
- Stop pagination when results.length < limit
- Show loading indicator at bottom, not full screen
- Maintain scroll position during pagination
- Handle rapid scroll events with debouncing
- Reuse visitorToken from device registration
- Parse search type correctly from autocomplete selection
- Format dates properly (YYYY-MM-DD)

PAGINATION STATE FLOW:
1. Initial search: SearchResultsLoading -> SearchResultsLoaded(page=0)
2. Scroll to bottom: SearchResultsLoadingMore(keep current list visible)
3. More results loaded: SearchResultsLoaded(page=1, append to list)
4. No more results: SearchResultsLoaded(hasMore=false, stop pagination)
5. Error during pagination: Show SnackBar, keep current results

Generate complete, production-ready code with proper pagination logic, error handling, and optimized performance.
```

---

## 🎯 BONUS TASK: Dependency Injection & App Setup

### Prompt for Codex Agent:

```
Set up complete project structure with dependency injection, routing, and initialization for the MyTravaly Flutter app.

REQUIREMENTS:

1. CREATE PROJECT STRUCTURE:
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
├── features/ (already created in Tasks 1-3)
├── injection_container.dart
├── app.dart
└── main.dart

2. DEPENDENCY INJECTION (injection_container.dart):
   - Use get_it package
   - Register all BLoCs as factories
   - Register all use cases as lazy singletons
   - Register all repositories as lazy singletons
   - Register all data sources as lazy singletons
   - Register external dependencies (GoogleSignIn, http.Client)
   - Create init() function to set up all dependencies

3. APP WIDGET (app.dart):
   - Create MaterialApp with MultiBlocProvider
   - Provide all BLoCs: AuthBloc, HotelBloc, SearchBloc, SearchResultsBloc
   - Set up routing:
     * '/': SignInPage (check auth state, redirect if authenticated)
     * '/home': HomePage
     * '/search': SearchResultsPage
   - Set up theme with primary colors
   - Handle initial route based on authentication state

4. MAIN.DART:
   - Initialize Firebase
   - Call dependency injection init()
   - Ensure Flutter bindings initialized
   - Run app with error handling

5. NETWORK INFO (core/network/network_info.dart):
   - Use connectivity_plus package
   - Create NetworkInfo interface with isConnected getter
   - Implement NetworkInfoImpl
   - Check internet connectivity before API calls

6. EXCEPTIONS (core/error/exceptions.dart):
   - ServerException
   - CacheException
   - NetworkException
   - AuthException

7. FAILURES (core/error/failures.dart):
   - Abstract Failure class
   - ServerFailure
   - CacheFailure
   - NetworkFailure
   - AuthFailure

8. USECASE BASE (core/usecases/usecase.dart):
```dart
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
```

9. DEVICE INFO HELPER (core/utils/device_info_helper.dart):
   - Use device_info_plus package
   - Create static method to get device information
   - Return Map with all device details for API registration

10. ROUTING:
   - Use named routes
   - Pass arguments using RouteSettings
   - Handle unknown routes with 404 page

11. THEME:
   - Primary color: Blue (#2196F3)
   - Accent color: Orange (#FF9800)
   - App bar style, button styles, input decoration theme
   - Light theme configuration

12. ERROR WIDGET:
   - Global error widget override for better error messages
   - Development vs production error displays

COMPLETE PUBSPEC.YAML:
```yaml
name: mytravaly
description: A hotel booking Flutter application
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

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
  
  # Utils
  intl: ^0.18.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  mockito: ^5.4.4
  bloc_test: ^9.1.5

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
```

INITIALIZATION FLOW:
1. main.dart: Initialize Firebase
2. main.dart: Call injection_container.init()
3. main.dart: Run MyTravaly app
4. app.dart: Check authentication state
5. app.dart: Navigate to SignInPage or HomePage
6. Each page: Access BLoCs from context
7. BLoCs: Use injected use cases
8. Use cases: Use injected repositories
9. Repositories: Use injected data sources
10. Data sources: Make API calls with stored visitorToken

IMPORTANT NOTES:
- Register device on first app launch and store visitorToken
- Persist authentication state using shared_preferences (optional)
- Handle Firebase initialization errors gracefully
- Dispose BLoCs properly when navigating
- Use const constructors where possible for performance
- Implement proper error boundaries
- Add splash screen for initialization

Generate complete, production-ready code for all setup files with proper dependency injection and initialization flow.
```

---

## 📋 EXECUTION ORDER FOR CODEX AGENT

Execute tasks in this order:

1. **TASK 1**: Google Sign-In/Sign-Up (Authentication foundation)
2. **BONUS TASK**: Dependency Injection & App Setup (Project structure)
3. **TASK 2**: Home Page with Hotel List & Search (Core functionality)
4. **TASK 3**: Search Results with Pagination (Advanced feature)

---

## ✅ VALIDATION CHECKLIST

After completing all tasks, verify:

- [ ] Google Sign-In works and navigates to Home
- [ ] Device registration returns and stores visitorToken
- [ ] Home page displays popular hotels from API
- [ ] Search autocomplete shows suggestions
- [ ] Search results page displays hotels
- [ ] Pagination loads more results on scroll
- [ ] Error handling works for all scenarios
- [ ] Loading states display correctly
- [ ] All BLoCs are properly injected
- [ ] Navigation works between all pages
- [ ] Images are cached and load smoothly
- [ ] App follows Clean Architecture principles
- [ ] No memory leaks (proper dispose methods)
- [ ] Code is well-documented with comments

---

## 🚨 IMPORTANT REMINDERS FOR CODEX AGENT

1. **Always call Device Registration first** before any hotel API calls
2. **Store and reuse visitorToken** across all API requests
3. **Follow Clean Architecture strictly** - no business logic in UI
4. **Use BLoC pattern consistently** - no setState in complex screens
5. **Handle null safety properly** - use proper null checks
6. **Implement proper error handling** - try-catch blocks everywhere
7. **Add loading states** for better UX
8. **Dispose resources** - controllers, scroll listeners, streams
9. **Use const constructors** where possible for performance
10. **Comment complex logic** for maintainability

---

## 🎨 UI/UX GUIDELINES

- Use Material Design 3 components
- Implement smooth animations and transitions
- Show shimmer loading effects for images
- Use pull-to-refresh on lists
- Display empty states with illustrations
- Show error states with retry buttons
- Use proper spacing and padding (8px grid)
- Implement proper typography hierarchy
- Use semantic colors (error, success, info)
- Add haptic feedback on important actions

---

## 🧪 TESTING TIPS

- Test with airplane mode (network failure)
- Test with slow network (loading states)
- Test pagination with rapid scrolling
- Test search with empty results
- Test authentication cancellation
- Test with different screen sizes
- Test with long hotel names/addresses
- Test date edge cases
- Test price formatting with different currencies
- Test API error responses (401, 404, 500)