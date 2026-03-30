// This is where all my endpoints will be located for the app
// Author: Luis Angel Beltran Sanchez
// Version: 1.0.0

class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = 'auth/login';
  static const String register = 'auth/register';
  static const String logout = 'auth/logout';

  // Products
  static const String products = '/products';
  static String productByID(String id) => '/product/$id';

  // Cart
  static const String cart = '/cart';
  static String cartItem(String id) => '/cart/items/$id';

  // Orders
  static const String orders = '/orders';
  static String orderByID(String id) => '/orders/$id';
}