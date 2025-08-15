import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modèle/dossier.dart';
import '../routes/app_pages.dart';
import '../service/auth_service.dart';
import '../service/firestore_service.dart';

// On ajoute GetSingleTickerProviderStateMixin pour gérer l'animation des onglets
class DirecteurDashboardCtrl extends GetxController with GetSingleTickerProviderStateMixin {
  final FirestoreService _firestore = Get.find<FirestoreService>();
  final AuthService _authService = Get.find<AuthService>();

  // Contrôleur pour la TabBar
  late TabController tabController;

  var isLoading = true.obs;
  
  // On a maintenant deux listes distinctes, une pour chaque onglet
  final RxList<Dossier> tousLesDossiers = <Dossier>[].obs;
  final RxList<Dossier> dossiersAValider = <Dossier>[].obs;

  // KPIs pour l'onglet "Vue d'Ensemble"
  var totalDossiers = 0.obs;
  var dossiersPayes = 0.obs;
  var dossiersEnAttente = 0.obs;
  var dossiersRejetes = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // On initialise le TabController avec 2 onglets
    tabController = TabController(length: 2, vsync: this);
    chargerDonnees();
  }
  
  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  // Charge les données pour les deux onglets en parallèle
  Future<void> chargerDonnees() async {
    isLoading.value = true;
    try {
      final resultats = await Future.wait([
        _firestore.recupererTousLesDossiers(),
        _firestore.recupererDossiersParStatut('Traité par Agent'),
      ]);
      
      final List<Dossier> allDossiers = resultats[0];
      final List<Dossier> toValidateDossiers = resultats[1];
      
      tousLesDossiers.assignAll(allDossiers);
      dossiersAValider.assignAll(toValidateDossiers);
      
      // On calcule les KPIs à partir de la liste complète
      _calculerKpis(allDossiers);

    } finally {
      isLoading.value = false;
    }
  }

  void _calculerKpis(List<Dossier> dossiers) {
    totalDossiers.value = dossiers.length;
    dossiersPayes.value = dossiers.where((d) => d.statut == 'Payé').length;
    dossiersRejetes.value = dossiers.where((d) => d.statut == 'Rejeté').length;
    dossiersEnAttente.value = totalDossiers.value - dossiersPayes.value - dossiersRejetes.value;
  }
  
  // Fonction utilitaire pour la couleur des statuts
  Color getColorForStatus(String statut) {
    switch (statut) {
      case 'Soumis': return Colors.blue;
      case 'Traité par Agent': return Colors.purple;
      case 'Validé par Directeur': return Colors.orange;
      case 'Payé': return Colors.green;
      case 'Rejeté': return Colors.red;
      default: return Colors.grey;
    }
  }

  // Logique pour valider ou rejeter un dossier
  Future<void> validerDossier(String dossierId, String statutFinal) async {
    if (Get.isDialogOpen!) Get.back();
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    await _firestore.traiterDossier(dossierId, statutFinal);
    Get.back();
    Get.snackbar("Succès", "Dossier #$dossierId marqué comme '$statutFinal'.");
    await chargerDonnees(); 
  }

  // Logique de déconnexion
  Future<void> seDeconnecter() async {
    await _authService.logout();
    Get.offAllNamed(AppPages.auth);
  }
}