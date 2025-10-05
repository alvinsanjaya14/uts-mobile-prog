import 'package:flutter/foundation.dart'; // <-- DIPERBAIKI: Menggunakan ':'
import '../models/cart_item.dart';
import '../models/product.dart';

class CartController extends ChangeNotifier { // <-- DIPERBAIKI: Menambahkan 'extends ChangeNotifier'
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  int get itemCount => _items.length;

  double get totalPrice {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(Product product, int quantity) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingCartItem) => CartItem(
          product: existingCartItem.product,
          quantity: existingCartItem.quantity + quantity,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(product: product, quantity: quantity),
      );
    }
    notifyListeners(); // Sekarang method ini dikenali
  }

  void incrementItemQuantity(String productId) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingItem) => existingItem.copyWith(quantity: existingItem.quantity + 1),
      );
      notifyListeners();
    }
  }

  void decrementItemQuantity(String productId) {
    if (_items.containsKey(productId) && _items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingItem) => existingItem.copyWith(quantity: existingItem.quantity - 1),
      );
      notifyListeners();
    } else {
      removeItem(productId);
    }
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}