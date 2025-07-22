# ChaloSaath

A modern Flutter ride-sharing app with robust state management, Firebase integration, and a polished, user-friendly UI.

## 🚀 Major Refactor & Feature Update (2024)

This project has recently undergone a comprehensive refactor and feature expansion to improve maintainability, scalability, and user experience.

### ✨ Key Features & Improvements
- **Modern Dashboard UI:** Redesigned home screen with a custom AppBar, tabbed search/offer row, "Where are you going?" card, upcoming rides section, and a bottom navigation bar.
- **Reusable Widgets:** CustomTabBar and CustomBottomNavBar for consistent navigation and flexible tab usage across screens.
- **Profile Redesign:** New profile screen with a custom AppBar, profile card, contact/vehicle info, and settings (including dark mode toggle).
- **Dark Mode with BLoC:** Theme switching is managed by a full BLoC (not Cubit), with persistent user preference using AppPreference.
- **Offer a Ride:** Dedicated screen for offering rides, using BLoC for state management, address autocomplete (reusing address feature), and saving ride data to Firebase with a rideTimestamp for querying.
- **Upcoming Rides Query:** Home page shows only rides in the next 20 minutes (excluding current user's rides), with real-time Firebase queries.
- **Robust State Management:** All business logic and state management use the full BLoC pattern, following best practices for event-driven architecture.
- **Improved UX:** Modal loaders, form reset fixes, and navigation/theming consistency across screens.
- **Clean Codebase:** Removed deprecated, duplicate, and unused files. All Cubit usage replaced with BLoC.

### 📁 Project Structure
```
lib/
  core/
    constants/         # App-wide constants
    routes/            # Route constants & generator
    storage/           # Shared preferences, keys
    theme/             # App colors, theme
    utils/             # Common utilities
  features/
    address/           # Address search, form, BLoC, repo
    authorization/     # Auth screens, BLoC, repo, models
    data_providers/    # Firebase, social sign-in services
    home/              # Home screen, BLoC
    loader/            # Custom loader widget
    main/              # Main navigation screen
    onboarding/        # Onboarding screens, BLoC
    offer/             # Offer a Ride feature (BLoC, UI, Firebase)
    profile/           # Profile screen (redesigned)
    splash/            # Splash screen
  main.dart            # App entry point
  services/
    service_locator.dart # Dependency injection
```

### 🧑‍💻 Coding Conventions
- **snake_case** for all files and folders
- **PascalCase** for classes, enums, typedefs
- **camelCase** for variables, functions, parameters
- **Constants** in `AppConstants` (lib/core/constants/app_constants.dart)
- **Theme** in `AppTheme` (lib/core/theme/app_theme.dart)
- **Utilities** in `AppUtils` (lib/core/utils/app_utils.dart)
- **Routes** in `RouteConstants` and `RouteGenerator` (lib/core/routes/)

### 🏗️ Best Practices
- Use **BLoC** for all business logic and state management (no Cubit)
- Keep UI code in `presentation/`, business logic in `domain/`, and data sources in `data/`
- Use dependency injection via `service_locator.dart`
- Validate all user input using utilities
- Use centralized error and success messages
- Prefer relative imports within `lib/`
- Persist user preferences (e.g., dark mode) using AppPreference

### 📝 How to Add a New Feature
1. Create a new folder in `lib/features/`.
2. Add `data/`, `domain/`, and `presentation/` subfolders as needed.
3. Define events, states, and BLoC for the feature.
4. Add UI screens in `presentation/`.
5. Register routes in `route_constants.dart` and `route_generator.dart`.
6. Use centralized constants, theme, and utilities.

### 🛠️ Dependencies
- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [get_it](https://pub.dev/packages/get_it)
- [firebase_core](https://pub.dev/packages/firebase_core)
- [firebase_auth](https://pub.dev/packages/firebase_auth)
- [cloud_firestore](https://pub.dev/packages/cloud_firestore)
- [shared_preferences](https://pub.dev/packages/shared_preferences)
- [google_sign_in](https://pub.dev/packages/google_sign_in)
- [google_fonts](https://pub.dev/packages/google_fonts)
- [uuid](https://pub.dev/packages/uuid)
- [equatable](https://pub.dev/packages/equatable)
- [flutter_typeahead](https://pub.dev/packages/flutter_typeahead)

---

## Getting Started

1. Clone the repo and run `flutter pub get`.
2. Set up Firebase for your platforms (Android/iOS/Web) and add the required config files.
3. Run the app with `flutter run`.

For more details, see the [Flutter documentation](https://docs.flutter.dev/).
