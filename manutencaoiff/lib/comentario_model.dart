import 'package:cloud_firestore/cloud_firestore.dart';

class ComentarioModel {
  final String id;
  final String texto;
  final String autorEmail;
  final Timestamp? dataComentario;

  ComentarioModel({
    required this.id,
    required this.texto,
    required this.autorEmail,
    this.dataComentario,
  });

  // Converte um DocumentSnapshot da subcoleção em um Objeto ComentarioModel
  factory ComentarioModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ComentarioModel(
      id: doc.id,
      texto: data['texto'] ?? '',
      autorEmail: data['autorEmail'] ?? 'Anônimo',
      dataComentario: data['dataComentario'],
    );
  }

  // Converte o objeto para Map
  Map<String, dynamic> toMap() {
    return {
      'texto': texto,
      'autorEmail': autorEmail,
      'dataComentario': dataComentario ?? FieldValue.serverTimestamp(),
    };
  }
}