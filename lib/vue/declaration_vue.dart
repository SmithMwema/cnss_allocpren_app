import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../contrôleur/declaration_ctrl.dart';
import '../utilitaire/validateur.dart';

class DeclarationVue extends GetView<DeclarationCtrl> {
  const DeclarationVue({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Déclaration (MOD F1)"),
        backgroundColor: const Color(0xff1b263b),
      ),
      body: Obx(() => Stepper(
        type: StepperType.vertical,
        currentStep: controller.currentStep.value,
        onStepContinue: controller.onStepContinue,
        onStepCancel: controller.onStepCancel,
        steps: _buildSteps(context, controller),
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          final isLastStep = controller.currentStep.value == _buildSteps(context, controller).length - 1;
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: Text(isLastStep ? 'SOUMETTRE' : 'CONTINUER'),
                ),
                if (controller.currentStep.value > 0)
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('RETOUR'),
                  ),
              ],
            ),
          );
        },
      )),
    );
  }

  List<Step> _buildSteps(BuildContext context, DeclarationCtrl ctrl) {
    return [
      Step(
        title: const Text("I. Informations sur l'assuré(e)"),
        content: Form(
          key: ctrl.formKeyEtape1,
          child: Column(
            children: <Widget>[
              _buildTextField(controller: ctrl.nomAssureCtrl, label: 'Nom', validator: Validateur.validerChampObligatoire),
              _buildTextField(controller: ctrl.prenomAssureCtrl, label: 'Prénom', validator: Validateur.validerChampObligatoire),
              _buildTextField(controller: ctrl.etatCivilAssureCtrl, label: 'État civil', validator: Validateur.validerChampObligatoire),
              _buildTextField(controller: ctrl.numSecuAssureCtrl, label: 'N° Carte Sécurité Sociale', validator: Validateur.validerChampObligatoire),
              _buildTextField(controller: ctrl.adresseAssureCtrl, label: 'Adresse', validator: Validateur.validerChampObligatoire),
              _buildTextField(controller: ctrl.emailAssureCtrl, label: 'E-mail', keyboardType: TextInputType.emailAddress, validator: Validateur.validerEmail),
              _buildTextField(controller: ctrl.telAssureCtrl, label: 'Téléphone', keyboardType: TextInputType.number, validator: Validateur.validerTelephone),
              _buildTextField(controller: ctrl.employeurAssureCtrl, label: 'Employeur', validator: Validateur.validerChampObligatoire),
              _buildTextField(controller: ctrl.numAffiliationEmployeurCtrl, label: 'N° affiliation employeur', validator: Validateur.validerChampObligatoire),
              _buildTextField(controller: ctrl.adresseEmployeurCtrl, label: 'Adresse employeur', validator: Validateur.validerChampObligatoire),
            ],
          ),
        ),
        isActive: ctrl.currentStep.value >= 0,
      ),
      Step(
        title: const Text("II. Informations sur la bénéficiaire"),
        content: Form(
          key: ctrl.formKeyEtape2,
          child: Column(
            children: <Widget>[
              const Text("Remplir si différente de l'assurée."),
              _buildTextField(controller: ctrl.nomBeneficiaireCtrl, label: 'Nom'),
              _buildTextField(controller: ctrl.postNomBeneficiaireCtrl, label: 'Post-nom'),
              _buildTextField(
                controller: ctrl.dateNaissanceBeneficiaireCtrl,
                label: 'Date de naissance',
                readOnly: true,
                icon: Icons.calendar_today,
                onTap: () => ctrl.choisirDate(context, ctrl.dateNaissanceBeneficiaireCtrl, isDateDeNaissance: true),
              ),
              _buildTextField(
                controller: ctrl.datePrevueAccouchementCtrl,
                label: 'Date prévue d\'accouchement',
                readOnly: true,
                icon: Icons.calendar_today,
                validator: Validateur.validerChampObligatoire,
                onTap: () => ctrl.choisirDate(context, ctrl.datePrevueAccouchementCtrl),
              ),
            ],
          ),
        ),
        isActive: ctrl.currentStep.value >= 1,
      ),
      Step(
        title: const Text("Certificat Médical"),
        content: Column(
          children: <Widget>[
            OutlinedButton.icon(
              icon: const Icon(Icons.attach_file),
              label: const Text('Sélectionner un fichier'),
              onPressed: ctrl.selectionnerFichier,
            ),
            Obx(() => Text(ctrl.nomFichierSelectionne.value)),
          ],
        ),
        isActive: ctrl.currentStep.value >= 2,
      ),
    ];
  }

  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool readOnly = false,
    IconData? icon,
    VoidCallback? onTap,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), suffixIcon: icon != null ? Icon(icon) : null),
        validator: validator,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}