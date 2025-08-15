import 'package:cloud_firestore/cloud_firestore.dart';

class Utilisateur {
  final String uid; // L'ID vient de Firebase Auth
  final String nom;
  final String email;
  final String role;

  Utilisateur({
    required this.uid,
    required this.nom,
    required this.email,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'email': email,
      'role': role,
    };
  }

  factory Utilisateur.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Utilisateur(
      uid: doc.id,
      nom: data['nom'],
      email: data['email'],
      role: data['role'],
    );
  }
}