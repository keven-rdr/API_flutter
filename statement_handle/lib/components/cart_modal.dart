import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';
import 'package:statement_handle/screens/checkout/checkout_screen.dart';
import 'package:statement_handle/viewmodels/cart_viewmodel.dart';

class CartModal extends StatelessWidget {
  const CartModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usa um Consumer para se reconstruir quando o carrinho mudar
    return Consumer<CartViewModel>(
      builder: (context, cart, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Meu Carrinho", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(LucideIcons.x),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text("O produto foi adicionado ao seu carrinho."),
              const Divider(height: 24),
              // Lista de itens no modal
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return ListTile(
                      leading: Image.network(item.product.image, width: 50),
                      title: Text(item.product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text("Qtd: ${item.quantity}"),
                      trailing: Text("R\$ ${(item.product.price * item.quantity).toStringAsFixed(2)}"),
                    );
                  },
                ),
              ),
              const Divider(height: 24),
              // Rodapé do modal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Subtotal", style: TextStyle(fontSize: 16)),
                  Text("R\$ ${cart.totalPrice.toStringAsFixed(2)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Fecha o modal
                    Navigator.push( // Navega para a tela de checkout
                      context,
                      MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                    );
                  },
                  child: const Text("FINALIZAR COMPRA"),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}