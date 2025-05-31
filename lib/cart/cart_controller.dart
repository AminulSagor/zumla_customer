import 'package:get/get.dart';

import 'cart_service.dart';

class CartItem {
  final int productId; // ✅ Add this
  final String image;
  final String title;
  final String brand;
  final double price;
  final bool inStock;
  final String? store;
  final double delCharge;
  int quantity;
  bool selected;

  CartItem({
    required this.productId, // ✅ Add this
    required this.image,
    required this.title,
    required this.brand,
    required this.price,
    required this.inStock,
    this.store,
    required this.delCharge,
    this.selected = false,
    this.quantity = 1,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: int.tryParse(map['product_id'] ?? '0') ?? 0, // ✅ Set from API response
      image: map['image_path'] ?? '',
      title: map['product_name'] ?? '',
      brand: map['brand'] ?? '',
      price: double.tryParse(map['discount_price']?.toString() ?? map['price'] ?? '0') ?? 0,
      inStock: map['stock'] != "0.00",
      store: map['brand'],
      delCharge: double.tryParse(map['del_charge'] ?? '0') ?? 0,
    );
  }
}




class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  var selectedIndex = 2.obs;
  var selectAll = false.obs;

  bool get hasSelectedItems => cartItems.any((item) => item.selected);
  int get selectedItemCount => cartItems.where((item) => item.selected).length;

  @override
  void onInit() {
    super.onInit();
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    try {
      final data = await CartService.getCartItems();
      cartItems.value = data.map((e) => CartItem.fromMap(e)).toList();
    } catch (e) {
      print('❌ Error loading cart items: $e');
    }
  }

  void toggleSelection(int index) {
    cartItems[index].selected = !cartItems[index].selected;
    cartItems.refresh();
  }

  void toggleSelectAll(bool value) {
    selectAll.value = value;
    for (var item in cartItems) {
      item.selected = value;
    }
    cartItems.refresh();
  }

  void toggleStoreSelection(String? storeName) {
    if (storeName == null) return;
    final allSelected = cartItems
        .where((item) => item.store == storeName)
        .every((item) => item.selected);

    for (var item in cartItems) {
      if (item.store == storeName) {
        item.selected = !allSelected;
      }
    }
    cartItems.refresh();
  }

  void incrementQuantity(int index) {
    cartItems[index].quantity++;
    cartItems.refresh();
  }

  void decrementQuantity(int index) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
      cartItems.refresh();
    }
  }

  void checkout() {
    final selected = cartItems.where((item) => item.selected).toList();
    print('✅ Checkout items: ${selected.length}');
  }
}