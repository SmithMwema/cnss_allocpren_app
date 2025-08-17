import 'package:cloud_firestore/cloud_firestore.dart';

class Dossier {
  final String? id;
  final String userId;
  final String nomAssure;
  final String prenomAssure;
  final Timestamp dateSoumission;
  final String statut;

  Dossier({
    this.id,
    required this.userId,
    required this.nomAssure,
    required this.prenomAssure,
    required this.dateSoumission,
    required this.statut,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'nomAssure': nomAssure,
      'prenomAssure': prenomAssure,
      'dateSoumission': dateSoumission,
      'statut': statut,
    };
  }

  factory Dossier.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Dossier(
      id: doc.id,
      userId: data['userId'] ?? '',
      nomAssure: data['nomAssure'] ?? 'N/A',
      prenomAssure: data['prenomAssure'] ?? 'N/A',
      dateSoumission: data['dateSoumission'] ?? Timestamp.now(),
      statut: data['statut'] ?? 'Inconnu',
    );
  }

  Dossier copyWith({String? statut}) {
    return Dossier(
      id: this.id,
      userId: this.userId,
      nomAssure: this.nomAssure,
      prenomAssure: this.prenomAssure,
      dateSoumission: this.dateSoumission,
      statut: statut ?? this.statut,
    );
  }
}