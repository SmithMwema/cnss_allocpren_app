import 'package:flutter/material.dart'; // <<<--- CORRECTION PRINCIPALE ICI
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../contrôleur/notification_ctrl.dart';

class NotificationVue extends StatelessWidget {
  const NotificationVue({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationCtrl ctrl = Get.put(NotificationCtrl());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Notifications"),
        backgroundColor: const Color(0xff1b263b),
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (ctrl.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text("Vous n'avez aucune notification.", style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey)),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: ctrl.chargerNotifications,
          child: ListView.builder(
            itemCount: ctrl.notifications.length,
            itemBuilder: (context, index) {
              final notif = ctrl.notifications[index];
              final isLue = notif.estLue;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                color: isLue ? null : Theme.of(context).primaryColor.withOpacity(0.1),
                child: ListTile(
                  leading: Icon(
                    isLue ? Icons.mark_email_read_outlined : Icons.mark_email_unread_outlined,
                    color: isLue ? Colors.grey : Theme.of(context).primaryColor,
                  ),
                  title: Text(notif.titre, style: TextStyle(fontWeight: isLue ? FontWeight.normal : FontWeight.bold)),
                  subtitle: Text(notif.message),
                  trailing: Text(
                    DateFormat('dd/MM/yy', 'fr_FR').format(notif.date.toDate()),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: () {
                    // Ne marque comme lue que si elle n'est pas déjà lue
                    if (!isLue && notif.id != null) {
                      ctrl.marquerCommeLue(notif.id!);
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