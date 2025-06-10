import 'package:flutter/material.dart';
import 'package:statement_handle/models/post.dart';
import 'package:statement_handle/screens/post_detail/post_detail.dart';
import 'package:statement_handle/utils/app_colors.dart';

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
        clipBehavior: Clip.antiAlias, // Garante que os cantos arredondados cortem a imagem
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do produto ocupando a parte de cima
            AspectRatio(
              aspectRatio: 1 / 1, // Deixa a imagem quadrada
              child: Image.network(
                post.image,
                fit: BoxFit.cover,
              ),
            ),
            // Padding para o conteúdo de texto
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título do produto
                  Text(
                    post.title,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Preço do produto
                  Text(
                    "R\$ ${post.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}