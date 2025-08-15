import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../modèle/dossier.dart';
import '../service/auth_service.dart';
import '../service/firestore_service.dart';

class DeclarationCtrl extends GetxController {
  final FirestoreService _firestore = Get.find<FirestoreService>();
  final AuthService _authService = Get.find<AuthService>();

  final formKeyEtape1 = GlobalKey<FormState>();
  final formKeyEtape2 = GlobalKey<FormState>();
  var currentStep = 0.obs;

  final nomAssureCtrl = TextEditingController();
  final prenomAssureCtrl = TextEditingController();
  final etatCivilAssureCtrl = TextEditingController();
  final numSecuAssureCtrl = TextEditingController();
  final adresseAssureCtrl = TextEditingController();
  final emailAssureCtrl = TextEditingController();
  final telAssureCtrl = TextEditingController();
  final employeurAssureCtrl = TextEditingController();
  final numAffiliationEmployeurCtrl = TextEditingController();
  final adresseEmployeurCtrl = TextEditingController();
  final nomBeneficiaireCtrl = TextEditingController();
  final postNomBeneficiaireCtrl = TextEditingController();
  final prenomBeneficiaireCtrl = TextEditingController();
  final etatCivilBeneficiaireCtrl = TextEditingController();
  final adresseBeneficiaireCtrl = TextEditingController();
  final emailBeneficiaireCtrl = TextEditingController();
  final telBeneficiaireCtrl = TextEditingController();
  final dateNaissanceBeneficiaireCtrl = TextEditingController();
  final lieuNaissanceBeneficiaireCtrl = TextEditingController();
  final datePrevueAccouchementCtrl = TextEditingController();
  final naturePrestationCtrl = TextEditingController();

  DateTime? _dateAccouchementSelectionnee;
  var nomFichierSelectionne = ''.obs;
  PlatformFile? fichierSelectionne;

  void soumettreDeclaration() async {
    if (_dateAccouchementSelectionnee == null) {
      Get.snackbar("Erreur", "Veuillez sélectionner la date prévue d'accouchement.");
      return;
    }
    if (fichierSelectionne == null) {
      Get.snackbar("Erreur", "Veuillez joindre le certificat médical.");
      return;
    }

    Get.dialog(const Center(child: CircularProgressIndicator()));

    try {
      final dossier = Dossier(
        userId: _authService.user!.uid, 
        nomAssure: nomAssureCtrl.text,
        prenomAssure: prenomAssureCtrl.text,
        dateSoumission: Timestamp.now(),
        statut: "Soumis",
      );
      
      await _firestore.soumettreNouveauDossier(dossier);

      Get.back();
      Get.snackbar("Succès", "Déclaration envoyée !");
      Future.delayed(const Duration(seconds: 2), () => Get.back());

    } catch (e) {
      Get.back();
      Get.snackbar("Erreur", "L'envoi a échoué.");
    }
  }

  // --- CONTENU DES MÉTHODES QUI MANQUAIENT ---

  Future<void> choisirDate(BuildContext context, TextEditingController controller, {bool isDateDeNaissance = false}) async {
    DateTime? dateChoisie = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: isDateDeNaissance ? DateTime(1920) : DateTime.now(),
      lastDate: isDateDeNaissance ? DateTime.now() : DateTime.now().add(const Duration(days: 300)),
    );
    if (dateChoisie != null) {
      if (!isDateDeNaissance) {
        _dateAccouchementSelectionnee = dateChoisie;
      }
      String dateFormatee = DateFormat('dd/MM/yyyy').format(dateChoisie);
      controller.text = dateFormatee;
    }
  }

  void onStepContinue() {
    bool estValide = false;
    if (currentStep.value == 0) { estValide = formKeyEtape1.currentState!.validate(); }
    else if (currentStep.value == 1) { estValide = formKeyEtape2.currentState!.validate(); }
    else if (currentStep.value == 2) { estValide = true; }

    if (estValide) {
      if (currentStep.value < 2) { currentStep.value += 1; }
      else { soumettreDeclaration(); }
    }
  }

  void onStepCancel() {
    if (currentStep.value > 0) { currentStep.value -= 1; }
    else { Get.back(); }
  }

  Future<void> selectionnerFichier() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      fichierSelectionne = result.files.first;
      nomFichierSelectionne.value = result.files.first.name;
    }
  }

  @override
  void onClose() {
    nomAssureCtrl.dispose();
    prenomAssureCtrl.dispose();
    etatCivilAssureCtrl.dispose();
    numSecuAssureCtrl.dispose();
    adresseAssureCtrl.dispose();
    emailAssureCtrl.dispose();
    telAssureCtrl.dispose();
    employeurAssureCtrl.dispose();
    numAffiliationEmployeurCtrl.dispose();
    adresseEmployeurCtrl.dispose();
    nomBeneficiaireCtrl.dispose();
    postNomBeneficiaireCtrl.dispose();
    prenomBeneficiaireCtrl.dispose();
    etatCivilBeneficiaireCtrl.dispose();
    adresseBeneficiaireCtrl.dispose();
    emailBeneficiaireCtrl.dispose();
    telBeneficiaireCtrl.dispose();
    dateNaissanceBeneficiaireCtrl.dispose();
    lieuNaissanceBeneficiaireCtrl.dispose();
    datePrevueAccouchementCtrl.dispose();
    naturePrestationCtrl.dispose();
    super.onClose();
  }
}