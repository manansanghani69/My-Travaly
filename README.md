# My-Travaly

MyTravaly is a Flutter hotel booking experience built with Clean Architecture, BLoC state management, and Google Sign-In support.

## Requirements

- Flutter 3.24.x
- Dart 3.5.x
- Firebase project configured for Google Sign-In

## Getting Started

1. Fetch dependencies:

   ```bash
   flutter pub get
   ```

2. Configure your Firebase project and download the platform-specific config files (`google-services.json`, `GoogleService-Info.plist`, etc.). Place them in the provided locations under `android/` and `ios/` respectively.

3. Run the app:

   ```bash
   flutter run
   ```

## Architecture Highlights

- Clean Architecture separation (`core`, `features`, `domain`, `data`, `presentation`)
- Dependency injection via `get_it` in `lib/injection_container.dart`
- BLoC for Google Sign-In, hotel listings, and paginated search
- Remote APIs consumed through structured data sources and repositories

## Key Features

- Google Sign-In (frontend flow)
- Device registration and visitor token handling
- Home page with popular hotel stays and autocomplete search
- Search results with infinite scrolling pagination
