import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Criar um novo chamado (Problema na sala do IFF)
  Future<void> criarChamado({
    required String local, // Ex: Sala B25
    required String problema, // Ex: Ar-condicionado quebrado
    required String userId,
    required String userEmail,
  }) async {
    await _db.collection('chamados').add({
      'local': local,
      'problema': problema,
      'userId': userId,
      'userEmail': userEmail,
      'status': 'Pendente',
      'dataCriacao': FieldValue.serverTimestamp(),
    });
  }

  // REQUISITO DE FILTRO 1: Todos os chamados ou filtrados por status
  Stream<QuerySnapshot> getChamadosStream() {
    return _db.collection('chamados')
        .orderBy('dataCriacao', descending: true)
        .snapshots();
  }

  // REQUISITO DE FILTRO 2: Filtrar apenas os chamados criados pelo usuário logado
  Stream<QuerySnapshot> getMeusChamadosStream(String userId) {
    return _db.collection('chamados')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  // SUBCOLEÇÃO: Adicionar comentário/interação em um chamado específico
  Future<void> adicionarComentario({
    required String chamadoId,
    required String texto,
    required String autorEmail,
  }) async {
    await _db.collection('chamados')
        .doc(chamadoId)
        .collection('comentarios')
        .add({
      'texto': texto,
      'autorEmail': autorEmail,
      'dataComentario': FieldValue.serverTimestamp(),
    });
  }

  // Stream para escutar os comentários da subcoleção em tempo real
  Stream<QuerySnapshot> getComentariosStream(String chamadoId) {
    return _db.collection('chamados')
        .doc(chamadoId)
        .collection('comentarios')
        .orderBy('dataComentario', descending: false)
        .snapshots();
  }
}