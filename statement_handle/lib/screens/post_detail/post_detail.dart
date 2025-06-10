import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import 'package:statement_handle/models/post.dart';
import 'package:statement_handle/screens/checkout/checkout_screen.dart'; // Importa a nova tela
import '../../components/cart_modal.dart';
import '../../viewmodels/cart_viewmodel.dart';
import 'post_detail_viewmodel.dart';

class PostDetail extends StatelessWidget {
  final Post post;

  const PostDetail({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostDetailViewModel()..fetchProductDetails(post.id),
      // O Consumer agora envolve o Scaffold para que o bottomNavigationBar tenha acesso ao 'viewModel'
      child: Consumer<PostDetailViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(LucideIcons.chevron_left),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(viewModel.detailedPost?.title ?? "Detalhes"),
            ),
            // O corpo da tela continua o mesmo, apenas usando o viewModel que já está disponível
            body: _buildBody(context, viewModel),

            // ✨ BARRA DE RODAPÉ FIXA ADICIONADA AQUI ✨
            // Só mostra a barra se o produto tiver carregado com sucesso
            bottomNavigationBar: viewModel.pageState == PageState.success
                ? _buildBottomBar(context, viewModel.detailedPost!)
                : null,
          );
        },
      ),
    );
  }

  // O corpo da tela agora recebe o viewModel para construir a UI
  Widget _buildBody(BuildContext context, PostDetailViewModel viewModel) {
    switch (viewModel.pageState) {
      case PageState.loading:
        return const Center(child: CircularProgressIndicator());
      case PageState.error:
        return _buildErrorUI(context, viewModel);
      case PageState.success:
        if (viewModel.detailedPost == null) {
          return const Center(child: Text("Produto não encontrado."));
        }
        return _buildSuccessUI(context, viewModel.detailedPost!);
    }
  }

  // Novo widget para construir a barra de rodapé
  Widget _buildBottomBar(BuildContext context, Post post) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Imagem e Preço
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(post.image, width: 50, height: 50, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min, // Faz a coluna ter o tamanho mínimo necessário
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "R\$ ${post.price.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                "em até 3x de R\$ ${(post.price / 3).toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const Spacer(), // Ocupa o espaço vazio e empurra o botão para a direita

          // Botão Comprar
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CheckoutScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("COMPRAR"),
          ),
        ],
      ),
    );
  }

  // As funções _buildErrorUI e _buildSuccessUI continuam as mesmas
  Widget _buildErrorUI(BuildContext context, PostDetailViewModel viewModel) {
    // ... (código da função de erro que você já tem)
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Erro ao carregar os detalhes."),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => viewModel.fetchProductDetails(post.id),
            child: const Text("Tentar Novamente"),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessUI(BuildContext context, Post post) {
    // ... (código da função de sucesso que você já tem)
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            post.image,
            height: 300,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "R\$ ${post.price.toStringAsFixed(2)}",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Descrição",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  post.body,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(LucideIcons.shopping_cart),
                    label: const Text("Adicionar ao Carrinho"),
                    onPressed: () {
                      final cart = Provider.of<CartViewModel>(context, listen: false);
                      cart.addItem(post);
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) => const CartModal(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                )


              ],
            ),
          ),
        ],
      ),
    );
  }
}