import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modèle/dossier.dart';
import '../routes/app_pages.dart';
import '../service/auth_service.dart';
import '../service/firestore_service.dart'; // On utilise Firestore

class CaissierDashboardCtrl extends GetxController {
  final FirestoreService _firestore = Get.find<FirestoreService>();
  final AuthService _authService = Get.find<AuthService>();

  var isLoading = true.obs;
  final RxList<Dossier> listeDossiers = <Dossier>[].obs;
  
  var nomUtilisateur = ''.obs;
  var emailUtilisateur = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _chargerInfosUtilisateur();
    chargerDossiers();
  }

  void _chargerInfosUtilisateur() {
    if (_authService.user != null) {
      // On utilise l'utilisateur Firebase
      nomUtilisateur.value = _authService.user!.displayName ?? 'Caissier';
      emailUtilisateur.value = _authService.user!.email ?? 'email@inconnu.com';
    }
  }

  Future<void> chargerDossiers() async {
    try {
      isLoading.value = true;
      // On appelle la méthode de Firestore avec le bon statut
      listeDossiers.assignAll(await _firestore.recupererDossiersParStatut('Validé par Directeur'));
    } finally {
      isLoading.value = false;
    }
  }

  // --- L'ID est maintenant un String ---
  Future<void> payerDossier(String dossierId) async {
    Get.defaultDialog(
      title: "Confirmer le Paiement",
      middleText: "Voulez-vous marquer le dossier #$dossierId comme 'Payé' ?",
      textConfirm: "Confirmer",
      confirmTextColor: Colors.white,
      buttonColor: Colors.green,
      onConfirm: () async {
        Get.back();
        Get.dialog(const Center(child: CircularProgressIndicator()));
        await _firestore.traiterDossier(dossierId, "Payé");
        Get.back();
        Get.snackbar("Succès", "Le dossier #$dossierId a été marqué comme 'Payé'.");
        chargerDossiers();
      },
      textCancel: "Annuler",
    );
  }
  
  Future<void> seDeconnecter() async {
    await _authService.logout();
    Get.offAllNamed(AppPages.auth);
  }
}