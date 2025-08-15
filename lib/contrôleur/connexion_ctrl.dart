import 'package:flutter/material.dart';
import 'package:get/get.dart';

// CHEMINS D'IMPORT CORRIGÉS ET COMPLETS
import '../service/auth_service.dart';
import '../vue/accueil_vue.dart';

class ConnexionCtrl extends GetxController {
  
  // CORRECTION : On utilise Get.find() pour récupérer le service qui a été mis 
  // dans le "frigo" par main.dart. C'est plus sûr.
  final AuthService _authService = Get.find<AuthService>();

  // Clé pour gérer et valider le formulaire
  final formKey = GlobalKey<FormState>();

  // Contrôleurs pour récupérer le texte des champs
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Variables réactives (.obs) pour que la vue se mette à jour automatiquement
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  // Méthode pour basculer la visibilité du mot de passe
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> seConnecter() async {
    // On vérifie d'abord si le formulaire est valide (champs non vides, format correct)
    if (formKey.currentState!.validate()) {
      isLoading.value = true; // Démarre le chargement
      try {
        final estConnecte = await _authService.login(
          emailController.text,
          passwordController.text,
        );

        if (estConnecte) {
          // Si succès, redirection vers l'accueil
          Get.offAll(() => const AccueilVue());
        } else {
          // Si échec, on affiche un message d'erreur
          Get.snackbar(
            'Erreur de connexion',
            'L\'email ou le mot de passe est incorrect.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        // Gère les erreurs imprévues (ex: pas d'internet)
        Get.snackbar('Erreur', 'Un problème est survenu : $e');
      } finally {
        isLoading.value = false; // Arrête le chargement dans tous les cas
      }
    }
  }

  // On nettoie les contrôleurs quand la page est fermée pour éviter les fuites de mémoire
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}