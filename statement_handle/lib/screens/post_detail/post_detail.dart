import 'package:flutter/material.dart';

class PostDetail extends StatelessWidget {
  final int postId;

  const PostDetail({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Comentários")),
      body: Center(child: Text("Comentários do post $postId")),
    );
  }
}
