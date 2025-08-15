import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../contrôleur/connexion_ctrl.dart';
import '../utilitaire/validateur.dart'; // On va utiliser notre validateur

class ConnexionVue extends StatelessWidget {
  const ConnexionVue({super.key});

  @override
  Widget build(BuildContext context) {
    // Le contrôleur est initialisé ici par GetX
    final ConnexionCtrl ctrl = Get.put(ConnexionCtrl());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentification'),
        backgroundColor: const Color(0xff0b3d76),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          // Le widget Form nous permet de valider tous les champs en une fois
          child: Form(
            key: ctrl.formKey, // On lie le formulaire à la clé dans le contrôleur
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const FlutterLogo(size: 80),
                const SizedBox(height: 24),
                const Text(
                  "Connectez-vous",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                
                // --- Champ pour l'Email ---
                TextFormField(
                  controller: ctrl.emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: Validateur.validerEmail, // On utilise notre validateur
                ),
                const SizedBox(height: 16),

                // --- Champ pour le Mot de Passe ---
                // Obx permet de reconstruire ce widget quand une variable .obs change
                Obx(() => TextFormField(
                  controller: ctrl.passwordController,
                  obscureText: ctrl.isPasswordHidden.value, // Contrôlé par la variable
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        ctrl.isPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: ctrl.togglePasswordVisibility,
                    ),
                  ),
                  validator: Validateur.validerMotDePasse,
                )),
                const SizedBox(height: 32),
                
                // --- Bouton de Connexion ---
                Obx(() {
                  // Si isLoading est true, on affiche un indicateur de chargement
                  if (ctrl.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // Sinon, on affiche le bouton
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xff26a69a),
                    ),
                    onPressed: ctrl.seConnecter, // Appelle la méthode du contrôleur
                    child: const Text('Se Connecter', style: TextStyle(fontSize: 18)),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}