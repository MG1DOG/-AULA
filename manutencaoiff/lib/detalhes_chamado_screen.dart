import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manutencaoiff/firestore_service.dart';


class DetalhesChamadoScreen extends StatefulWidget {
  final String chamadoId;
  final String local;
  final String problema;

  DetalhesChamadoScreen({required this.chamadoId, required this.local, required this.problema});

  @override
  _DetalhesChamadoScreenState createState() => _DetalhesChamadoScreenState();
}

class _DetalhesChamadoScreenState extends State<DetalhesChamadoScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _comentarioController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  void _enviarComentario() {
    if (_comentarioController.text.isNotEmpty) {
      _firestoreService.adicionarComentario(
        chamadoId: widget.chamadoId,
        texto: _comentarioController.text.trim(),
        autorEmail: user?.email ?? 'Anônimo',
      );
      _comentarioController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes do Chamado')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Local: ${widget.local}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 8),
                    Text("Problema relatado: ${widget.problema}", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ),
          Divider(),
          Expanded(
            // Exibe a listagem em tempo real da Subcoleção de Comentarios
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestoreService.getComentariosStream(widget.chamadoId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                var comentarios = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: comentarios.length,
                  itemBuilder: (context, index) {
                    var com = comentarios[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(com['autorEmail'] ?? 'Usuário'),
                      subtitle: Text(com['texto'] ?? ''),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _comentarioController,
                    decoration: InputDecoration(hintText: 'Escreva um comentário ou atualização...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: _enviarComentario,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}