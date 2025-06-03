import 'package:flutter/material.dart';
import 'package:statement_handle/models/post.dart';
import 'package:statement_handle/screens/post_detail/post_detail.dart';

import '../utils/app_colors.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PostDetail(post: post),
          ),
        );
      },
      child: Card(
        color: AppColors.cardBackground,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                post.body.length > 100 ? '${post.body.substring(0, 100)}...' : post.body,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
