import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:statement_handle/screens/login/login_screen.dart';
import 'package:statement_handle/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meu Perfil"),
        automaticallyImplyLeading: false,
      ),
      // Envolvemos o corpo da tela com um StreamBuilder
      body: StreamBuilder<User?>(
        // O stream 'authStateChanges' notifica sobre qualquer mudança de autenticação
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Enquanto espera pela informação, exibe um loader
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Se o snapshot tem dados, significa que o usuário está logado
          if (snapshot.hasData) {
            // Usamos o usuário do snapshot, que está sempre atualizado
            final user = snapshot.data!;
            return _buildLoggedInView(context, user);
          }

          // Se não há dados, o usuário não está logado
          return _buildGuestView(context);
        },
      ),
    );
  }

  // UI para quando o usuário está logado
  Widget _buildLoggedInView(BuildContext context, User currentUser) {
    final String displayName = currentUser.displayName ?? 'Usuário';
    final String email = currentUser.email ?? 'E-mail não disponível';
    final String? photoUrl = currentUser.photoURL;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
              child: photoUrl == null ? const Icon(LucideIcons.user, size: 50) : null,
            ),
            const SizedBox(height: 24),
            Text(displayName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(email, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(LucideIcons.log_out),
              label: const Text("Sair (Logout)"),
              onPressed: () => AuthService().signOut(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // UI para quando o usuário é um convidado (não logado)
  Widget _buildGuestView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.circle_user, size: 80, color: Colors.grey),
            const SizedBox(height: 24),
            const Text("Você ainda não fez login", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Entre com sua conta para ver seu perfil e salvar suas compras.", style: TextStyle(color: Colors.grey, fontSize: 16), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              child: const Text("Fazer Login ou Cadastrar"),
            ),
          ],
        ),
      ),
    );
  }
}