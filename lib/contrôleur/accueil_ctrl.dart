import 'package:get/get.dart';
import '../routes/app_pages.dart';
import '../service/auth_service.dart';

class AccueilCtrl extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  var nomUtilisateur = ''.obs;
  var emailUtilisateur = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _chargerDonneesUtilisateur();
  }

  // --- CORRIGÉ POUR UTILISER L'UTILISATEUR FIREBASE ---
  void _chargerDonneesUtilisateur() {
    // On vérifie si l'objet User de Firebase existe
    if (_authService.user != null) {
      // Le nom est dans la propriété "displayName"
      // On fournit une valeur par défaut si displayName est nul
      nomUtilisateur.value = _authService.user!.displayName ?? 'Nom non défini';
      
      // L'email est dans la propriété "email"
      // On fournit une valeur par défaut si email est nul
      emailUtilisateur.value = _authService.user!.email ?? 'Email non défini';
    } else {
      nomUtilisateur.value = 'Utilisateur';
      emailUtilisateur.value = 'email@inconnu.com';
    }
  }
  // --------------------------------------------------------

  void allerVersDeclaration() {
    Get.toNamed(AppPages.declaration); 
  }

  Future<void> seDeconnecter() async {
    await _authService.logout();
    Get.offAllNamed(AppPages.auth);
  }
}