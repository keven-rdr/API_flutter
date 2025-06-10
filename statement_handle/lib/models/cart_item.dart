import 'package:statement_handle/models/post.dart';

class CartItem {
  final Post product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}