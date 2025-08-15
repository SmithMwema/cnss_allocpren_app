import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../contrôleur/directeur_dashboard_ctrl.dart';

class TabDossiersAValider extends StatelessWidget {
  const TabDossiersAValider({super.key});

  @override
  Widget build(BuildContext context) {
    final DirecteurDashboardCtrl ctrl = Get.find<DirecteurDashboardCtrl>();

    return Obx(() {
      if (ctrl.isLoading.value && ctrl.dossiersAValider.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (ctrl.dossiersAValider.isEmpty) {
        return const Center(child: Text("Aucun dossier en attente de validation."));
      }
      return RefreshIndicator(
        onRefresh: ctrl.chargerDonnees,
        child: ListView.builder(
          itemCount: ctrl.dossiersAValider.length,
          itemBuilder: (context, index) {
            final dossier = ctrl.dossiersAValider[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                title: Text("${dossier.prenomAssure} ${dossier.nomAssure}"),
                subtitle: Text("ID: ${dossier.id} | Statut: ${dossier.statut}"),
                onTap: () {
                  // On vérifie que l'ID n'est pas nul avant de l'envoyer
                  if (dossier.id != null) {
                    _afficherDialogueValidation(context, ctrl, dossier.id!);
                  }
                },
              ),
            );
          },
        ),
      );
    });
  }

  // --- CORRECTION : Le paramètre dossierId est maintenant un String ---
  void _afficherDialogueValidation(BuildContext context, DirecteurDashboardCtrl ctrl, String dossierId) {
    Get.defaultDialog(
      title: "Valider le dossier ?",
      middleText: "ID: $dossierId\n\nCette action est irréversible.",
      textCancel: "Rejeter",
      cancelTextColor: Colors.red,
      onCancel: () => ctrl.validerDossier(dossierId, "Rejeté"),
      textConfirm: "Valider",
      confirmTextColor: Colors.white,
      buttonColor: Colors.green,
      onConfirm: () => ctrl.validerDossier(dossierId, "Validé par Directeur"),
    );
  }
}