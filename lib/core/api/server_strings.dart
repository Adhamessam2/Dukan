/// API Endpoint Strings
class ServerStrings {
  ServerStrings._();

  // Authentication Endpoints
  static const String login = '/auth/sign-in';
  static const String register = '/auth/sign-up';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  // User Endpoints
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/update';

  // Home Endpoints
  static const String categories = '/categories';
  static const String products = '/products';
  static String categoryById(int id) => '$categories/$id';
  static String productById(int id) => '$products/$id';

  // Cart Endpoints
  static const String cartItem = '/cart-item';
  static const String cart = '/cart';
}
