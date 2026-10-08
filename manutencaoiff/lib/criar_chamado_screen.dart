import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manutencaoiff/firestore_service.dart';


class CriarChamadoScreen extends StatefulWidget {
  @override
  _CriarChamadoScreenState createState() => _CriarChamadoScreenState();
}

class _CriarChamadoScreenState extends State<CriarChamadoScreen> {
  final _localController = TextEditingController();
  final _problemaController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  final user = FirebaseAuth.instance.currentUser;

  void _salvar() async {
    if (_localController.text.isNotEmpty && _problemaController.text.isNotEmpty && user != null) {
      await _firestoreService.criarChamado(
        local: _localController.text.trim(),
        problema: _problemaController.text.trim(),
        userId: user!.uid,
        userEmail: user!.email ?? '',
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Novo Relato de Problema')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _localController,
              decoration: InputDecoration(labelText: 'Local (ex: Sala B25, Bloco B)'),
            ),
            TextField(
              controller: _problemaController,
              decoration: InputDecoration(labelText: 'Descrição do Problema (ex: Ar-condicionado quebrado)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvar,
              child: Text('Cadastrar Chamado'),
            ),
          ],
        ),
      ),
    );
  }
}