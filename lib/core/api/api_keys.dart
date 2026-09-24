/// Centralized API and JSON keys used across models, requests, and server response maps.
abstract class ApiKeys {
  ApiKeys._();

  // Common Response Envelope Keys
  static const String success = 'success';
  static const String statusCode = 'statusCode';
  static const String message = 'message';
  static const String data = 'data';
  static const String error = 'error';
  static const String errors = 'errors';

  // Common Entity Fields
  static const String id = 'id';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String isDeleted = 'isDeleted';

  // Auth & User Keys
  static const String accessToken = 'accessToken';
  static const String accessTokenSnake = 'access_token';
  static const String refreshToken = 'refreshToken';
  static const String refreshTokenSnake = 'refresh_token';
  static const String username = 'username';
  static const String email = 'email';
  static const String password = 'password';
  static const String confirmPassword = 'confirm_password';
  static const String birthDate = 'birth_date';
  static const String phoneNumber = 'phone_number';

  // Product & Category Keys
  static const String productName = 'productName';
  static const String productDescription = 'productDescription';
  static const String sku = 'sku';
  static const String price = 'price';
  static const String stock = 'stock';
  static const String stockQuantity = 'quantity';
  static const String avgRating = 'avgRating';
  static const String totalReviews = 'totalReviews';
  static const String category = 'category';
  static const String categoryName = 'categoryName';
  static const String parentId = 'parentId';
  static const String parent = 'parent';
  static const String subCategories = 'subCategories';
  static const String productImages = 'productImages';
  static const String productId = 'productId';
  static const String url = 'url';
  static const String isPrimary = 'isPrimary';
  static const String order = 'order';
  static const String originalName = 'originalName';
  static const String mimeType = 'mimeType';
  static const String size = 'size';
  static const String storageKey = 'storageKey';
  static const String provider = 'provider';

  // Cart Keys
  static const String cartId = 'cartId';
  static const String quantity = 'quantity';
  static const String product = 'product';
  static const String items = 'items';
  static const String totalPrice = 'totalPrice';

  // Order & Checkout Keys
  static const String userId = 'userId';
  static const String shippingAddressId = 'shippingAddressId';
  static const String shippingCity = 'shippingCity';
  static const String shippingStreet = 'shippingStreet';
  static const String shippingBuilding = 'shippingBuilding';
  static const String address = 'address';
  static const String orderStatus = 'orderStatus';
  static const String totalAmount = 'totalAmount';
  static const String paymentMethod = 'paymentMethod';
  static const String payment = 'payment';
  static const String payments = 'payments';
  static const String checkoutUrl = 'checkoutUrl';
  static const String clientSecret = 'clientSecret';
  static const String status = 'status';
}
