import 'package:flutter/material.dart';
import 'package:statement_handle/models/post.dart';

class FavoritesViewModel extends ChangeNotifier {
  final List<Post> _favoriteItems = [];

  List<Post> get favoriteItems => _favoriteItems;

  bool isFavorite(int postId) {
    return _favoriteItems.any((item) => item.id == postId);
  }

  void toggleFavorite(Post post) {
    if (isFavorite(post.id)) {
      _favoriteItems.removeWhere((item) => item.id == post.id);
    } else {
      _favoriteItems.add(post);
    }
    notifyListeners();
  }
}