import 'package:get/get.dart'; // <<<--- IMPORT MANQUANT AJOUTÉ ICI
import '../modèle/dossier.dart';
import '../service/firestore_service.dart';

class AgentDetailsDossierCtrl extends GetxController {
  final FirestoreService _firestore = Get.find<FirestoreService>();

  final String dossierId = Get.arguments;

  var isLoading = true.obs;
  final Rx<Dossier?> dossier = Rx<Dossier?>(null);

  @override
  void onInit() {
    super.onInit();
    _chargerDetailsDossier();
  }

  Future<void> _chargerDetailsDossier() async {
    try {
      isLoading.value = true;
      dossier.value = await _firestore.recupererDossierParId(dossierId);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> approuverDossier() async {
    await _firestore.traiterDossier(dossierId, "Traité par Agent");
    Get.back(result: true); 
    Get.snackbar("Succès", "Le dossier #$dossierId a été approuvé et transmis au Directeur.");
  }

  Future<void> rejeterDossier() async {
    await _firestore.traiterDossier(dossierId, "Rejeté");
    Get.back(result: true); 
    Get.snackbar("Info", "Le dossier #$dossierId a été rejeté.");
  }
}