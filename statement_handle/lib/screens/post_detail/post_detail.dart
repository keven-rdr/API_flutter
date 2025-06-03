import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:statement_handle/models/post.dart';
import 'package:statement_handle/models/comment.dart';
import 'package:statement_handle/screens/timeline_screen/timeline_service.dart';
import 'package:statement_handle/utils/app_colors.dart';

class PostDetail extends StatefulWidget {
  final Post post;

  const PostDetail({Key? key, required this.post}) : super(key: key);

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  bool showComments = false;
  bool isLoading = false;
  List<Comment> comments = [];

  Future<void> loadComments() async {
    setState(() {
      isLoading = true;
    });

    final response = await TimelineService.loadComments(widget.post.id);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        comments = response.data ?? [];
        isLoading = false;
        showComments = true;
      });
    } else {
      setState(() {
        isLoading = false;
        comments = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Detalhes do Post"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(post.body, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            Row(
              children: [
                IconButton(
                  icon: const Icon(LucideIcons.mouse_pointer_2),
                  onPressed: () {}, // ação futura
                ),
                IconButton(
                  icon: const Icon(LucideIcons.message_circle),
                  onPressed: loadComments,
                ),
              ],
            ),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (showComments)
              ListView.builder(
                itemCount: comments.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return Card(
                    color: AppColors.cardBackground,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(comment.name),
                      subtitle: Text(comment.body),
                      trailing: Text(
                        comment.email,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
