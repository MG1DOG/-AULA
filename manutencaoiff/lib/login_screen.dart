import 'package:flutter/material.dart';
import 'package:manutencaoiff/auth_service.dart';

import 'feed_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _criandoConta = false;

  Future<void> _autenticar() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();
    final user = _criandoConta
        ? await _authService.register(email, senha)
        : await _authService.login(email, senha);
    if (!mounted) return;
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => FeedScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Confira os dados e se E-mail/senha está ativo no Firebase.',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.handyman_outlined,
                      size: 42,
                      color: Color(0xFF087E78),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Manutenção IFF',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Registre e acompanhe problemas nos espaços do campus.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'E-mail acadêmico',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _senhaController,
                      obscureText: true,
                      onSubmitted: (_) => _autenticar(),
                      decoration: const InputDecoration(labelText: 'Senha'),
                    ),
                    const SizedBox(height: 18),
                    FilledButton.icon(
                      onPressed: _autenticar,
                      icon: Icon(
                        _criandoConta ? Icons.person_add_alt_1 : Icons.login,
                      ),
                      label: Text(_criandoConta ? 'Criar conta' : 'Entrar'),
                    ),
                    TextButton(
                      onPressed: () =>
                          setState(() => _criandoConta = !_criandoConta),
                      child: Text(
                        _criandoConta
                            ? 'Já tem conta? Entrar'
                            : 'Primeiro acesso? Criar conta',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
