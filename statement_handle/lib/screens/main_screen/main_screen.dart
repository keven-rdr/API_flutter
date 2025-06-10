import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import 'package:statement_handle/models/post.dart';
import 'package:statement_handle/screens/checkout/checkout_screen.dart';
import 'package:statement_handle/viewmodels/cart_viewmodel.dart';
import '../../components/post_card.dart';
import '../../components/carousel.dart';
import '../../components/search.dart';
import '../../components/category_icons.dart';
import '../../components/reference_footer.dart';
import '../../utils/ApiService.dart';
import '../../utils/app_colors.dart';
import '../post_detail/post_detail.dart';
import '../timeline_screen/timeline_service.dart';

enum PageState { loading, success, error }

class CartIconWithBadge extends StatelessWidget {
  const CartIconWithBadge({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<CartViewModel>(
      builder: (context, cart, child) {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(LucideIcons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                  );
                },
              ),
              if (cart.items.isNotEmpty)
                Positioned(
                  top: 8,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.yellow, // Corrigido para amarelo como no exemplo
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      cart.items.length.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainsScreenState();
  }
}

class MainsScreenState extends State<MainScreen> {
  PageState _pageState = PageState.loading;
  PageState _timelineState = PageState.loading;
  String? _selectedCategory;

  List<Post> allPosts = [];
  List<Post> filteredTimelinePosts = [];
  List<String> categories = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _searchController.addListener(_filterPosts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() { _pageState = PageState.loading; });
    final responses = await Future.wait([
      TimelineService.loadTimeline(),
      TimelineService.loadCategories(),
    ]);
    final postResponse = responses[0] as ApiResponse<List<Post>>;
    final categoryResponse = responses[1] as ApiResponse<List<String>>;
    if (mounted && postResponse.statusCode.isSuccess && categoryResponse.statusCode.isSuccess) {
      setState(() {
        allPosts = postResponse.data ?? [];
        filteredTimelinePosts = allPosts;
        categories = categoryResponse.data ?? [];
        _pageState = PageState.success;
        // ✨ CORREÇÃO APLICADA AQUI ✨
        _timelineState = PageState.success;
      });
    } else if (mounted) {
      setState(() { _pageState = PageState.error; });
    }
  }

  void _filterPosts() {
    final query = _searchController.text.toLowerCase();
    if(query.isNotEmpty && _selectedCategory != null) {
      _clearCategoryFilter();
    }
    setState(() {
      filteredTimelinePosts = allPosts.where((post) {
        return post.title.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _fetchCategoryProducts(String category) async {
    setState(() {
      _selectedCategory = category;
      _timelineState = PageState.loading;
    });
    final response = await TimelineService.loadProductsByCategory(category);
    if(mounted) {
      setState(() {
        if(response.statusCode.isSuccess) {
          filteredTimelinePosts = response.data ?? [];
          _timelineState = PageState.success;
        } else {
          _timelineState = PageState.error;
        }
      });
    }
  }

  void _clearCategoryFilter() {
    setState(() {
      _selectedCategory = null;
      filteredTimelinePosts = allPosts;
      _searchController.clear();
      _timelineState = PageState.success; // Garante que a timeline volte ao estado de sucesso
    });
  }

  void _onCategoryTapped(String category) {
    _fetchCategoryProducts(category);
  }

  void _navigateToDetail(Post post) {
    FocusScope.of(context).unfocus();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PostDetail(post: post)),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_pageState) {
      case PageState.loading:
        return _buildLoadingScreen();
      case PageState.error:
        return _buildFailureScreen();
      case PageState.success:
        return _buildSuccessScreen();
    }
  }

  Widget _buildSuccessScreen() {
    bool isFiltered = _selectedCategory != null;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        leading: isFiltered
            ? IconButton(
          icon: const Icon(Icons.arrow_back), // Ícone de voltar padrão para familiaridade
          onPressed: _clearCategoryFilter,
        )
            : null,
        title: isFiltered
            ? Text(_selectedCategory![0].toUpperCase() + _selectedCategory!.substring(1))
            : Image.asset('/netshirt.png', height: 40),
        actions: const [
          CartIconWithBadge(),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          if (!isFiltered)
            SliverToBoxAdapter(
              child: SearchComponent(
                allPosts: allPosts,
                searchController: _searchController,
                onPostSelected: _navigateToDetail,
              ),
            ),
          if (!isFiltered)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: const ImageCarousel(),
              ),
            ),
          if (!isFiltered)
            SliverToBoxAdapter(
              child: CategoryIcons(
                categories: categories,
                onCategorySelected: _onCategoryTapped,
              ),
            ),
          if (!isFiltered)
            const SliverToBoxAdapter(
              child: Divider(indent: 20, endIndent: 20, height: 24),
            ),
          _buildTimelineContent(),
          if (!isFiltered)
            const SliverToBoxAdapter(
              child: ReferenceFooter(),
            ),
        ],
      ),
    );
  }

  Widget _buildTimelineContent() {
    switch(_timelineState) {
      case PageState.loading:
        return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
      case PageState.error:
        return const SliverFillRemaining(child: Center(child: Text("Erro ao carregar produtos.")));
      case PageState.success:
        if (filteredTimelinePosts.isEmpty) {
          return const SliverFillRemaining(child: Center(child: Text("Nenhum produto encontrado.")));
        }
        return SliverPadding(
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
                final post = filteredTimelinePosts[index];
                return PostCard(post: post);
              },
              childCount: filteredTimelinePosts.length,
            ),
          ),
        );
    }
  }

  Widget _buildFailureScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Image.asset('/netshirt.png', height: 40),
        actions: const [CartIconWithBadge()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Não foi possível carregar os dados'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadInitialData,
              child: const Text("Tentar Novamente"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Image.asset('/netshirt.png', height: 40),
        actions: const [CartIconWithBadge()],
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

extension StatusCodeCheck on int {
  bool get isSuccess => this >= 200 && this < 300;
}