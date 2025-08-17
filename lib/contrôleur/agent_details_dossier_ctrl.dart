import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modèle/dossier.dart';
import '../modèle/notification.dart';
import '../service/firestore_service.dart';

class AgentDetailsDossierCtrl extends GetxController {
  final FirestoreService _firestore = Get.find<FirestoreService>();
  final String dossierId = Get.arguments;
  var isLoading = true.obs;
  final Rx<Dossier?> dossier = Rx<Dossier?>(null);

  final rejetFormKey = GlobalKey<FormState>();
  final rejetMotifController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _chargerDetailsDossier();
  }
  
  @override
  void onClose() {
    rejetMotifController.dispose();
    super.onClose();
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
    Get.snackbar("Succès", "Le dossier #$dossierId a été approuvé.");
  }

  Future<void> rejeterDossier() async {
    if (rejetFormKey.currentState!.validate()) {
      final motif = rejetMotifController.text;
      
      await _firestore.traiterDossier(dossierId, "Rejeté");

      final notification = AppNotification(
        userId: dossier.value!.userId,
        titre: "Mise à jour de votre dossier",
        message: "Votre dossier #${dossier.value!.id!.substring(0,5)} a été rejeté. Motif : $motif",
        date: Timestamp.now(),
      );
      await _firestore.envoyerNotification(notification);

      Get.back();
      Get.back(result: true);
      Get.snackbar("Info", "Le dossier a été rejeté et la bénéficiaire notifiée.");
    }
  }
}