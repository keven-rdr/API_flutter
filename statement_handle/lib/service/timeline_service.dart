import 'package:statement_handle/models/post.dart';
import 'package:statement_handle/utils/ApiService.dart';

class TimelineService {
  // Função para carregar os posts
  static Future<ApiResponse<List<Post>>> loadTimeline() async {
    var url = "https://jsonplaceholder.typicode.com/posts";

    var response = await ApiService.request<List<Post>>(
      url: url,
      verb: HttpVerb.get,
      fromJson: (json) => (json as List)
          .map((item) => Post.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
    return response;
  }
}
