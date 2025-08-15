import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../contrôleur/agent_details_dossier_ctrl.dart';

class AgentDetailsDossierVue extends StatelessWidget {
  const AgentDetailsDossierVue({super.key});

  @override
  Widget build(BuildContext context) {
    // Le contrôleur est initialisé ici
    final AgentDetailsDossierCtrl ctrl = Get.put(AgentDetailsDossierCtrl());

    return Scaffold(
      appBar: AppBar(
        title: Text("Détails du Dossier #${ctrl.dossierId}"),
        backgroundColor: const Color(0xff1b263b),
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (ctrl.dossier.value == null) {
          return const Center(child: Text("Erreur : Dossier introuvable."));
        }
        
        final dossier = ctrl.dossier.value!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Informations du Dossier", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
              const Divider(thickness: 1.5),
              _buildInfoRow("ID du Dossier:", dossier.id.toString()),
              _buildInfoRow("Nom de l'assuré(e):", "${dossier.prenomAssure} ${dossier.nomAssure}"),
              _buildInfoRow("Statut Actuel:", dossier.statut),
              // Ajoutez d'autres champs du modèle Dossier ici si nécessaire
              const SizedBox(height: 24),
              
              Text("Pièce Jointe", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
              const Divider(thickness: 1.5),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 32),
                title: const Text("Certificat-Medical.pdf (simulé)"),
                subtitle: const Text("Cliquez pour visualiser"),
                onTap: () => Get.snackbar("Info", "La visualisation de documents sera bientôt disponible."),
              ),
              const SizedBox(height: 40),
              
              // --- BOUTONS D'ACTION EN BAS DE LA PAGE ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.close_rounded),
                    label: const Text("Rejeter le dossier"),
                    onPressed: ctrl.rejeterDossier,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_rounded),
                    label: const Text("Approuver"),
                    onPressed: ctrl.approuverDossier,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}