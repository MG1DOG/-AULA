import 'package:cloud_firestore/cloud_firestore.dart';

class ChamadoModel {
  final String id;
  final String local;
  final String problema;
  final String userId;
  final String userEmail;
  final String status;
  final Timestamp? dataCriacao;

  ChamadoModel({
    required this.id,
    required this.local,
    required this.problema,
    required this.userId,
    required this.userEmail,
    required this.status,
    this.dataCriacao,
  });

  // Converte um DocumentSnapshot do Firestore em um Objeto ChamadoModel
  factory ChamadoModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChamadoModel(
      id: doc.id,
      local: data['local'] ?? '',
      problema: data['problema'] ?? '',
      userId: data['userId'] ?? '',
      userEmail: data['userEmail'] ?? '',
      status: data['status'] ?? 'Pendente',
      dataCriacao: data['dataCriacao'],
    );
  }

  // Converte o objeto para Map (caso precise enviar manualmente ao Firestore)
  Map<String, dynamic> toMap() {
    return {
      'local': local,
      'problema': problema,
      'userId': userId,
      'userEmail': userEmail,
      'status': status,
      'dataCriacao': dataCriacao ?? FieldValue.serverTimestamp(),
    };
  }
}