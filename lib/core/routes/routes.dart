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
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String orderDetails = '/order-details/:id';
  static String orderDetailsPath(int id) => '/order-details/$id';
  static const String productDetails = '/product-details/:id';
  static String productDetailsPath(int id) => '/product-details/$id';
  static const String paymentWebView = '/payment-webview';
}
