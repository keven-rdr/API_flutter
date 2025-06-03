import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:statement_handle/models/post.dart';
import 'package:statement_handle/models/comment.dart';
import 'package:statement_handle/utils/app_colors.dart';

import '../screens/timeline_screen/timeline_service.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isExpanded = false;
  List<Comment>? comments;
  bool isLoadingComments = false;

  void toggleComments() async {
    if (isExpanded) {
      setState(() => isExpanded = false);
    } else {
      setState(() {
        isExpanded = true;
        isLoadingComments = true;
      });

      final response = await TimelineService.loadComments(widget.post.id);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        setState(() {
          comments = response.data;
          isLoadingComments = false;
        });
      } else {
        setState(() {
          comments = [];
          isLoadingComments = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.post.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(widget.post.body),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(LucideIcons.mouse_pointer_2, size: 20),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: toggleComments,
                  child: Icon(LucideIcons.message_circle, size: 20),
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 16),
              if (isLoadingComments)
                const Center(child: CircularProgressIndicator())
              else if (comments != null)
                Column(
                  children: comments!
                      .map((c) => ListTile(
                    title: Text(c.name),
                    subtitle: Text(c.body),
                    trailing: Text(c.email, style: const TextStyle(fontSize: 10)),
                  ))
                      .toList(),
                )
              else
                const Text('Erro ao carregar comentários'),
            ]
          ],
        ),
      ),
    );
  }
}
