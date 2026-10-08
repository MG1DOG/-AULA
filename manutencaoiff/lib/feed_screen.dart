import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manutencaoiff/firestore_service.dart';

import 'criar_chamado_screen.dart';
import 'detalhes_chamado_screen.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _filtrarMeusChamados = false; // Alternador de Filtro
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  void _selecionar(int index, bool isWide) {
    if (!isWide) Navigator.pop(context);
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CriarChamadoScreen()),
      );
    } else {
      setState(() => _filtrarMeusChamados = index == 1);
    }
  }

  Widget _navigation(bool isWide) {
    final index = _filtrarMeusChamados ? 1 : 0;
    if (isWide) {
      return NavigationRail(
        backgroundColor: const Color(0xFF173B39),
        extended: MediaQuery.sizeOf(context).width > 1100,
        selectedIndex: index,
        onDestinationSelected: (value) => _selecionar(value, true),
        leading: const Padding(
          padding: EdgeInsets.all(20),
          child: Icon(Icons.handyman_outlined, color: Color(0xFF72E0D0)),
        ),
        destinations: const [
          NavigationRailDestination(
            icon: Icon(Icons.forum_outlined),
            label: Text('Todos'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.person_outline),
            label: Text('Meus chamados'),
          ),
        ],
      );
    }
    return NavigationDrawer(
      backgroundColor: const Color(0xFF173B39),
      selectedIndex: index,
      onDestinationSelected: (value) => _selecionar(value, false),
      children: const [
        Padding(
          padding: EdgeInsets.fromLTRB(28, 24, 16, 16),
          child: Text(
            'MANUTENÇÃO IFF',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.forum_outlined),
          label: Text('Todos os chamados'),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.person_outline),
          label: Text('Meus chamados'),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.add_circle_outline),
          label: Text('Registrar problema'),
        ),
      ],
    );
  }

  void _abrirChamado() => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => CriarChamadoScreen()),
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        final wide = size.maxWidth >= 900;
        return Scaffold(
          drawer: wide ? null : Drawer(child: _navigation(false)),
          appBar: AppBar(
            title: const Text('Manutenção IFF'),
            actions: wide
                ? [
                    IconButton(
                      onPressed: _abrirChamado,
                      icon: const Icon(Icons.add),
                    ),
                  ]
                : null,
          ),
          body: Row(
            children: [
              if (wide) _navigation(true),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _filtrarMeusChamados
                      ? _firestoreService.getMeusChamadosStream(currentUserId)
                      : _firestoreService.getChamadosStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const Center(child: CircularProgressIndicator());
                    final docs = snapshot.data!.docs;
                    if (docs.isEmpty)
                      return const Center(
                        child: Text('Nenhum chamado encontrado.'),
                      );
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
                        return Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.handyman_outlined,
                              color: Color(0xFF087E78),
                            ),
                            title: Text('${data['local']} · ${data['status']}'),
                            subtitle: Text(
                              '${data['problema']}\n${data['userEmail']}',
                            ),
                            isThreeLine: true,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetalhesChamadoScreen(
                                  chamadoId: docs[index].id,
                                  local: data['local'],
                                  problema: data['problema'],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: wide
              ? null
              : FloatingActionButton(
                  onPressed: _abrirChamado,
                  child: const Icon(Icons.add),
                ),
        );
      },
    );
  }
}
