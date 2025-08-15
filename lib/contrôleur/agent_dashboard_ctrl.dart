import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modèle/dossier.dart';
import '../modèle/listing.dart';
import '../routes/app_pages.dart';
import '../service/auth_service.dart';
import '../service/firestore_service.dart';

class AgentDashboardCtrl extends GetxController {
  final FirestoreService _firestore = Get.find<FirestoreService>();
  final AuthService _authService = Get.find<AuthService>();

  String get userEmail => _authService.user?.email ?? 'agent@inconnu.com';
  // (Le reste de votre code est déjà parfait)
  var selectedIndex = 0.obs;
  void changePage(int index) { selectedIndex.value = index; }
  var isLoading = true.obs;
  
  final RxList<Dossier> dossiersATraiter = <Dossier>[].obs;
  final RxList<Dossier> dossiersALister = <Dossier>[].obs;
  final RxList<Dossier> dossiersSelectionnes = <Dossier>[].obs;

  @override
  void onInit() {
    super.onInit();
    chargerToutesLesDonnees();
  }

  Future<void> chargerToutesLesDonnees() async {
    isLoading.value = true;
    try {
      await Future.wait([
        _chargerDossiersATraiter(),
        _chargerDossiersALister(),
      ]);
    } catch(e) {
      Get.snackbar("Erreur", "Impossible de charger les données.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _chargerDossiersATraiter() async {
    dossiersATraiter.assignAll(await _firestore.recupererDossiersParStatut('Soumis'));
  }
  
  Future<void> _chargerDossiersALister() async {
    // CORRECTION LOGIQUE : L'agent liste les dossiers validés par le directeur
    dossiersALister.assignAll(await _firestore.recupererDossiersParStatut('Validé par Directeur'));
  }
  
  void voirDetailsDossier(String dossierId) async {
    final result = await Get.toNamed(
      AppPages.agentDetailsDossier, 
      arguments: dossierId
    );
    
    if (result == true) {
      chargerToutesLesDonnees();
    }
  }

  void toggleSelectionDossier(Dossier dossier) {
    // ... (votre code est correct)
  }

  Future<void> genererEtTransmettreListing() async {
    // ... (votre code est correct)
  }
  
  Future<void> seDeconnecter() async {
    // ... (votre code est correct)
  }
}