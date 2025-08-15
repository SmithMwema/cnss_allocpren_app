import 'package:cloud_firestore/cloud_firestore.dart';
import '../modèle/dossier.dart';
import '../modèle/utilisateur.dart';

class FirestoreService {
  
  final CollectionReference<Map<String, dynamic>> _dossiersCollection = 
      FirebaseFirestore.instance.collection('dossiers');
  final CollectionReference<Map<String, dynamic>> _utilisateursCollection = 
      FirebaseFirestore.instance.collection('utilisateurs');

  // ==========================================================
  //                MÉTHODES POUR LES UTILISATEURS
  // ==========================================================

  // --- MÉTHODE MISE À JOUR POUR ACCEPTER UN RÔLE ---
  Future<void> createUserDocument(String uid, String nom, String email, String role) async {
    final nouvelUtilisateur = Utilisateur(
      uid: uid,
      nom: nom,
      email: email,
      role: role, // Le rôle est maintenant un paramètre flexible
    );
    await _utilisateursCollection.doc(uid).set(nouvelUtilisateur.toMap());
  }

  Future<Utilisateur?> getUserDocument(String uid) async {
    final docSnapshot = await _utilisateursCollection.doc(uid).get();
    if (docSnapshot.exists) {
      return Utilisateur.fromFirestore(docSnapshot as DocumentSnapshot<Map<String, dynamic>>);
    }
    return null;
  }

  Future<List<Utilisateur>> recupererTousLesUtilisateurs() async {
    final snapshot = await _utilisateursCollection.get();
    return snapshot.docs
        .map((doc) => Utilisateur.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }
  
  // ==========================================================
  //                MÉTHODES POUR LES DOSSIERS
  // ==========================================================

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
}