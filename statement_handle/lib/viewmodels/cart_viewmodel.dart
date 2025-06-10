import 'package:flutter/material.dart';
import 'package:statement_handle/models/cart_item.dart';
import 'package:statement_handle/models/post.dart';

class CartViewModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalPrice {
    double total = 0.0;
    for (var item in _items) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  void addItem(Post product) {
    // Verifica se o produto já existe no carrinho
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      // Se existe, apenas incrementa a quantidade
      _items[existingIndex].quantity++;
    } else {
      // Se não existe, adiciona o novo item
      _items.add(CartItem(product: product));
    }
    // Notifica os ouvintes (a UI) que o estado mudou
    notifyListeners();
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void incrementQuantity(int productId) {
    final existingIndex = _items.indexWhere((item) => item.product.id == productId);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(int productId) {
    final existingIndex = _items.indexWhere((item) => item.product.id == productId);
    if (existingIndex >= 0) {
      // Só decrementa se a quantidade for maior que 1
      if (_items[existingIndex].quantity > 1) {
        _items[existingIndex].quantity--;
      } else {
        // Se for 1, remove o item
        removeItem(productId);
      }
      notifyListeners();
    }
  }
}