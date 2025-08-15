import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../contrôleur/caissier_dashboard_ctrl.dart';
import '../../modèle/dossier.dart';

// PAS D'IMPORT EXTERNE POUR LE SIDEBAR

class CaissierDashboardVue extends StatelessWidget {
  const CaissierDashboardVue({super.key});

  @override
  Widget build(BuildContext context) {
    final CaissierDashboardCtrl ctrl = Get.put(CaissierDashboardCtrl());

    return Scaffold(
      drawer: Obx(() => _SideBarCaissier(
        nom: ctrl.nomUtilisateur.value,
        email: ctrl.emailUtilisateur.value,
        onDeconnexion: ctrl.seDeconnecter,
      )),
      appBar: AppBar(
        title: const Text("Espace Caissier"),
        backgroundColor: const Color(0xff0d1b2a),
        actions: [
          Obx(() => Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text("${ctrl.listeDossiers.length} à payer"),
            ),
          ))
        ],
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (ctrl.listeDossiers.isEmpty) {
          return Center(
            child: Text("Aucun dossier en attente de paiement.", style: GoogleFonts.poppins()),
          );
        }
        return RefreshIndicator(
          onRefresh: ctrl.chargerDossiers,
          child: ListView.builder(
            itemCount: ctrl.listeDossiers.length,
            itemBuilder: (context, index) {
              final dossier = ctrl.listeDossiers[index];
              return Card(
                child: ListTile(
                  title: Text("${dossier.prenomAssure} ${dossier.nomAssure}"),
                  subtitle: Text("ID: ${dossier.id} | Statut: ${dossier.statut}"),
                  
                  // --- CORRECTION DE L'APPEL DE MÉTHODE ---
                  onTap: () {
                    if (dossier.id != null) {
                      ctrl.payerDossier(dossier.id!); // On appelle la bonne méthode
                    }
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

// --- Le widget _SideBarCaissier reste le même ---
class _SideBarCaissier extends StatelessWidget {
  final String nom;
  final String email;
  final VoidCallback onDeconnexion;

  const _SideBarCaissier({
    required this.nom,
    required this.email,
    required this.onDeconnexion,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xff1b263b),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(nom, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              accountEmail: Text(email),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Color(0xff00a99d),
                child: Icon(Icons.admin_panel_settings, size: 40, color: Colors.white),
              ),
              decoration: const BoxDecoration(color: Color(0xff0d1b2a)),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_outlined, color: Colors.white70),
              title: const Text('Tableau de bord', style: TextStyle(color: Colors.white)),
              onTap: () => Get.back(),
            ),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white70),
              title: const Text('Se déconnecter', style: TextStyle(color: Colors.white)),
              onTap: onDeconnexion,
            ),
          ],
        ),
      ),
    );
  }
}