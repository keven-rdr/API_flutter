import 'package:statement_handle/models/post.dart';
import 'package:statement_handle/utils/ApiService.dart';

import '../../models/comment.dart';

class TimelineService {
  static Future<ApiResponse<List<Post>>> loadTimeline() async {
    final url = "https://jsonplaceholder.typicode.com/posts";
    return await ApiService.request<List<Post>>(
      url: url,
      verb: HttpVerb.get,
      fromJson: (json) => (json as List)
          .map((item) => Post.fromJson(item))
          .toList(),
    );
  }

  static Future<ApiResponse<List<Comment>>> loadComments(int postId) async {
    final url = "https://jsonplaceholder.typicode.com/posts/$postId/comments";
    return await ApiService.request<List<Comment>>(
      url: url,
      verb: HttpVerb.get,
      fromJson: (json) => (json as List)
          .map((item) => Comment.fromJson(item))
          .toList(),
    );
  }
}
