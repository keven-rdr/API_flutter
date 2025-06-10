import 'package:statement_handle/models/post.dart';
import 'package:statement_handle/utils/ApiService.dart';

class TimelineService {
  static Future<ApiResponse<List<Post>>> loadTimeline() async {
    const url = "https://fakestoreapi.com/products";
    return await ApiService.request<List<Post>>(
      url: url,
      verb: HttpVerb.get,
      fromJson: (json) => (json as List)
          .map((item) => Post.fromJson(item))
          .toList(),
    );
  }

  static Future<ApiResponse<List<String>>> loadCategories() async {
    const url = "https://fakestoreapi.com/products/categories";
    return await ApiService.request<List<String>>(
      url: url,
      verb: HttpVerb.get,
      fromJson: (json) => List<String>.from(json),
    );
  }

  static Future<ApiResponse<Post>> loadProductDetail(int productId) async {
    final url = "https://fakestoreapi.com/products/$productId";
    return await ApiService.request<Post>(
      url: url,
      verb: HttpVerb.get,
      // A API retorna um único objeto Post, não uma lista
      fromJson: (json) => Post.fromJson(json),
    );
  }

  static Future<ApiResponse<Post>> deleteProduct(int productId) async {
    final url = "https://fakestoreapi.com/products/$productId";
    return await ApiService.request<Post>(
      url: url,
      verb: HttpVerb.delete,
      fromJson: (json) => Post.fromJson(json),
    );
  }

  static Future<ApiResponse<List<Post>>> loadProductsByCategory(String categoryName) async {
    final encodedCategory = Uri.encodeComponent(categoryName);
    final url = "https://fakestoreapi.com/products/category/$encodedCategory";

    return await ApiService.request<List<Post>>(
      url: url,
      verb: HttpVerb.get,
      fromJson: (json) => (json as List)
          .map((item) => Post.fromJson(item))
          .toList(),
    );
  }
}
