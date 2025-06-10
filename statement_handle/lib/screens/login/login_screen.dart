import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:statement_handle/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        // Adiciona um botão de fechar para o caso do usuário desistir
        leading: IconButton(
          icon: const Icon(LucideIcons.x),
          onPressed: () => Navigator.pop(context, false), // Retorna 'false' se fechar
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('/netshirt.png', height: 80),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              icon: const Icon(LucideIcons.log_in, color: Colors.white),
              label: const Text("Entrar com Google", style: TextStyle(color: Colors.white, fontSize: 16)),
              onPressed: () async {
                final userCredential = await authService.signInWithGoogle();
                // Se o login foi um sucesso e o widget ainda está montado...
                if (userCredential != null && context.mounted) {
                  // ...retorna 'true' para a tela anterior.
                  Navigator.pop(context, true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}