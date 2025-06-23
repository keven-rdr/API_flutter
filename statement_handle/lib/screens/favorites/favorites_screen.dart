import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import 'package:statement_handle/components/post_card.dart';
import 'package:statement_handle/viewmodels/favorites_viewmodel.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Favoritos"),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<FavoritesViewModel>(
        builder: (context, favoritesViewModel, child) {
          if (favoritesViewModel.favoriteItems.isEmpty) {
            return _buildEmptyFavorites();
          } else {
            return _buildFavoritesList(favoritesViewModel);
          }
        },
      ),
    );
  }

  Widget _buildEmptyFavorites() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(LucideIcons.heart, size: 80, color: Colors.grey),
            SizedBox(height: 24),
            Text(
              "Sua lista de favoritos está vazia",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              "Clique no coração dos produtos que você mais gosta para salvá-los aqui.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList(FavoritesViewModel favoritesViewModel) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1 / 1.5,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final post = favoritesViewModel.favoriteItems[index];
                return PostCard(post: post);
              },
              childCount: favoritesViewModel.favoriteItems.length,
            ),
          ),
        ),
      ],
    );
  }
}