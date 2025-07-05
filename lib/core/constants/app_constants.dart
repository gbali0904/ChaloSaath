class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // App Information
  static const String appName = 'Chalo Saath';
  static const String appTagline = 'Your trusted carpooling companion';
  static const String appVersion = '1.0.0';

  // Asset Paths
  static const String assetsPath = 'assets/';
  static const String loginBackgroundImage = 'assets/login_bac.png';
  static const String logoImage = 'assets/logo.png';
  static const String splashImage = 'assets/splash.png';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String ridesCollection = 'rides';
  static const String addressesCollection = 'addresses';

  // User Roles
  static const String roleDriver = 'driver';
  static const String rolePassenger = 'passenger';

  // Validation Messages
  static const String emailRequired = 'Email is required';
  static const String passwordRequired = 'Password is required';
  static const String nameRequired = 'Full name is required';
  static const String phoneRequired = 'Phone number is required';
  static const String uidRequired = 'User ID is required';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String invalidPhone = 'Please enter a valid phone number';
  static const String passwordTooShort = 'Password must be at least 6 characters';

  // Error Messages
  static const String registrationFailed = 'Registration failed';
  static const String loginFailed = 'Login failed';
  static const String googleSignInFailed = 'Google sign-in failed';
  static const String networkError = 'Network error. Please check your connection';
  static const String unknownError = 'An unknown error occurred';
  static const String userNotFound = 'User not found';
  static const String saveDataFailed = 'Failed to save user data';

  // Success Messages
  static const String registrationSuccess = 'Registration successful';
  static const String loginSuccess = 'Login successful';
  static const String logoutSuccess = 'Logout successful';
  static const String profileUpdated = 'Profile updated successfully';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultSpacing = 20.0;
  static const double defaultBorderRadius = 10.0;
  static const double buttonHeight = 48.0;
  static const double iconSize = 24.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // API Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String userDataKey = 'user_data';
  static const String googleDataKey = 'google_data';
  static const String isLoginKey = 'is_login';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';

  // Default Values
  static const String defaultCountryCode = '+91';
  static const String defaultLanguage = 'en';
  static const String defaultTheme = 'light';

  // Validation Patterns
  static final RegExp emailPattern = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );
  static final RegExp phonePattern = RegExp(r'^[0-9]{10}$');
  static final RegExp namePattern = RegExp(r'^[a-zA-Z\s]+$');

  // Limits
  static const int maxNameLength = 50;
  static const int minPasswordLength = 6;
  static const int maxPhoneLength = 15;
  static const int maxAddressLength = 200;
} 