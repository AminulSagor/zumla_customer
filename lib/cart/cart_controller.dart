import 'package:get/get.dart';

class CartItem {
  final String image;
  final String title;
  final String brand;
  final double price;
  final bool inStock;
  final String? store;
  int quantity;


  bool selected;

  CartItem({
    required this.image,
    required this.title,
    required this.brand,
    required this.price,
    required this.inStock,
    this.store,
    this.selected = false,
    this.quantity = 1,
  });
}

class CartController extends GetxController {
  bool get hasSelectedItems => cartItems.any((item) => item.selected);
  int get selectedItemCount => cartItems.where((item) => item.selected).length;


  var cartItems = <CartItem>[
    CartItem(
      image: 'assets/png/headphone.png',
      title: 'JBL Tube 489',
      brand: 'Brand name',
      price: 100,
      inStock: false,
      store: 'Rokomari',
    ),
    CartItem(
      image: 'assets/png/headphone.png',
      title: 'JBL Tube 489',
      brand: 'Brand name',
      price: 100,
      inStock: true,
      store: 'Rokomari',
    ),
    CartItem(
      image: 'assets/png/headphone.png',
      title: 'JBL Tube 489',
      brand: 'Brand name',
      price: 100,
      inStock: true,
      store: 'Tri Gardening',
    ),
    CartItem(
      image: 'assets/png/headphone.png',
      title: 'JBL Tube 489',
      brand: 'Brand name',
      price: 100,
      inStock: true,
      store: 'Tri Gardening',
    ),
  ].obs;

  var selectedIndex = 2.obs;
  var selectAll = false.obs;

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
    print('Checkout items: ${selected.length}');
  }
}
