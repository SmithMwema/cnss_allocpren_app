import 'package:get/get.dart';

import '../contrôleur/auth_ctrl.dart';
import '../contrôleur/declaration_ctrl.dart';
// --- NOUVEL IMPORT POUR LE CONTRÔLEUR D'AJOUT UTILISATEUR ---
import '../contrôleur/admin_add_user_ctrl.dart';

import '../vue/accueil_vue.dart';
import '../vue/agent/agent_dashboard_vue.dart';
import '../vue/auth_vue.dart';
import '../vue/declaration_vue.dart';
import '../vue/directeur/directeur_dashboard_vue.dart';
import '../vue/lancement_moderne_vue.dart';
import '../vue/caissier/caissier_dashboard_vue.dart';
import '../vue/admin/admin_dashboard_vue.dart';
import '../vue/agent/agent_details_dossier_vue.dart';
// --- NOUVEL IMPORT POUR LA VUE D'AJOUT UTILISATEUR ---
import '../vue/admin/admin_add_user_vue.dart';


class AppPages {
  static const String lancement = '/lancement';
  static const String auth = '/auth';
  static const String accueil = '/accueil';
  static const String agentDashboard = '/agent-dashboard';
  static const String agentDetailsDossier = '/agent-details-dossier';
  static const String directeurDashboard = '/directeur-dashboard';
  static const String caissierDashboard = '/caissier-dashboard';
  static const String adminDashboard = '/admin-dashboard';
  // --- NOUVEAU NOM DE ROUTE ---
  static const String adminAddUser = '/admin-add-user';
  static const String declaration = '/declaration';

  static final List<GetPage> routes = [
    GetPage(name: lancement, page: () => const LancementModerneVue()),
    
    GetPage(
      name: auth, 
      page: () => const AuthVue(),
      binding: BindingsBuilder(() { Get.lazyPut<AuthCtrl>(() => AuthCtrl()); }),
    ),
    
    GetPage(name: accueil, page: () => const AccueilVue()),
    GetPage(name: agentDashboard, page: () => const AgentDashboardVue()),
    GetPage(name: agentDetailsDossier, page: () => const AgentDetailsDossierVue()),
    GetPage(name: directeurDashboard, page: () => const DirecteurDashboardVue()),
    GetPage(name: caissierDashboard, page: () => const CaissierDashboardVue()),
    GetPage(name: adminDashboard, page: () => const AdminDashboardVue()),
    
    // --- NOUVELLE ROUTE AVEC SON BINDING ---
    GetPage(
      name: adminAddUser,
      page: () => const AdminAddUserVue(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AdminAddUserCtrl>(() => AdminAddUserCtrl());
      }),
    ),
    
    GetPage(
      name: declaration,
      page: () => const DeclarationVue(),
      binding: BindingsBuilder(() { Get.lazyPut<DeclarationCtrl>(() => DeclarationCtrl()); }),
    ),
  ];
}