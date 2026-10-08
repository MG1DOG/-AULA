import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login com e-mail e senha + Salvamento local
  Future<User?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', user.email ?? '');
        await prefs.setString('user_uid', user.uid);
      }
      return user;
    } catch (e) {
      print("Erro no login: $e");
      return null;
    }
  }

  // Cadastro de novo usuário
  Future<User?> register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', user.email ?? '');
        await prefs.setString('user_uid', user.uid);
      }
      return user;
    } catch (e) {
      print("Erro no cadastro: $e");
      return null;
    }
  }

  // Logout e limpeza do SharedPreferences
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _auth.signOut();
  }

  // Verificar se há sessão ativa local
  Future<bool> isLoggedLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user_uid');
  }
}
