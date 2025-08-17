import 'package:cloud_firestore/cloud_firestore.dart';

// --- RENOMMAGE DE LA CLASSE POUR ÉVITER LE CONFLIT ---
class AppNotification {
  final String? id;
  final String userId;
  final String titre;
  final String message;
  final Timestamp date;
  final bool estLue;

  AppNotification({
    this.id,
    required this.userId,
    required this.titre,
    required this.message,
    required this.date,
    this.estLue = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'titre': titre,
      'message': message,
      'date': date,
      'estLue': estLue,
    };
  }

  factory AppNotification.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return AppNotification(
      id: doc.id,
      userId: data['userId'] ?? '',
      titre: data['titre'] ?? 'Sans Titre',
      message: data['message'] ?? 'Pas de message',
      date: data['date'] ?? Timestamp.now(),
      estLue: data['estLue'] ?? false,
    );
  }
}