
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../contrôleur/accueil_ctrl.dart';

class AccueilVue extends StatelessWidget {
  const AccueilVue({super.key});

  @override
  Widget build(BuildContext context) {
    final AccueilCtrl ctrl = Get.put(AccueilCtrl());

    return Scaffold(
      appBar: _buildAppBar(context, ctrl),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(
              "Bonjour, ${ctrl.nomUtilisateur.value}",
              style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold),
            )),
            const Text("Bienvenue dans votre espace personnel.", style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 30),
            _buildActionButton(
              icon: Icons.add_circle_outline,
              titre: "Déclarer une grossesse",
              sousTitre: "Commencez une nouvelle procédure de demande.",
              onTap: ctrl.allerVersDeclaration,
            ),
            const SizedBox(height: 30),
            Text("Mes Déclarations", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600)),
            const Divider(),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.folder_off_outlined, size: 60, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    const Text("Aucune déclaration en cours.", style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, AccueilCtrl ctrl) {
    return AppBar(
      title: const Text("Mon Espace"),
      backgroundColor: const Color(0xff1b263b),
      leading: Builder(
        builder: (context) => PopupMenuButton<String>(
          icon: const Icon(Icons.menu),
          color: Theme.of(context).cardColor,
          onSelected: (value) {
            if (value == 'notifications') Get.snackbar("Bientôt", "Page de notifications");
            if (value == 'aide') Get.snackbar("Bientôt", "Page d'aide");
            if (value == 'deconnexion') ctrl.seDeconnecter();
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            _buildPopupMenuItem(context, value: 'notifications', icon: Icons.notifications_outlined, text: 'Notifications'),
            _buildPopupMenuItem(context, value: 'aide', icon: Icons.help_outline, text: 'Aide et Support'),
            _buildThemePopupMenuItem(context),
            const PopupMenuDivider(),
            _buildPopupMenuItem(context, value: 'deconnexion', icon: Icons.logout, text: 'Se déconnecter'),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () => Get.snackbar("Bientôt", "Page de notifications"),
          tooltip: "Notifications",
        )
      ],
    );
  }

  void _afficherDialogueTheme(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          title: Text("Choisir un thème", style: Theme.of(context).textTheme.titleLarge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.wb_sunny_outlined, color: Theme.of(context).iconTheme.color),
                title: Text("Thème Clair", style: Theme.of(context).textTheme.bodyLarge),
                onTap: () { Get.changeThemeMode(ThemeMode.light); Get.back(); },
              ),
              ListTile(
                leading: Icon(Icons.dark_mode_outlined, color: Theme.of(context).iconTheme.color),
                title: Text("Thème Sombre", style: Theme.of(context).textTheme.bodyLarge),
                onTap: () { Get.changeThemeMode(ThemeMode.dark); Get.back(); },
              ),
            ],
          ),
        );
      },
    );
  }
  
  PopupMenuItem<String> _buildThemePopupMenuItem(BuildContext context) {
    return PopupMenuItem<String>(
      value: 'theme',
      onTap: () => Future.delayed(const Duration(milliseconds: 100), () => _afficherDialogueTheme(context)),
      child: Row(
        children: [
          Icon(Icons.dark_mode_outlined, color: Theme.of(context).iconTheme.color),
          const SizedBox(width: 12),
          Text("Changer de Thème", style: Theme.of(context).textTheme.bodyLarge),
          const Spacer(),
          Icon(Icons.arrow_right, color: Theme.of(context).iconTheme.color),
        ],
      ),
    );
  }
  
  PopupMenuItem<String> _buildPopupMenuItem(BuildContext context, {required String value, required IconData icon, required String text}) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).iconTheme.color),
          const SizedBox(width: 12),
          Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  // --- VERSION COMPLÈTE ET CORRIGÉE DE LA FONCTION ---
  Widget _buildActionButton({required IconData icon, required String titre, required String sousTitre, required VoidCallback onTap}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Get.theme.primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titre, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(sousTitre, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}