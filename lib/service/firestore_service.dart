import 'package:cloud_firestore/cloud_firestore.dart';
import '../modèle/dossier.dart';
import '../modèle/utilisateur.dart';
import '../modèle/notification.dart';

class FirestoreService {
  
  final CollectionReference<Map<String, dynamic>> _dossiersCollection = 
      FirebaseFirestore.instance.collection('dossiers');
  final CollectionReference<Map<String, dynamic>> _utilisateursCollection = 
      FirebaseFirestore.instance.collection('utilisateurs');
  final CollectionReference<Map<String, dynamic>> _notificationsCollection = 
      FirebaseFirestore.instance.collection('notifications');

  // --- MÉTHODES UTILISATEURS ---
  Future<void> createUserDocument(String uid, String nom, String email, String role) async {
    final nouvelUtilisateur = Utilisateur(uid: uid, nom: nom, email: email, role: role);
    await _utilisateursCollection.doc(uid).set(nouvelUtilisateur.toMap());
  }

  Future<Utilisateur?> getUserDocument(String uid) async {
    final docSnapshot = await _utilisateursCollection.doc(uid).get();
    if (docSnapshot.exists) {
      return Utilisateur.fromFirestore(docSnapshot);
    }
    return null;
  }

  Future<List<Utilisateur>> recupererTousLesUtilisateurs() async {
    final snapshot = await _utilisateursCollection.get();
    return snapshot.docs.map((doc) => Utilisateur.fromFirestore(doc)).toList();
  }
  
  // --- MÉTHODES DOSSIERS COMPLÈTES ---
  Future<void> soumettreNouveauDossier(Dossier dossier) async {
    await _dossiersCollection.add(dossier.toMap());
  }

  Future<List<Dossier>> recupererDossiersParStatut(String statut) async {
    final snapshot = await _dossiersCollection.where('statut', isEqualTo: statut).get();
    return snapshot.docs.map((doc) => Dossier.fromFirestore(doc)).toList();
  }
  
  Future<List<Dossier>> recupererTousLesDossiers() async {
    final snapshot = await _dossiersCollection.orderBy('dateSoumission', descending: true).get();
    return snapshot.docs.map((doc) => Dossier.fromFirestore(doc)).toList();
  }
  
  Future<List<Dossier>> recupererDossiersUtilisateur(String userId) async {
    final snapshot = await _dossiersCollection
        .where('userId', isEqualTo: userId)
        .orderBy('dateSoumission', descending: true)
        .get();
    return snapshot.docs.map((doc) => Dossier.fromFirestore(doc)).toList();
  }
  
  Future<void> traiterDossier(String dossierId, String nouveauStatut) async {
    await _dossiersCollection.doc(dossierId).update({'statut': nouveauStatut});
  }

  Future<Dossier?> recupererDossierParId(String dossierId) async {
    final docSnapshot = await _dossiersCollection.doc(dossierId).get();
    if (docSnapshot.exists) {
      return Dossier.fromFirestore(docSnapshot);
    }
    return null;
  }

  // --- MÉTHODES NOTIFICATIONS ---
  Future<void> envoyerNotification(AppNotification notification) async {
    await _notificationsCollection.add(notification.toMap());
  }

  Future<List<AppNotification>> recupererNotifications(String userId) async {
    final snapshot = await _notificationsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .get();
    return snapshot.docs.map((doc) => AppNotification.fromFirestore(doc)).toList();
  }

  Future<void> marquerNotificationCommeLue(String notificationId) async {
    await _notificationsCollection.doc(notificationId).update({'estLue': true});
  }
}