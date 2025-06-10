import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import 'package:statement_handle/components/post_card.dart';
import 'package:statement_handle/models/cart_item.dart';
import 'package:statement_handle/models/post.dart';
import 'package:statement_handle/viewmodels/cart_viewmodel.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usa um Consumer para reconstruir a tela inteira quando o carrinho muda
    return Consumer<CartViewModel>(
      builder: (context, cart, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Meu Carrinho"),
          ),
          body: cart.items.isEmpty
              ? _buildEmptyCart(context)
              : _buildCartWithItems(context, cart),
          bottomNavigationBar: cart.items.isEmpty
              ? null
              : _buildCheckoutFooter(context, cart),
        );
      },
    );
  }

  // --- WIDGET PARA CARRINHO VAZIO ---
  Widget _buildEmptyCart(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.shopping_cart, size: 80, color: Colors.grey),
              const SizedBox(height: 24),
              const Text("Seu carrinho está vazio", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Que tal explorar nossos produtos em destaque?", style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Explorar produtos"),
              ),
              const SizedBox(height: 40),
              // Aqui você pode adicionar uma lista de produtos "Mais Vendidos"
              // Por simplicidade, vamos deixar um placeholder
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Mais Vendidos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
              ),
              const SizedBox(height: 16),
              const Text("...", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET PARA CARRINHO COM ITENS ---
  Widget _buildCartWithItems(BuildContext context, CartViewModel cart) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Lista de Itens
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cart.items.length,
          itemBuilder: (context, index) {
            final item = cart.items[index];
            return _buildCartItemCard(context, item, cart);
          },
          separatorBuilder: (context, index) => const Divider(height: 24),
        ),
        const SizedBox(height: 24),
        // Resumo do Pedido
        _buildOrderSummary(context, cart),
      ],
    );
  }

  // --- CARD DE UM ITEM NO CARRINHO ---
  Widget _buildCartItemCard(BuildContext context, CartItem item, CartViewModel cart) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(item.product.image, width: 80, height: 80, fit: BoxFit.contain),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  // Placeholder para vendedor, cor, tamanho
                  const Text("Vendido por Netshoes", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const Text("Cor: Branco, Tamanho: P", style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(LucideIcons.trash_2, color: Colors.grey),
              onPressed: () => cart.removeItem(item.product.id),
            )
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Seletor de quantidade
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.minus),
                    onPressed: () => cart.decrementQuantity(item.product.id),
                  ),
                  Text(item.quantity.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(LucideIcons.plus),
                    onPressed: () => cart.incrementQuantity(item.product.id),
                  ),
                ],
              ),
            ),
            // Preço
            Text("R\$ ${item.product.price.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }

  // --- RESUMO DO PEDIDO ---
  Widget _buildOrderSummary(BuildContext context, CartViewModel cart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Adicionar cupom de desconto
        ListTile(
          title: const Text("Cupom de desconto"),
          trailing: TextButton(
            onPressed: () {},
            child: const Text("Adicionar"),
          ),
          contentPadding: EdgeInsets.zero,
        ),
        const Divider(),
        // Subtotal e Valor Total
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Subtotal"),
              Text("R\$ ${cart.totalPrice.toStringAsFixed(2)}"),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Valor total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text("R\$ ${cart.totalPrice.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ),
      ],
    );
  }

  // --- RODAPÉ DE FINALIZAÇÃO ---
  Widget _buildCheckoutFooter(BuildContext context, CartViewModel cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("R\$ ${cart.totalPrice.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Text("ou em até 6x", style: const TextStyle(color: Colors.grey)),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            ),
            child: const Row(
              children: [
                Text("FINALIZAR"),
                SizedBox(width: 8),
                Icon(LucideIcons.chevron_right),
              ],
            ),
          )
        ],
      ),
    );
  }
}