import 'package:cloud_firestore/cloud_firestore.dart';

class Dossier {
  final String? id; // L'ID vient de Firestore
  final String userId;
  final String nomAssure;
  final String prenomAssure;
  final Timestamp dateSoumission; // Firestore utilise des Timestamps
  final String statut;
  // Ajoutez tous les autres champs du formulaire ici (en String pour la plupart)

  Dossier({
    this.id,
    required this.userId,
    required this.nomAssure,
    required this.prenomAssure,
    required this.dateSoumission,
    required this.statut,
  });

  // Méthode pour convertir notre objet en Map pour l'envoyer à Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'nomAssure': nomAssure,
      'prenomAssure': prenomAssure,
      'dateSoumission': dateSoumission,
      'statut': statut,
    };
  }

  // Méthode pour créer un objet Dossier depuis un document Firestore
  factory Dossier.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Dossier(
      id: doc.id,
      userId: data['userId'],
      nomAssure: data['nomAssure'],
      prenomAssure: data['prenomAssure'],
      dateSoumission: data['dateSoumission'],
      statut: data['statut'],
    );
  }

  // Méthode pour la mise à jour (immuable)
  Dossier copyWith({String? statut}) {
    return Dossier(
      id: id,
      userId: userId,
      nomAssure: nomAssure,
      prenomAssure: prenomAssure,
      dateSoumission: dateSoumission,
      statut: statut ?? this.statut,
    );
  }
}