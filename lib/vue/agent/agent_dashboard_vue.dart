import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../contrôleur/agent_dashboard_ctrl.dart';
import '../../modèle/dossier.dart';
import '../../routes/app_pages.dart';

class AgentDashboardVue extends StatelessWidget {
  const AgentDashboardVue({super.key});

  @override
  Widget build(BuildContext context) {
    final AgentDashboardCtrl ctrl = Get.put(AgentDashboardCtrl());
    
    final List<Widget> pages = [
      _buildTraitementPage(ctrl),
      _buildListingPage(ctrl),
      _buildHistoriquePage(ctrl),
    ];

    return Scaffold(
      drawer: _buildAgentSideBar(ctrl, context),
      appBar: AppBar(
        title: const Text("Espace Agent PF"),
        backgroundColor: const Color(0xff1b263b),
      ),
      backgroundColor: Get.isDarkMode ? const Color(0xff121212) : Colors.grey.shade100,
      
      bottomNavigationBar: Obx(() => NavigationBar(
        selectedIndex: ctrl.selectedIndex.value,
        onDestinationSelected: ctrl.changePage,
        destinations: [
          NavigationDestination(
            icon: Badge(label: Text(ctrl.dossiersATraiter.length.toString()), isLabelVisible: ctrl.dossiersATraiter.isNotEmpty, backgroundColor: Colors.red),
            label: 'Traitement',
          ),
          NavigationDestination(
            icon: Badge(label: Text(ctrl.dossiersALister.length.toString()), isLabelVisible: ctrl.dossiersALister.isNotEmpty, backgroundColor: Colors.blue),
            label: 'Listings',
          ),
          const NavigationDestination(
            icon: Icon(Icons.history_outlined),
            label: 'Historique',
          ),
        ],
      )),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Obx(() => Row(
              children: [
                Expanded(child: _buildStatCard("À traiter", ctrl.dossiersATraiter.length, Icons.hourglass_top_outlined, Colors.orange)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard("Prêts pour Listing", ctrl.dossiersALister.length, Icons.checklist_rtl_outlined, Colors.green)),
              ],
            )),
          ),
          const Divider(height: 1, indent: 12, endIndent: 12),

          Expanded(
            child: Obx(() {
              if (ctrl.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return pages[ctrl.selectedIndex.value];
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAgentSideBar(AgentDashboardCtrl ctrl, BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xff1b263b),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Agent PF", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              accountEmail: Obx(() => Text(ctrl.userEmail, style: GoogleFonts.poppins())),
              currentAccountPicture: const CircleAvatar(backgroundColor: Color(0xff00a99d), child: Icon(Icons.support_agent, size: 40, color: Colors.white)),
              decoration: const BoxDecoration(color: Color(0xff0d1b2a)),
            ),
            _buildDrawerItem(icon: Icons.notifications_outlined, text: 'Notifications', onTap: () { Get.back(); Get.snackbar("Bientôt", "Page des notifications"); }),
            _buildDrawerItem(icon: Icons.palette_outlined, text: 'Changer le Thème', onTap: () { Get.back(); _afficherDialogueTheme(context); }),
            const Divider(color: Colors.white24),
            _buildDrawerItem(icon: Icons.logout, text: 'Se déconnecter', onTap: () { Get.back(); ctrl.seDeconnecter(); }),
          ],
        ),
      ),
    );
  }

  void _afficherDialogueTheme(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context) => AlertDialog(
      backgroundColor: Get.theme.dialogBackgroundColor,
      title: Text("Choisir un thème", style: Get.theme.textTheme.titleLarge),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
          leading: Icon(Icons.wb_sunny_outlined, color: Get.theme.iconTheme.color),
          title: Text("Thème Clair", style: Get.theme.textTheme.bodyLarge),
          onTap: () { Get.changeThemeMode(ThemeMode.light); Get.back(); },
        ),
        ListTile(
          leading: Icon(Icons.dark_mode_outlined, color: Get.theme.iconTheme.color),
          title: Text("Thème Sombre", style: Get.theme.textTheme.bodyLarge),
          onTap: () { Get.changeThemeMode(ThemeMode.dark); Get.back(); },
        ),
      ]),
    ));
  }

  Widget _buildDrawerItem({required IconData icon, required String text, required GestureTapCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(text, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  Widget _buildTraitementPage(AgentDashboardCtrl ctrl) {
    if (ctrl.dossiersATraiter.isEmpty) {
      return _buildEmptyState("Aucun nouveau dossier à traiter", Icons.inbox_outlined);
    }
    return RefreshIndicator(
      onRefresh: ctrl.chargerToutesLesDonnees,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: ctrl.dossiersATraiter.length,
        itemBuilder: (context, index) {
          final dossier = ctrl.dossiersATraiter[index];
          return Card(
            child: ListTile(
              title: Text("${dossier.prenomAssure} ${dossier.nomAssure}"),
              subtitle: Text("ID: ${dossier.id ?? 'Inconnu'}"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                if (dossier.id != null) {
                  ctrl.voirDetailsDossier(dossier.id!);
                } else {
                  Get.snackbar("Erreur", "ID de dossier manquant.");
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildListingPage(AgentDashboardCtrl ctrl) {
    return Column(
      children: [
        Expanded(
          child: ctrl.dossiersALister.isEmpty
              ? _buildEmptyState("Aucun dossier validé à lister.", Icons.checklist_rtl_outlined)
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: ctrl.dossiersALister.length,
                  itemBuilder: (context, index) {
                    final dossier = ctrl.dossiersALister[index];
                    return Obx(() {
                      final isSelected = ctrl.dossiersSelectionnes.contains(dossier);
                      return CheckboxListTile(
                        title: Text("${dossier.prenomAssure} ${dossier.nomAssure}"),
                        value: isSelected,
                        onChanged: (val) => ctrl.toggleSelectionDossier(dossier),
                      );
                    });
                  },
                ),
        ),
        if (ctrl.dossiersALister.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.post_add_rounded),
              label: Obx(() => Text("Générer Listing (${ctrl.dossiersSelectionnes.length})")),
              onPressed: ctrl.dossiersSelectionnes.isEmpty ? null : ctrl.genererEtTransmettreListing,
            ),
          ),
      ],
    );
  }
  
  Widget _buildHistoriquePage(AgentDashboardCtrl ctrl) {
    return _buildEmptyState("L'historique des listings sera bientôt disponible.", Icons.history_outlined);
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, size: 80, color: Colors.grey.shade400),
      const SizedBox(height: 16),
      Text(message, style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey)),
    ]));
  }

  // --- FONCTION COMPLÉTÉE ---
  Widget _buildStatCard(String titre, int valeur, IconData icone, Color couleur) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, size: 28, color: couleur),
          const SizedBox(height: 12),
          Text(valeur.toString(), style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(titre, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}