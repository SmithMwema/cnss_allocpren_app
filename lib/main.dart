import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'routes/app_pages.dart';
import 'service/auth_service.dart';
import 'service/firestore_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initialiserServices();
  runApp(const MyApp());
}

// --- CORRECTION DE L'ORDRE D'INITIALISATION ---
void initialiserServices() {
  // 1. On initialise d'abord FirestoreService, car AuthService en a besoin.
  Get.put(FirestoreService()); 
  // 2. Ensuite, on initialise AuthService.
  Get.put(AuthService()); 
}
// ---------------------------------------------

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CNSS App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        cardColor: Colors.white,
        dialogBackgroundColor: Colors.grey.shade100,
        colorScheme: const ColorScheme.light(
          primary: Color(0xff1b263b),
          secondary: Color(0xff26a69a),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        cardColor: const Color(0xff415a77),
        dialogBackgroundColor: const Color(0xff1b263b),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xff415a77),
          secondary: Color(0xff00a99d),
        ),
      ),
      themeMode: ThemeMode.system,
      initialRoute: AppPages.lancement,
      getPages: AppPages.routes,
    );
  }
}