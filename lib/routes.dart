import 'package:get/get.dart';
import 'package:zumla_customer/cart/cart_view.dart';
import 'package:zumla_customer/category/category_view.dart';
import 'package:zumla_customer/checkout/checkout_view.dart';
import 'package:zumla_customer/customer_home/customer_home_view.dart';
import 'package:zumla_customer/payment_method/payment_method_view.dart';
import 'package:zumla_customer/product_details/product_details_view.dart';


class AppRoutes {
  static const String signUp = '/signup';
  static const String storeInfoUp = '/store-info-up';
  static const String forgetPass = '/forget-pass';
  static const String changePass = '/change-pass';
  static const String homePage = '/home-page';
  static const String productUpload = '/product-upload';
  // static const String productList = '/product-list';
  static const String approvedProduct = '/approved-product';
  static const String pendingProduct = '/pending-product';
  static const String category = '/category';
  static const String productDetails = '/product-details';
  static const String cardView = '/card-view';
  static const String checkout = '/checkout';
  static const String paymentMethod = '/payment-method';

  static final routes = [
    GetPage(name: homePage, page: () =>  CustomerHomePage()),
    GetPage(name: category, page: () =>  CategoryView()),
    GetPage(name: productDetails, page: () =>  ProductDetailsView()),
    GetPage(name: cardView, page: () =>  CartView()),
    GetPage(name: checkout, page: () =>  CheckoutView()),
    GetPage(name: paymentMethod, page: () =>  PaymentMethodView()),
  ];
}
