# chalosaath

A new Flutter project.

## 🚀 Full Codebase Refactor (2024)

This project has undergone a comprehensive refactor to improve maintainability, scalability, and code quality. The refactor includes:

### ✨ Key Improvements
- **Consistent File Naming:** All files now use `snake_case`.
- **Centralized Constants & Theme:** All app-wide constants and theming are in `lib/core/constants/` and `lib/core/theme/`.
- **Robust Utilities:** Common validation, formatting, and UI helpers are in `lib/core/utils/app_utils.dart`.
- **Feature-based Structure:** Each feature (auth, address, home, onboarding, etc.) is isolated in its own folder with clear separation of data, domain, and presentation layers.
- **Modern BLoC Pattern:** All BLoC, event, and state classes follow best practices for event-driven architecture.
- **Improved Routing:** Centralized route constants and a robust route generator with error handling.
- **Removed Duplicates/Unused Files:** The codebase is clean and free of legacy or duplicate files.
- **Updated Imports:** All imports are relative and reflect the new structure.
- **Enhanced Error Handling:** Consistent error and success messaging throughout the app.

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
    profile/           # Profile screen
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
- Use BLoC for all business logic and state management
- Keep UI code in `presentation/`, business logic in `domain/`, and data sources in `data/`
- Use dependency injection via `service_locator.dart`
- Validate all user input using utilities
- Use centralized error and success messages
- Prefer relative imports within `lib/`

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

---

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
