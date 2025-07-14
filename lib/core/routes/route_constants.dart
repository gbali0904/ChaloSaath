class RouteConstants {
  // Private constructor to prevent instantiation
  RouteConstants._();

  // Main routes
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String auth = '/auth';
  static const String home = '/home';
  static const String main = '/main';
  static const String profile = '/profile';
  static const String phoneVerification = '/phoneVerification';
  static const String profilesetup = '/profile-setup';
  static const String address = '/address';
  static const String addressSearch = '/address/search';
  static const String addressForm = '/address/form';

  // Feature routes
  static const String rideHistory = '/ride/history';
  static const String rideDetails = '/ride/details';
  static const String bookRide = '/ride/book';
  static const String offerRide = '/ride/offer';
  static const String rideConfirmation = '/ride/confirmation';
  static const String rideTracking = '/ride/tracking';
  static const String rideRating = '/ride/rating';

  // Settings routes
  static const String settings = '/settings';
  static const String editProfile = '/settings/profile';
  static const String changePassword = '/settings/password';
  static const String notifications = '/settings/notifications';
  static const String privacy = '/settings/privacy';
  static const String help = '/settings/help';
  static const String about = '/settings/about';

  // Payment routes
  static const String payment = '/payment';
  static const String paymentMethods = '/payment/methods';
  static const String addPaymentMethod = '/payment/add';
  static const String paymentHistory = '/payment/history';

  // Emergency routes
  static const String emergency = '/emergency';
  static const String sos = '/emergency/sos';
  static const String emergencyContacts = '/emergency/contacts';

  // Chat routes
  static const String chat = '/chat';
  static const String chatRoom = '/chat/room';

  // Map routes
  static const String map = '/map';
  static const String locationPicker = '/map/picker';

  // Error routes
  static const String error = '/error';
  static const String notFound = '/not-found';
  static const String maintenance = '/maintenance';
} 