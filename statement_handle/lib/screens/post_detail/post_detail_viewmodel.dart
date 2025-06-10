import 'package:flutter/material.dart';
import 'package:statement_handle/models/post.dart';
import 'package:statement_handle/screens/timeline_screen/timeline_service.dart';


enum PageState { loading, success, error }


class PostDetailViewModel extends ChangeNotifier {
  PageState _pageState = PageState.loading;
  Post? _detailedPost;


  PageState get pageState => _pageState;
  Post? get detailedPost => _detailedPost;


  Future<void> fetchProductDetails(int productId) async {
    _pageState = PageState.loading;
    notifyListeners();

    final response = await TimelineService.loadProductDetail(productId);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      _detailedPost = response.data;
      _pageState = PageState.success;
    } else {
      _pageState = PageState.error;
    }
    notifyListeners();
  }
}