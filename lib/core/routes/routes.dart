/// Application Routes
class Routes {
  Routes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  //static const String auth ='/'
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String productDetails = '/product-details/:id';
  static String productDetailsPath(int id) => '/product-details/$id';
}
