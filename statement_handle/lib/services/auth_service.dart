import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream para ouvir mudanças no estado de autenticação (logado/deslogado)
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Função de Login com Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. Inicia o fluxo de login do Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // O usuário cancelou o fluxo de login
        return null;
      }

      // 2. Obtém os detalhes de autenticação do pedido
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Cria uma credencial do Firebase com os tokens do Google
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Faz o login no Firebase com a credencial
      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      // Tratar erros aqui
      print(e);
      return null;
    }
  }

  // Função de Logout
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}