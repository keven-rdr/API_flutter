import 'package:flutter/material.dart';
import 'package:statement_handle/models/post.dart';
import 'package:statement_handle/screens/post_detail/post_detail.dart';
import '../../components/post_card.dart';
import '../../components/carousel.dart';
import '../../components/search.dart';
import '../../components/category_icons.dart';
import '../../utils/ApiService.dart';
import '../../utils/app_colors.dart';
import '../timeline_screen/timeline_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainsScreenState();
  }
}

class MainsScreenState extends State<MainScreen> {
  int mainScreenState = 2; // 0: success, 1: failure, 2: loading

  List<Post> allPosts = [];
  List<Post> filteredPosts = [];
  List<String> categories = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
    _searchController.addListener(_filterPosts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void tryAgain() {
    loadData();
  }

  void _filterPosts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredPosts = allPosts.where((post) {
        return post.title.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> loadData() async {
    setState(() {
      mainScreenState = 2;
    });

    final responses = await Future.wait([
      TimelineService.loadTimeline(),
      TimelineService.loadCategories(),
    ]);

    final postResponse = responses[0] as ApiResponse<List<Post>>;
    final categoryResponse = responses[1] as ApiResponse<List<String>>;

    if (postResponse.statusCode >= 200 && postResponse.statusCode < 300 &&
        categoryResponse.statusCode >= 200 && categoryResponse.statusCode < 300) {
      setState(() {
        allPosts = postResponse.data ?? [];
        filteredPosts = allPosts;
        categories = categoryResponse.data ?? [];
        mainScreenState = 0;
      });
    } else {
      setState(() {
        mainScreenState = 1;
      });
    }
  }

  void _navigateToDetail(Post post) {
    FocusScope.of(context).unfocus();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PostDetail(post: post)),
    );
  }

  void _onCategoryTapped(String category) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Categoria selecionada: $category'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (mainScreenState) {
      case 0:
        return successScreen();
      case 1:
        return failureScreen();
      default:
        return loadingScreen();
    }
  }

  // ✨ GRANDE ALTERAÇÃO AQUI: USANDO CUSTOMSCROLLVIEW ✨
  Widget successScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Image.asset('/netshirt.png', height: 40),
      ),
      // Trocamos a Column por uma CustomScrollView para ter mais controle sobre o scroll
      body: CustomScrollView(
        // 'slivers' são pedaços de uma área de scroll
        slivers: [
          // SliverToBoxAdapter nos permite colocar um widget normal (não-sliver) aqui.
          // O SearchComponent ficará fixo no topo, abaixo do AppBar.
          SliverToBoxAdapter(
            child: SearchComponent(
              allPosts: allPosts,
              searchController: _searchController,
              onPostSelected: _navigateToDetail,
            ),
          ),

          // O carrossel também é colocado em um adaptador de sliver.
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: const ImageCarousel(),
            ),
          ),

          // O mesmo para os ícones de categoria.
          SliverToBoxAdapter(
            child: CategoryIcons(
              categories: categories,
              onCategorySelected: _onCategoryTapped,
            ),
          ),

          SliverToBoxAdapter(
            child: const Divider(indent: 20, endIndent: 20, height: 24),
          ),

          // SliverList é a versão "sliver" do ListView.builder.
          // É aqui que a lista de posts será renderizada e scrollada.
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final post = filteredPosts[index];
                return PostCard(post: post);
              },
              childCount: filteredPosts.length, // O número de itens na lista
            ),
          ),
        ],
      ),
    );
  }

  // As funções failureScreen e loadingScreen não mudam
  Widget failureScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Image.asset('/netshirt.png', height: 40),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Não foi possível carregar os dados'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: tryAgain,
              child: const Text("Tentar Novamente"),
            ),
          ],
        ),
      ),
    );
  }

  Widget loadingScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Image.asset('/netshirt.png', height: 40),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}