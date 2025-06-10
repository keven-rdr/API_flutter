import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:statement_handle/components/post_card.dart';
import 'package:statement_handle/models/post.dart';
import 'package:statement_handle/screens/timeline_screen/timeline_service.dart';

// Reutilizamos o mesmo enum de estado de página
enum PageState { loading, success, error }

class FilterTimelineScreen extends StatefulWidget {
  final String categoryName;

  const FilterTimelineScreen({
    Key? key,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<FilterTimelineScreen> createState() => _FilterTimelineScreenState();
}

class _FilterTimelineScreenState extends State<FilterTimelineScreen> {
  PageState _pageState = PageState.loading;
  List<Post> _categoryPosts = [];

  @override
  void initState() {
    super.initState();
    _fetchCategoryProducts();
  }

  Future<void> _fetchCategoryProducts() async {
    setState(() {
      _pageState = PageState.loading;
    });

    final response = await TimelineService.loadProductsByCategory(widget.categoryName);

    if (mounted) {
      setState(() {
        if (response.statusCode >= 200 && response.statusCode < 300) {
          _categoryPosts = response.data ?? [];
          _pageState = PageState.success;
        } else {
          _pageState = PageState.error;
        }
      });
    }
  }

  // Função para formatar o título da página
  String _formatTitle(String title) {
    if (title.isEmpty) return "Categoria";
    return title[0].toUpperCase() + title.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_formatTitle(widget.categoryName)),
        leading: IconButton(
          icon: const Icon(LucideIcons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_pageState) {
      case PageState.loading:
        return const Center(child: CircularProgressIndicator());
      case PageState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Erro ao carregar os produtos."),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchCategoryProducts,
                child: const Text("Tentar Novamente"),
              ),
            ],
          ),
        );
      case PageState.success:
        if (_categoryPosts.isEmpty) {
          return const Center(child: Text("Nenhum produto encontrado nesta categoria."));
        }
        // Reutilizamos a mesma grade da tela principal
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
                    final post = _categoryPosts[index];
                    return PostCard(post: post);
                  },
                  childCount: _categoryPosts.length,
                ),
              ),
            ),
          ],
        );
    }
  }
}