import 'package:get/get.dart';

// On importe tous les contrôleurs qui ont besoin d'un binding
import '../contrôleur/auth_ctrl.dart';
import '../contrôleur/declaration_ctrl.dart';
import '../contrôleur/accueil_ctrl.dart';
import '../contrôleur/notification_ctrl.dart';
import '../contrôleur/admin_add_user_ctrl.dart';
import '../contrôleur/agent_details_dossier_ctrl.dart';

import '../vue/accueil_vue.dart';
import '../vue/agent/agent_dashboard_vue.dart';
import '../vue/auth_vue.dart';
import '../vue/declaration_vue.dart';
import '../vue/directeur/directeur_dashboard_vue.dart';
import '../vue/lancement_moderne_vue.dart';
import '../vue/caissier/caissier_dashboard_vue.dart';
import '../vue/admin/admin_dashboard_vue.dart';
import '../vue/agent/agent_details_dossier_vue.dart';
import '../vue/admin/admin_add_user_vue.dart';
import '../vue/notification_vue.dart';

class AppPages {
  static const String lancement = '/lancement';
  static const String auth = '/auth';
  static const String accueil = '/accueil';
  static const String agentDashboard = '/agent-dashboard';
  static const String agentDetailsDossier = '/agent-details-dossier';
  static const String directeurDashboard = '/directeur-dashboard';
  static const String caissierDashboard = '/caissier-dashboard';
  static const String adminDashboard = '/admin-dashboard';
  static const String adminAddUser = '/admin-add-user';
  static const String declaration = '/declaration';
  static const String notifications = '/notifications';

  static final List<GetPage> routes = [
    GetPage(name: lancement, page: () => const LancementModerneVue()),
    
    GetPage(
      name: auth, 
      page: () => const AuthVue(),
      binding: BindingsBuilder(() { Get.lazyPut<AuthCtrl>(() => AuthCtrl()); }),
    ),
    
    // --- ON AJOUTE LE BINDING POUR L'ACCUEIL ---
    GetPage(
      name: accueil, 
      page: () => const AccueilVue(),
      binding: BindingsBuilder(() { Get.lazyPut<AccueilCtrl>(() => AccueilCtrl()); }),
    ),
    
    GetPage(name: agentDashboard, page: () => const AgentDashboardVue()),
    
    GetPage(
      name: agentDetailsDossier,
      page: () => const AgentDetailsDossierVue(),
      binding: BindingsBuilder(() { Get.lazyPut<AgentDetailsDossierCtrl>(() => AgentDetailsDossierCtrl()); }),
    ),

    GetPage(name: directeurDashboard, page: () => const DirecteurDashboardVue()),
    GetPage(name: caissierDashboard, page: () => const CaissierDashboardVue()),
    GetPage(name: adminDashboard, page: () => const AdminDashboardVue()),
    
    GetPage(
      name: notifications,
      page: () => const NotificationVue(),
      binding: BindingsBuilder(() { Get.lazyPut<NotificationCtrl>(() => NotificationCtrl()); }),
    ),
    
    GetPage(
      name: adminAddUser,
      page: () => const AdminAddUserVue(),
      binding: BindingsBuilder(() { Get.lazyPut<AdminAddUserCtrl>(() => AdminAddUserCtrl()); }),
    ),

    GetPage(
      name: declaration,
      page: () => const DeclarationVue(),
      binding: BindingsBuilder(() { Get.lazyPut<DeclarationCtrl>(() => DeclarationCtrl()); }),
    ),
  ];
}